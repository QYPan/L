#include "clientsocket.h"
#include <QHostAddress>
#include <QAbstractSocket>
#include <QDebug>
#include <QThread>
#include <QMetaType>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

ClientSocket::ClientSocket(QObject *parent)
    : QTcpSocket(parent)
{
    connect(this, &ClientSocket::readyRead, this, &ClientSocket::onReadyRead);
    connect(this, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(onError()));
    //connect(this, &ClientSocket::disconnected, this, &ClientSocket::deleteLater);
}

void ClientSocket::sendData(const QString &data){
    if(state() == QAbstractSocket::ConnectedState){
        qDebug() << "send data: " << data;
        write(data.toUtf8().data(), 1000);
    }else{
        qDebug() << "socket is disconnected";
    }
}

void ClientSocket::onError(){
    emit getError(error(), errorString());
}

void ClientSocket::onReadyRead(){
    char buffer[1000] = {0};
    read(buffer, bytesAvailable());
    //read(buffer, 1000);
    QString data(buffer);
    qDebug() << "read data: " << data;
    emit readData(data);
}
