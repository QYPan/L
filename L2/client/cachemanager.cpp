#include "cachemanager.h"
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

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

bool CacheManager::isLinkman(const QString &name){
    auto it = Linkmans.find(name);
    if(it != Linkmans.end()){
        return true;
    }
    return false;
}

QString CacheManager::getLinkmans(){
    auto it = Linkmans.begin();
    UserInfo userInfo;
    QJsonArray arrayObj;
    for(; it != Linkmans.end(); it++){
        userInfo = it.value();
        QJsonObject obj;
        obj.insert("name", userInfo.name);
        obj.insert("language", userInfo.language);
        obj.insert("sex", userInfo.sex);
        arrayObj.append(obj);
    }
    QJsonDocument document;
    document.setArray(arrayObj);
    QByteArray byteArray = document.toJson(QJsonDocument::Compact);
    QString data(byteArray);
    //qDebug() << "get linkmans";
    return data;
}

int CacheManager::addLinkman(const QString &name, const QString &language, int sex){
    UserInfo userInfo;
    userInfo.name = name;
    userInfo.language = language;
    userInfo.sex = sex;
    Linkmans[name] = userInfo;
    auto it = Linkmans.begin();
    int index = 0;
    for(; it != Linkmans.end(); it++,index++){
        if(it.key() == name){
            break;
        }
    }
    return index;
}

int CacheManager::removeLinkman(const QString &name){
    auto it = Linkmans.begin();
    int index = 0;
    for(; it != Linkmans.end(); it++,index++){
        if(it.key() == name){
            break;
        }
    }
    if(it != Linkmans.end()){
        Linkmans.erase(it);
        return index;
    }
    return -1;
}
