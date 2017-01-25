#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QWidget>
#include <QAbstractSocket>
#include "socketthread.h"

class QmlInterface : public QObject
{
    Q_OBJECT
public:
    QmlInterface(QObject *parent = 0);
signals:
    void qmlSendData(const QString &data);
    void qmlReadData(const QString &data);
    void qmlGetSocketState(const QString &stateMessage);
    void displayError(int socketError, const QString &message);
    void tryDisconnect();
public slots:
    void getSocketState(QAbstractSocket::SocketState socketState);
    void socketDisconnected(); // socket 断开
    void reconnect(); // 断线重连
    void connectSuccessed();
private:
    void tryConnect();
    void createSocketThread();
    SocketThread *thread;
};

#endif // QMLINTERFACE_H