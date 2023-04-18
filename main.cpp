#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSslSocket>
#include <QSettings>

#include "highlightsbackend.h"
#include "qqml.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Oulu Weather");

    QGuiApplication app(argc, argv);
    qDebug() << "Device supports OpenSSL: " << QSslSocket::supportsSsl();
    QQuickStyle::setStyle("Material");

    qmlRegisterType<HighlightsBackend>("Backend", 1, 0, "HighlightsBackend");
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
