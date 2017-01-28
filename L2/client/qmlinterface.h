#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QWidget>
#include <QAbstractSocket>
#include "socketthread.h"
#include "cachemanager.h"

class QmlInterface : public QObject
{
    Q_OBJECT
    Q_ENUMS(TextSize)
public:
    QmlInterface(QObject *parent = 0);
    enum TextSize {SizeA=13, SizeB=15, SizeC=20, SizeD, SizeE, SizeF, SizeG};
signals:
    void sendData(const QString &data);
    void qmlSendData(const QString &data);
    void qmlReadData(const QString &data);
    void qmlGetSocketState(const QString &stateMessage);
    void displayError(int socketError, const QString &message);
    void tryDisconnect();
public slots:
    void readData(const QString &data);
    void getSocketState(QAbstractSocket::SocketState socketState);
    void socketDisconnected(); // socket 断开
    void reconnect(); // 断线重连
    void connectSuccessed();
private:
    void tryConnect();
    void createSocketThread();
    void initCacheManager();
    CacheManager *cacheManager;
    SocketThread *thread;
};

#endif // QMLINTERFACE_H
