#ifndef HIGHLIGHTSBACKEND_H
#define HIGHLIGHTSBACKEND_H

#include <QObject>
#include <qqml.h>

#include "networkservice.h"
#include "stationforecastdata.h"

class HighlightsBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList cities READ cities CONSTANT)
    Q_PROPERTY(QStringList stations READ stations NOTIFY stationsChanged)

    Q_PROPERTY(StationForecastData* selectedStation READ selectedStation NOTIFY selectedStationChanged)
    QML_ELEMENT

public:
    using ForecastData = std::map<uint32_t, StationForecastData>;

public:
    explicit HighlightsBackend(QObject *parent = nullptr);

    QStringList cities();
    QStringList stations();

    Q_INVOKABLE StationForecastData *highestTemperature();
    Q_INVOKABLE StationForecastData *strongestWind();
    Q_INVOKABLE StationForecastData *lowestPressure();
    StationForecastData *selectedStation();

    Q_INVOKABLE void fetchStations(uint32_t cityIndex = 0);
    Q_INVOKABLE void fetchForecastData(uint32_t stationId);
    Q_INVOKABLE void onActivated(int index);

signals:
    void stationsChanged();
    void selectedStationChanged();
    void allFinished();

protected slots:
    void response(Json::Value, QNetworkReply*);

private:
    auto calculateHightestTemperature();
    auto calculateStrongestWind();
    auto calculateLowestPressure();

private:
    ForecastData m_Data;
    NetworkService m_Service;
    StationForecastData *m_HighestTemperature = nullptr;
    StationForecastData *m_StrongestWind = nullptr;
    StationForecastData *m_LowestPressure = nullptr;
    StationForecastData *m_SelectedStation = nullptr;

    static const QStringList s_Cities;
};

#endif // HIGHLIGHTSBACKEND_H
