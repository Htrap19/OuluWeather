#ifndef HIGHLIGHTSBACKEND_H
#define HIGHLIGHTSBACKEND_H

#include <QObject>
#include <qqml.h>

#include "networkservice.h"
#include "stationforecastdata.h"

class HighlightsBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList cities READ cities NOTIFY citiesChanged)
    Q_PROPERTY(QStringList stations READ stations NOTIFY stationsChanged)

    Q_PROPERTY(StationForecastData* highestTemperature READ highestTemperature NOTIFY highestTemperatureChanged)
    Q_PROPERTY(StationForecastData* strongestWind READ strongestWind NOTIFY strongestWindChanged)
    Q_PROPERTY(StationForecastData* lowestPressure READ lowestPressure NOTIFY lowestPressureChanged)
    Q_PROPERTY(StationForecastData* selectedStation READ selectedStation NOTIFY selectedStationChanged)
    QML_ELEMENT
public:
    explicit HighlightsBackend(QObject *parent = nullptr);

    QStringList cities();
    QStringList stations();

    StationForecastData *highestTemperature();
    StationForecastData *strongestWind();
    StationForecastData *lowestPressure();
    StationForecastData *selectedStation();

    Q_INVOKABLE void fetchStations(uint32_t cityIndex = 0);
    Q_INVOKABLE void fetchForecastData(uint32_t stationId);
    Q_INVOKABLE void onActivated(int index);

signals:
    void stationsChanged();
    void citiesChanged();
    void highestTemperatureChanged();
    void strongestWindChanged();
    void lowestPressureChanged();
    void selectedStationChanged();
    void allFinished();


protected slots:
    void response(Json::Value, QNetworkReply*);

private:
    QStringList m_Cities;
    std::map<uint32_t, StationForecastData> m_Data;
    NetworkService m_Service;
    StationForecastData* m_HighestTemperature = nullptr;
    StationForecastData* m_StrongestWind = nullptr;
    StationForecastData* m_LowestPressure = nullptr;
    StationForecastData* m_SelectedStation = nullptr;
};

#endif // HIGHLIGHTSBACKEND_H
