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
    qRegisterMetaType<DataStruct>("DataStruct");
    connect(this, &ClientSocket::readyRead, this, &ClientSocket::onReadyRead);
    connect(this, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(onError()));
    //connect(this, &ClientSocket::disconnected, this, &ClientSocket::deleteLater);
}

void ClientSocket::sendData(const DataStruct &data){
    qDebug() << data.name << "send data";
    merge(data);
}

void ClientSocket::onError(){
    emit getError(error(), errorString());
}

void ClientSocket::onReadyRead(){
    //qDebug() << "socket thread id: " << QThread::currentThreadId();
    /*
    QString buffer = readAll().data();
    resolve(buffer);
    */
    char char_buffer[2000] = {0};
    read(char_buffer, bytesAvailable());
    QString buffer(char_buffer);
    resolve(buffer);
}

void splitString(const QString &str, int k, QString &sub){
    int count = 0;
    int beg = 0;
    for(int i= 0; i < str.size(); i++){
        if(str[i] == '#' || i == str.size()-1){
            if(count == k){
                sub = str.mid(beg, i-beg);
                return;
            }
            else{
                beg = i + 1;
                count++;
                if(count == 2)
                    break;
            }
        }
    }
    if(beg == str.size()) sub = "";
    else sub = str.mid(beg);
}

// 合并数据并且发出去
void ClientSocket::merge(const DataStruct &data){
    QString name = data.name;
    int imark = static_cast<int>(data.mark);
    char smark[5];
    sprintf(smark, "%d", imark);
    QString mark = QString(smark);
    QString message = data.message;
    QString all = name + "#" + mark + "#" + message;
    //write(all.toUtf8());
    write(all.toUtf8().data(), 2000);
}

// 分解数据并且发给主线程
void ClientSocket::resolve(const QString &buffer){
    DataStruct data;
    QString mark;
    splitString(buffer, 0, data.name);
    splitString(buffer, 1, mark);
    splitString(buffer, 2, data.message);
    //qDebug() << "buffer: " << buffer;
    //qDebug() << "in socket name: " << data.name;
    //qDebug() << "in socket mark: " << mark;
    //qDebug() << "in socket mesa: " << data.message;
    data.mark = mark.toInt();
    data.ip = peerAddress().toString();
    data.port = peerPort();
    data.socket = this;
    emit readData(data);
}
