
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "qmlinterface.h"
#include "myeventfilter.h"
#include "fileoperator.h"
#include "cachetext.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<QmlInterface>("QmlInterface", 1, 0, "QmlInterface"); // 注册 socket 接口类
    qmlRegisterType<FileOperator>("FileOperator", 1, 0, "FileOperator"); // 注册文件操作接口类
    qmlRegisterType<CacheText>("CacheText", 1, 0, "CacheText"); // 注册缓存操作接口类

    QQmlApplicationEngine engine;
    MyEventFilter *backKeyFilter = new MyEventFilter;
    engine.rootContext()->setContextProperty("qmlInterface", new QmlInterface); // 定义接口实例
    engine.rootContext()->setContextProperty("fileOperator", new FileOperator); // 定义文件操作实例
    engine.rootContext()->setContextProperty("cacheText", new CacheText); // 定义缓存实例
    engine.rootContext()->setContextProperty("backKeyFilter", backKeyFilter); // 处理移动设备返回键
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject *root = NULL;
    QList<QObject *> rootObjects = engine.rootObjects();
    int count = rootObjects.size();
    for(int i = 0; i < count; i++){
        qDebug() << rootObjects.at(i)->objectName();
        if(rootObjects.at(i)->objectName() == "rootObject"){
            root = rootObjects.at(i);
            break;
        }
    }
    //backKeyFilter->setRoot(root);
    //backKeyFilter->installRootEventFilter();

    return app.exec();
}


/*
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml>
#include "clientsocket.h"
#include "clientmap.h"
#include "computergo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<ClientSocket>("ClientSocket", 1, 0, "ClientSocket");
    qmlRegisterType<ClientMap>("ClientMap", 1, 0, "ClientMap");

    QQuickView viewer;
    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.rootContext()->setContextProperty("socket", new ClientSocket);
    viewer.rootContext()->setContextProperty("computer", new ComputerGo);
    viewer.setSource(QUrl("qrc:///main.qml"));

    QQuickItem *root = NULL;
    root = viewer.rootObject();
    qDebug() << "root name: " << root->isVisible();

    viewer.show();

    return app.exec();
}

*/
