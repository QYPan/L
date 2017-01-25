#include "qmlinterface.h"
#include <QTest>

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , thread(NULL)
{
    createSocketThread();
    tryConnect();
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    connect(thread, &SocketThread::finished, this, &QmlInterface::reconnect);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::connectSuccessed);
    connect(this, &QmlInterface::tryDisconnect, thread, &SocketThread::quit);
}

void QmlInterface::reconnect(){
    qDebug() << "thread death!";
    QTest::qWait(3000);
    tryConnect();
}

void QmlInterface::connectSuccessed(){
    getSocketState(QAbstractSocket::ConnectedState);
    displayError(-2, "no error");
}

void QmlInterface::tryConnect(){
    if(!thread->tryConnect()){ // 已经连接了
    }
}

void QmlInterface::socketDisconnected(){
    emit displayError(-2, "socket disconnected!");
    emit tryDisconnect(); // 结束 socket 线程
}

void QmlInterface::getSocketState(QAbstractSocket::SocketState socketState){
    QString stateString;
    switch(socketState){
        case QAbstractSocket::UnconnectedState:
            stateString = "The socket is not connected";
            break;
        case QAbstractSocket::HostLookupState:
            stateString = "The socket is performing a host name lookup";
            break;
        case QAbstractSocket::ConnectingState:
            stateString = "The socket has started establishing a connection";
            break;
        case QAbstractSocket::ConnectedState:
            stateString = "A connection is established";
            break;
        case QAbstractSocket::BoundState:
            stateString = "The socket is bound to an address and port";
            break;
        case QAbstractSocket::ClosingState:
            stateString = "The socket is about to close (data may still be waiting to be written)";
            break;
        case QAbstractSocket::ListeningState:
            stateString = "For internal use only";
            break;
    }
    emit qmlGetSocketState(stateString);
}
