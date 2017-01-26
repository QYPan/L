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
    QTimer send_timer, count_timer;
    //socket.connectToHost("118.89.35.51", 60000);
    //socket.connectToHost("118.89.35.51", 9734);
    socket.connectToHost("127.0.0.1", 9658);
    if (!socket.waitForConnected(timeOut)) {
        emit error(socket.error(), socket.errorString());
        return;
    }
    qDebug() << "connect successed!";
    connect(&socket, SIGNAL(getError(int,QString)), m_receiver.data(), SIGNAL(displayError(int,QString)));
    connect(&socket, SIGNAL(readData(QString)), m_receiver.data(), SIGNAL(qmlReadData(QString)));
    connect(&socket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            m_receiver.data(), SLOT(getSocketState(QAbstractSocket::SocketState)));
    connect(&socket, SIGNAL(disconnected()), m_receiver.data(), SLOT(socketDisconnected()));
    connect(m_receiver.data(), SIGNAL(qmlSendData(QString)), &socket, SLOT(sendData(QString)));

    int heartCount = 0;

    connect(&socket, &ClientSocket::readData, [&](){
        heartCount = 0; // 接收到数据，心跳置为初始值
    });

    connect(&count_timer, &QTimer::timeout, [&](){
        if(!heartCount){
            heartCount = 1;
        }else{ // 心跳超时
            this->quit();
        }
    });

    connect(&send_timer, &QTimer::timeout, [&](){
        QJsonObject heart_json;
        heart_json.insert("mtype", "SYN");
        heart_json.insert("dtype", "HEART");
        QJsonDocument heart_document;
        heart_document.setObject(heart_json);
        QByteArray byteArray = heart_document.toJson(QJsonDocument::Compact);
        QString heart_data(byteArray);
        socket.sendData(heart_data);
    });

    //socket.sendData("heart"); // 连接建立后立即发送第一个心跳
    send_timer.start(15000);
    count_timer.start(20000);

    emit connectSuccessed();
    /*
    connect(&socket, &ClientSocket::getError, m_receiver.data(), &QmlInterface::error);
    connect(&socket, &ClientSocket::readData, m_receiver.data(), &QmlInterface::readData);
    connect(m_receiver.data(), &QmlInterface::sendData, &socket, &ClientSocket::sendData);
    */
    exec();
}
