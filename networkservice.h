#ifndef NETWORKSERVICE_H
#define NETWORKSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <json/value.h>

class NetworkService : public QObject
{
    Q_OBJECT
public:
    explicit NetworkService(QObject *parent = nullptr);

    void get(QUrl);

protected slots:
    void parseJson(QNetworkReply *);

signals:
    void readyResponse(Json::Value, QNetworkReply *);

private:
    QScopedPointer<QNetworkAccessManager> m_Manager;
};

#endif // NETWORKSERVICE_H
