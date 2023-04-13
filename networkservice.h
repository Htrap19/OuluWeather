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
    void networkError(QNetworkReply*);
    void parsingError(QString);
    void readyResponse(Json::Value, QNetworkReply *);

private:
    QNetworkAccessManager m_Manager;
};

#endif // NETWORKSERVICE_H
