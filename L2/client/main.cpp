#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "qmlinterface.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QmlInterface>("QmlInterface", 1, 0, "QmlInterface"); // 注册逻辑交互接口类

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("qmlInterface", new QmlInterface); // 定义接口实例
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
