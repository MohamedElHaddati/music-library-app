#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "controller/MusicController.h"
#include "dao/Database.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Initialize Database
    Database::instance().initialize();

    QQmlApplicationEngine engine;
    
    // Create Controller and expose to QML
    MusicController controller;
    engine.rootContext()->setContextProperty("musicController", &controller);

    // Fix: Qt 6.5+ with QTP0001=NEW uses "qt/qml" prefix by default.
    // The path structure is: qt/qml/<ModuleURI>/<RelativeFilePath>
    const QUrl url(QStringLiteral("qrc:/qt/qml/MusicManager/qml/Main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}
