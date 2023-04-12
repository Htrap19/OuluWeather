#include "highlightsbackend.h"

#include <QThread>
#include <algorithm>
#include <iterator>
#include <string>
#include <utility>

HighlightsBackend::HighlightsBackend(QObject *parent)
    : QObject{parent},
    m_Cities({ "oulu", "helsinki" }),
    m_Stations({}),
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
    std::transform(m_Stations.begin(),
                   m_Stations.end(),
                   std::back_inserter(names),
                   [](const StationData& i) { return i.name; });
    return names;
}

QString HighlightsBackend::highestTemperature()
{
    QString format = "%1 C";
    if (m_ForecastData.empty())
        return format.arg("-");

    auto data = std::max_element(m_ForecastData.begin(),
                                 m_ForecastData.end(),
                                 [](const std::pair<uint32_t, ForecastData>& a,
                                    const std::pair<uint32_t, ForecastData>& b)
                                 {
                                     return a.second.temperature < b.second.temperature;
                                 });

    return format
        .arg(QString::number(data->second.temperature));
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

void HighlightsBackend::response(Json::Value content, QNetworkReply* reply)
{
    // Response 1 - fetchStations
    if (content.isMember("municipalityCode"))
    {
        m_Stations.clear();
        m_ForecastData.clear();
        for (auto& v : content["observationStations"]
                              ["dropdownItems"])
        {
            auto& obj = m_Stations.emplaceBack(StationData{
                v["distance"].asCString(),
                v["station"].asCString(),
                v["value"].asUInt()
            });
            fetchForecastData(obj.id);
            emit stationsChanged();
        }
        return;
    }

    // Response 2 - fetchForcastData
    auto observationsList = content["observations"];
    auto data = observationsList[1007];
    auto query = reply->url().query();
    uint32_t id = query.split('&')[0].split('=')[1].toUInt();

    m_ForecastData[id] = {
        data["t2m"].asFloat(),
        data["dewPoint"].asFloat(),
        data["WindSpeedMS"].asFloat(),
        data["WindGust"].asFloat(),
        data["Pressure"].asFloat(),
        data["Humidity"].asInt(),
        data["Visibility"].asInt(),
    };

    if (m_Stations.size() == m_ForecastData.size())
        emit highestTemperatureChanged();
}

void HighlightsBackend::error()
{
    qDebug() << "Network Error!!!";
}
