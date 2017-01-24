#include "socketthread.h"
#include "clientsocket.h"
#include "qmlinterface.h"
#include <QTcpSocket>
#include <QMetaType>
#include <QAbstractSocket>
#include <QDebug>

SocketThread::SocketThread(QObject *parent)
    : m_receiver(parent)
{
    qRegisterMetaType<QAbstractSocket::SocketState>();
}

bool SocketThread::tryConnect(){
    if(!isRunning()){
        start();
        qDebug() << "new thread start!";
        return true;
    }
    return false;
}

void SocketThread::run(){
    const int timeOut = 5 * 1000;
    ClientSocket socket;
    //socket.connectToHost("118.89.35.51", 60000);
    //socket.connectToHost("118.89.35.51", 9734);
    socket.connectToHost("127.0.0.1", 9734);
    if (!socket.waitForConnected(timeOut)) {
        emit error(socket.error(), socket.errorString());
        return;
    }
    qDebug() << "connect successed!";
    connect(&socket, SIGNAL(getError(int,QString)), m_receiver.data(), SIGNAL(displayError(int,QString)));
    connect(&socket, SIGNAL(readData(QString)), m_receiver.data(), SIGNAL(qmlReadData(QString)));
    connect(&socket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            m_receiver.data(), SLOT(getSocketState(QAbstractSocket::SocketState)));
    connect(m_receiver.data(), SIGNAL(qmlSendData(QString)), &socket, SLOT(sendData(QString)));
    //emit connectSuccessed();
    /*
    connect(&socket, &ClientSocket::getError, m_receiver.data(), &QmlInterface::error);
    connect(&socket, &ClientSocket::readData, m_receiver.data(), &QmlInterface::readData);
    connect(m_receiver.data(), &QmlInterface::sendData, &socket, &ClientSocket::sendData);
    */
    exec();
}
