#include "qmlinterface.h"

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , thread(NULL)
{
    createSocketThread();
    tryConnect();
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    //connect(thread, &SocketThread::finished, thread, &SocketThread::deleteLater);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    //connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::tryLoginOrRegister);
    connect(this, &QmlInterface::tryDisconnect, thread, &SocketThread::quit);
}

void QmlInterface::tryConnect(){
    if(!thread->tryConnect()){ // 已经连接了
    }
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
