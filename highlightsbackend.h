#ifndef HIGHLIGHTSBACKEND_H
#define HIGHLIGHTSBACKEND_H

#include <QObject>
#include <qqml.h>

#include "networkservice.h"

struct StationData
{
    QString distance;
    QString name;
    uint32_t id;
};

struct ForecastData
{
    float temperature;
    float dewPoint;
    float windSpeedMS;
    float windGust;
    float pressure;
    int humidity;
    int visibility;
};

class HighlightsBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList cities READ cities NOTIFY citiesChanged)
    Q_PROPERTY(QStringList stations READ stations NOTIFY stationsChanged)

    Q_PROPERTY(QString highestTemperature READ highestTemperature NOTIFY highestTemperatureChanged)
    QML_ELEMENT
public:
    explicit HighlightsBackend(QObject *parent = nullptr);

    QStringList cities();
    QStringList stations();

    QString highestTemperature();

    Q_INVOKABLE void fetchStations(uint32_t cityIndex = 0);
    Q_INVOKABLE void fetchForecastData(uint32_t stationId);

signals:
    void stationsChanged();
    void citiesChanged();

    void highestTemperatureChanged();

protected slots:
    void response(Json::Value, QNetworkReply*);
    void error();

private:
    QStringList m_Cities;
    QList<StationData> m_Stations;
    std::map<uint32_t, ForecastData> m_ForecastData;
    NetworkService m_Service;
};

#endif // HIGHLIGHTSBACKEND_H
