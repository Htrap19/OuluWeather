#include "highlightsbackend.h"
#include "stationforecastdata.h"

#include <QThread>
#include <algorithm>
#include <iterator>
#include <string>
#include <utility>

HighlightsBackend::HighlightsBackend(QObject *parent)
    : QObject{parent},
    m_Cities({ "oulu", "helsinki", "lappeenranta" }),
    m_Service(parent)
{
    connect(&m_Service, &NetworkService::readyResponse,
            this, &HighlightsBackend::response);
}

QStringList HighlightsBackend::cities()
{
    return m_Cities;
}

QStringList HighlightsBackend::stations()
{
    QStringList names;
    std::transform(m_Data.begin(),
                   m_Data.end(),
                   std::back_inserter(names),
                   [](const std::pair<const uint32_t, StationForecastData>& i) { return i.second.name(); });
    return names;
}

StationForecastData *HighlightsBackend::highestTemperature()
{
    if (m_Data.empty())
        return nullptr;

    auto data = std::max_element(m_Data.begin(),
                                 m_Data.end(),
                                 [](const std::pair<const uint32_t, StationForecastData>& a,
                                    const std::pair<const uint32_t, StationForecastData>& b)
                                 {
                                     return a.second.temperature() < b.second.temperature();
                                 });
    return &(data->second);
}

StationForecastData *HighlightsBackend::strongestWind()
{
    if (m_Data.empty())
        return nullptr;

    auto data = std::max_element(m_Data.begin(),
                                 m_Data.end(),
                                 [](const std::pair<const uint32_t, StationForecastData>& a,
                                    const std::pair<const uint32_t, StationForecastData>& b)
                                 {
                                     return a.second.windSpeedMS() < b.second.windSpeedMS();
                                 });
    return &(data->second);
}

StationForecastData *HighlightsBackend::lowestPressure()
{
    if (m_Data.empty())
        return nullptr;

    auto data = std::min_element(m_Data.begin(),
                                 m_Data.end(),
                                 [](const std::pair<const uint32_t, StationForecastData>& a,
                                    const std::pair<const uint32_t, StationForecastData>& b)
                                 {
                                     return (b.second.pressure() == 0 ||
                                             a.second.pressure() < b.second.pressure());
                                 });
    return &(data->second);
}

StationForecastData *HighlightsBackend::selectedStation()
{
    return m_SelectedStation;
}

void HighlightsBackend::fetchStations(uint32_t cityIndex)
{
    m_Service.get(QUrl(QString("https://en.ilmatieteenlaitos.fi/api/weather/forecasts?place=%1")
                           .arg(m_Cities[cityIndex])));
}

void HighlightsBackend::fetchForecastData(uint32_t stationId)
{
    auto url = QString("https://en.ilmatieteenlaitos.fi/api/weather/observations?fmisid=%1&observations=true")
                   .arg(QString::number(stationId));
    m_Service.get(QUrl(url));
}

void HighlightsBackend::onActivated(int index)
{
    auto data = m_Data.begin();
    std::advance(data, index);
    m_SelectedStation = &(data->second);
    emit selectedStationChanged();
}

void HighlightsBackend::response(Json::Value content, QNetworkReply* reply)
{
    // Response 1 - fetchStations
    if (content.isMember("municipalityCode"))
    {
        m_Data.clear();
        for (auto& v : content["observationStations"]
                              ["dropdownItems"])
        {
            uint32_t id = v["value"].asUInt();
            auto& obj = m_Data[id];
            obj.m_Distance = v["distance"].asCString();
            obj.m_Name     = v["station"].asCString();
            fetchForecastData(id);
            emit stationsChanged();
        }
        return;
    }

    // Response 2 - fetchForcastData
    auto observationsList = content["observations"];
    auto data = observationsList[1007];
    auto query = reply->url().query();
    uint32_t id = query.split('&')[0].split('=')[1].toUInt();

    auto& obj = m_Data[id];
    obj.m_Temperature = data["t2m"].asFloat();
    obj.m_DewPoint    = data["DewPoint"].asFloat();
    obj.m_WindSpeedMS = data["WindSpeedMS"].asFloat();
    obj.m_WindGust    = data["WindGust"].asFloat();
    obj.m_Pressure    = data["Pressure"].asFloat();
    obj.m_Humidity    = data["Humidity"].asInt();
    obj.m_Visibility  = data["Visibility"].asInt();

    emit highestTemperatureChanged();
    emit strongestWindChanged();
    emit lowestPressureChanged();
    onActivated(0);

    auto children = reply->manager()->findChildren<QNetworkReply*>();
    if (std::all_of(children.begin(),
                    children.end(),
                    [](const QNetworkReply* child)
                    { return child->isFinished(); }))
        emit allFinished();
}
