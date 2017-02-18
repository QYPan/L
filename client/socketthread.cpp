#include "socketthread.h"
#include "clientsocket.h"
#include "qmlinterface.h"
#include <QTcpSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <QByteArray>
#include <QMetaType>
#include <QTimer>
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
    QTimer sendTimer, countTimer;
    //socket.connectToHost("118.89.35.51", 60000);
    //socket.connectToHost("118.89.35.51", 9658);
    //socket.connectToHost("127.0.0.1", 9658);
    socket.connectToHost("118.89.35.51", 9658);
    if (!socket.waitForConnected(timeOut)) {
        emit error(socket.error(), socket.errorString());
        return;
    }
    //qDebug() << "connect successed!";
    connect(&socket, SIGNAL(getError(int,QString)), m_receiver.data(), SIGNAL(displayError(int,QString)));
    connect(&socket, SIGNAL(readData(QString)), m_receiver.data(), SLOT(readData(QString)));
    connect(&socket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            m_receiver.data(), SLOT(getSocketState(QAbstractSocket::SocketState)));
    connect(&socket, SIGNAL(disconnected()), m_receiver.data(), SLOT(socketDisconnected()));
    connect(&socket, SIGNAL(getError(int,QString)), m_receiver.data(), SLOT(socketDisconnected()));
    connect(m_receiver.data(), SIGNAL(qmlSendData(QString)), &socket, SLOT(sendData(QString)));

    bool counter = true;

    connect(&countTimer, &QTimer::timeout, [&](){
        if(!counter){ // 发出心跳包后一定时间内没有收到应答(可能是心跳应答，可能是数据包)
            this->quit();
        }
    });

    connect(&socket, &ClientSocket::readData, [&](){
        counter = true;
    });

    connect(&sendTimer, &QTimer::timeout, [&](){
        QJsonObject obj;
        obj.insert("mtype", "SYN");
        obj.insert("dtype", "HEART");
        QJsonDocument document;
        document.setObject(obj);
        QByteArray byteArray = document.toJson(QJsonDocument::Compact);
        QString data(byteArray);
        socket.sendData(data);
        countTimer.stop();
        countTimer.start(5000);
        counter = false;
    });

    //socket.sendData("heart"); // 连接建立后立即发送第一个心跳
    sendTimer.start(15000);

    emit connectSuccessed();
    /*
    connect(&socket, &ClientSocket::getError, m_receiver.data(), &QmlInterface::error);
    connect(&socket, &ClientSocket::readData, m_receiver.data(), &QmlInterface::readData);
    connect(m_receiver.data(), &QmlInterface::sendData, &socket, &ClientSocket::sendData);
    */
    exec();
}
