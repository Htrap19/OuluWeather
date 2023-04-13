#include "networkservice.h"
#include "qnetworkreply.h"

#include <QThread>
#include <QDebug>
#include <json/reader.h>
#include <memory>

NetworkService::NetworkService(QObject *parent)
    : QObject{parent},
    m_Manager(this)
{
    connect(&m_Manager, &QNetworkAccessManager::finished,
            this, &NetworkService::parseJson);
}

void NetworkService::get(QUrl url)
{
    m_Manager.get(QNetworkRequest(url));
}

void NetworkService::parseJson(QNetworkReply *reply)
{
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError)
    {
        emit networkError(reply);
        return;
    }

    auto res = reply->readAll().toStdString();
    Json::Value root;
    std::string err;

    Json::CharReaderBuilder builder;
    const QScopedPointer<Json::CharReader> reader(builder.newCharReader());

    if (!reader->parse(res.c_str(),
                       res.c_str() + (int)res.size(),
                       &root,
                       &err))
    {
        emit parsingError(QString::fromStdString(err));
        return;
    }

    emit readyResponse(root, reply);
}

