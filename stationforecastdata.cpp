#include "stationforecastdata.h"

StationForecastData::StationForecastData(QObject *parent)
    : QObject{parent}
{
}

QString StationForecastData::distance() const
{
    if (!m_Distance)
        return "";

    return m_Distance.value();
}

QString StationForecastData::name() const
{
    if (!m_Name)
        return "";

    return m_Name.value();
}

float StationForecastData::temperature() const
{
    if (!m_Temperature)
        return INVALID_VALUE;

    return m_Temperature.value();
}

float StationForecastData::dewPoint() const
{
    if (!m_DewPoint)
        return INVALID_VALUE;

    return m_DewPoint.value();
}


float StationForecastData::windSpeedMS() const
{
    if (!m_WindSpeedMS)
        return INVALID_VALUE;

    return m_WindSpeedMS.value();
}

float StationForecastData::windGust() const
{
    if (!m_WindGust)
        return INVALID_VALUE;

    return m_WindGust.value();
}

float StationForecastData::pressure() const
{
    if (!m_Pressure)
        return INVALID_VALUE;

    return m_Pressure.value();
}

int StationForecastData::humidity() const
{
    if (!m_Humidity)
        return INVALID_VALUE;

    return m_Humidity.value();
}

int StationForecastData::visibility() const
{
    if (!m_Visibility)
        return INVALID_VALUE;

    return m_Visibility.value();
}
