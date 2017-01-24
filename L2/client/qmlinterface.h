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
private:
    void tryConnect();
    void createSocketThread();
    SocketThread *thread;
};

#endif // QMLINTERFACE_H
