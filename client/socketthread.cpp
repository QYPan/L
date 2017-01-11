#include "socketthread.h"
#include "clientsocket.h"
#include "datastruct.h"
#include "qmlinterface.h"
#include <QTcpSocket>
#include <QDebug>

SocketThread::SocketThread(QObject *parent)
    : m_receiver(parent)
{
    qRegisterMetaType<DataStruct>("DataStruct");
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
    connect(&socket, SIGNAL(readData(DataStruct)), m_receiver.data(), SLOT(readData(DataStruct)));
    connect(m_receiver.data(), SIGNAL(sendData(DataStruct)), &socket, SLOT(sendData(DataStruct)));
    emit connectSuccessed();
    /*
    connect(&socket, &ClientSocket::getError, m_receiver.data(), &QmlInterface::error);
    connect(&socket, &ClientSocket::readData, m_receiver.data(), &QmlInterface::readData);
    connect(m_receiver.data(), &QmlInterface::sendData, &socket, &ClientSocket::sendData);
    */
    exec();
}
