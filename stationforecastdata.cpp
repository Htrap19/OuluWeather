#include "stationforecastdata.h"

StationForecastData::StationForecastData(QObject *parent)
    : QObject{parent}
{
}

QString StationForecastData::distance() const
{
    return m_Distance;
}

QString StationForecastData::name() const
{
    return m_Name;
}

float StationForecastData::temperature() const
{
    return m_Temperature;
}

float StationForecastData::dewPoint() const
{
    return m_DewPoint;
}


float StationForecastData::windSpeedMS() const
{
    return m_WindSpeedMS;
}

float StationForecastData::windGust() const
{
    return m_WindGust;
}

float StationForecastData::pressure() const
{
    return m_Pressure;
}

int StationForecastData::humidity() const
{
    return m_Humidity;
}

int StationForecastData::visibility() const
{
    return m_Visibility;
}
