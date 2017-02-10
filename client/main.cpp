#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "qmlinterface.h"
#include "cachemanager.h"
#include "textsize.h"
#include "signalmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<CacheManager>("CacheManager", 1, 0, "CacheManager"); // 注册缓存接口类
    qmlRegisterType<QmlInterface>("QmlInterface", 1, 0, "QmlInterface"); // 注册逻辑交互接口类
    qmlRegisterType<TextSize>("TextSize", 1, 0, "TextSize"); // 注册字体大小接口类
    qmlRegisterType<SignalManager>("SignalManager", 1, 0, "SignalManager"); // 注册信号管理接口类

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("qmlInterface", new QmlInterface); // 定义接口实例
    engine.rootContext()->setContextProperty("choseTextSize", new TextSize); // 定义接口实例
    engine.rootContext()->setContextProperty("signalManager", new SignalManager); // 定义接口实例
    engine.rootContext()->setContextProperty("cacheManager", new CacheManager); // 定义接口实例
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
