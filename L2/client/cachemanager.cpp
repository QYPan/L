#include "cachemanager.h"
#include <QDebug>

CacheManager::CacheManager(QObject *parent)
    : QObject(parent)
{
}

void CacheManager::hadReceiveACK(bool flag){
    if(!dataList.isEmpty()){
        if(flag){ // 收到消息 ACK
            qDebug() << "received ack";
            dataList.pop_front();
            if(!dataList.isEmpty()){
                emit sendData(dataList.first());
            }
        }else{ // 需要重新发送该消息
            qDebug() << "do not receive ack";
            emit sendData(dataList.first());
        }
    }
}

void CacheManager::addData(const QString &data){
    qDebug() << "add data: " << data;
    dataList.append(data);
    if(dataList.length() == 1){
        emit sendData(data);
    }
}
