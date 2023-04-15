#include "highlightsbackend.h"
#include "qhostinfo.h"
#include "stationforecastdata.h"

#include <QTimer>
#include <algorithm>
#include <iterator>
#include <string>
#include <utility>

const QStringList HighlightsBackend::s_Cities = {
    "Oulu",
    "Helsinki",
    "Lappeenranta"
};

// Json key mappings
constexpr const char* c_MunicipalityCodeKey     = "municipalityCode";
constexpr const char* c_ObservationStationsKey  = "observationStations";
constexpr const char* c_DropDownItemsKey        = "dropdownItems";
constexpr const char* c_ValueKey                = "value";
constexpr const char* c_DistanceKey             = "distance";
constexpr const char* c_StationKey              = "station";
constexpr const char* c_ObservationsKey         = "observations";
constexpr const char* c_TemperatureKey          = "t2m";
constexpr const char* c_DewPointKey             = "DewPoint";
constexpr const char* c_WindSpeedMSKey          = "WindSpeedMS";
constexpr const char* c_WindGustKey             = "WindGust";
constexpr const char* c_PressureKey             = "Pressure";
constexpr const char* c_HumidityKey             = "Humidity";
constexpr const char* c_VisibilityKey           = "Visibility";

HighlightsBackend::HighlightsBackend(QObject *parent)
    : QObject{parent},
    m_Service(parent)
{
    connect(&m_Service, &NetworkService::readyResponse,
            this, &HighlightsBackend::response);
}

QStringList HighlightsBackend::cities()
{
    return s_Cities;
}

QStringList HighlightsBackend::stations()
{
    QStringList names;
    std::transform(m_Data.begin(),
                   m_Data.end(),
                   std::back_inserter(names),
                   [](ForecastData::value_type& i)
                   { return i.second.name(); });
    return names;
}

StationForecastData *HighlightsBackend::highestTemperature()
{
    return m_HighestTemperature;
}

StationForecastData *HighlightsBackend::strongestWind()
{
    return m_StrongestWind;
}

StationForecastData *HighlightsBackend::lowestPressure()
{
    return m_LowestPressure;
}

StationForecastData *HighlightsBackend::selectedStation()
{
    return m_SelectedStation;
}

void HighlightsBackend::fetchStations(uint32_t cityIndex)
{
    m_Service.get(QUrl(QString("https://en.ilmatieteenlaitos.fi/api/weather/forecasts?place=%1")
                           .arg(s_Cities[cityIndex].toLower())));
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

auto HighlightsBackend::calculateHightestTemperature()
{
    return std::max_element(m_Data.begin(),
                            m_Data.end(),
                            [](ForecastData::value_type& a,
                               ForecastData::value_type& b)
                            {
                                return a.second.temperature() < b.second.temperature();
                            });
}

auto HighlightsBackend::calculateStrongestWind()
{
    return std::max_element(m_Data.begin(),
                            m_Data.end(),
                            [](ForecastData::value_type& a,
                               ForecastData::value_type& b)
                            {
                                return a.second.windSpeedMS() < b.second.windSpeedMS();
                            });
}

auto HighlightsBackend::calculateLowestPressure()
{
    return std::min_element(m_Data.begin(),
                            m_Data.end(),
                            [](ForecastData::value_type& a,
                               ForecastData::value_type& b)
                            {
                                return (b.second.pressure() == 0 ||
                                        a.second.pressure() < b.second.pressure());
                            });
}

void HighlightsBackend::response(Json::Value content, QNetworkReply* reply)
{
    // Response 1 - fetchStations
    if (content.isMember(c_MunicipalityCodeKey))
    {
        m_Data.clear();
        for (auto& v : content[c_ObservationStationsKey]
                              [c_DropDownItemsKey])
        {
            uint32_t id = v[c_ValueKey].asUInt();
            auto& obj = m_Data[id];
            obj.m_Distance = v[c_DistanceKey].asCString();
            obj.m_Name     = v[c_StationKey].asCString();
            fetchForecastData(id);
            emit stationsChanged();
        }
        return;
    }

    // Response 2 - fetchForcastData
    auto observationsList = content[c_ObservationsKey];
    auto query = reply->url().query();
    uint32_t id = query.split('&')[0].split('=')[1].toUInt();

    if (observationsList.size() > 0)
    {
        uint32_t lastIndex = observationsList.size() - 1;
        auto data = observationsList[lastIndex];
        while (data[c_TemperatureKey].isNull())
            data = observationsList[--lastIndex];

        auto& obj = m_Data[id];
        obj.m_Temperature = data[c_TemperatureKey].asFloat();
        obj.m_DewPoint    = data[c_DewPointKey].asFloat();
        obj.m_WindSpeedMS = data[c_WindSpeedMSKey].asFloat();
        obj.m_WindGust    = data[c_WindGustKey].asFloat();
        obj.m_Pressure    = data[c_PressureKey].asFloat();
        obj.m_Humidity    = data[c_HumidityKey].asInt();
        obj.m_Visibility  = data[c_VisibilityKey].asInt();
    }
    else
    {
        m_Data.erase(id);
        emit stationsChanged();
    }

    auto children = reply->manager()->findChildren<QNetworkReply*>();
    if (std::all_of(children.begin(),
                    children.end(),
                    [](const QNetworkReply* child)
                    { return child->isFinished(); }))
    {
        onActivated(0);
        m_HighestTemperature = &(calculateHightestTemperature()->second);
        m_StrongestWind = &(calculateStrongestWind()->second);
        m_LowestPressure = &(calculateLowestPressure()->second);
        emit allFinished();
    }
}
