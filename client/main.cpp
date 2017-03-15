#include <QGuiApplication>
#include <QQmlContext>
#include <QObject>
#include <QDir>
#include <QQmlApplicationEngine>
#include "qmlinterface.h"
#include "cachemanager.h"
#include "textsize.h"
#include "signalmanager.h"
#include "voicemsgmanager.h"
#include "recordmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<CacheManager>("CacheManager", 1, 0, "CacheManager"); // 注册缓存接口类
    qmlRegisterType<QmlInterface>("QmlInterface", 1, 0, "QmlInterface"); // 注册逻辑交互接口类
    qmlRegisterType<TextSize>("TextSize", 1, 0, "TextSize"); // 注册字体大小接口类
    qmlRegisterType<SignalManager>("SignalManager", 1, 0, "SignalManager"); // 注册信号管理接口类
    qmlRegisterType<RecordManager>("RecordManager", 1, 0, "RecordManager"); // 注册录音管理接口类
    qmlRegisterType<VoiceMsgManager>("VoiceMsgManager", 1, 0, "VoiceMsgManager"); // 注册语音消息管理接口类

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("qmlInterface", new QmlInterface); // 定义接口实例
    engine.rootContext()->setContextProperty("choseTextSize", new TextSize); // 定义接口实例
    engine.rootContext()->setContextProperty("signalManager", new SignalManager); // 定义接口实例
    engine.rootContext()->setContextProperty("cacheManager", new CacheManager); // 定义接口实例
    engine.rootContext()->setContextProperty("recordManager", new RecordManager); // 定义接口实例
    engine.rootContext()->setContextProperty("voiceMsgManager", new VoiceMsgManager); // 定义接口实例
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject::connect(&app, &QGuiApplication::aboutToQuit, [](){
        QString voiceDir = QDir::currentPath() + "/voice";
        QDir dir(voiceDir);
        dir.removeRecursively();
    });

    return app.exec();
}
