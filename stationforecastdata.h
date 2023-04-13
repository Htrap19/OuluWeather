#ifndef STATIONFORECASTDATA_H
#define STATIONFORECASTDATA_H

#include <QObject>
#include <qqml.h>
#include <cmath>
#include <limits>

class StationForecastData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString distance READ distance NOTIFY distanceChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(float temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(float dewPoint READ dewPoint NOTIFY dewPointChanged)
    Q_PROPERTY(float windSpeedMS READ windSpeedMS NOTIFY windSpeedMSChanged)
    Q_PROPERTY(float windGust READ windGust NOTIFY windGustChanged)
    Q_PROPERTY(float pressure READ pressure NOTIFY pressureChanged)
    Q_PROPERTY(float humidity READ humidity NOTIFY humidityChanged)
    Q_PROPERTY(float visibility READ visibility NOTIFY visibilityChanged)
    QML_ELEMENT
public:
    explicit StationForecastData(QObject *parent = nullptr);

    QString distance() const;
    QString name() const;
    float temperature() const;
    float dewPoint() const;
    float windSpeedMS() const;
    float windGust() const;
    float pressure() const;
    int humidity() const;
    int visibility() const;

signals:
    void distanceChanged();
    void nameChanged();
    void temperatureChanged();
    void dewPointChanged();
    void windSpeedMSChanged();
    void windGustChanged();
    void pressureChanged();
    void humidityChanged();
    void visibilityChanged();

public:
    QString m_Distance;
    QString m_Name;
    float m_Temperature;
    float m_DewPoint;
    float m_WindSpeedMS;
    float m_WindGust;
    float m_Pressure;
    int m_Humidity;
    int m_Visibility;
};

#endif // STATIONFORECASTDATA_H
