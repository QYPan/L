#include "cachetext.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <QDebug>

CacheText::CacheText(QObject *parent)
    : QObject(parent)
    , seg_char('\n')
{

}

void CacheText::push(int type, const QString &message){
    messageList[type] << message;
}

QString CacheText::pop(int type){
    auto it = messageList.find(type);
    QString ans;
    if(it != messageList.end()){
        ans =  messageList[type].join(seg_char);
        readed(type);
    }
    return ans;
}

void CacheText::readed(int type){
    messageList[type].clear();
    messageList.erase(messageList.find(type));
}

int CacheText::getCount(int type){
    return messageList[type].count();
}

int CacheText::addFriend(const QString &name, int language){
    friendsList.insert(name, language);
    qDebug() << "add name: " << name;
    qDebug() << "add language: " << language;
    auto it = friendsList.begin();
    int index = 0;
    for(; it != friendsList.end(); it++, index++){
        if(it.key() == name){
            break;
        }
    }
    return index;
}

bool CacheText::isExists(const QString &name){
    auto it = friendsList.find(name);
    if(it != friendsList.end()){
        return true;
    }
    return false;
}

int CacheText::removeFriend(const QString &name){
    auto it = friendsList.begin();
    int index = 0;
    for(; it != friendsList.end(); it++, index++){
        if(it.key() == name){
            break;
        }
    }
    friendsList.erase(friendsList.find(name));
    return index;
}

void CacheText::initFriendsList(const QString &friends){
    QStringList friendslist = friends.split('#');
    for(auto item : friendslist){
        QString name = item.split(":")[0];
        QString language = item.split(":")[1];
        friendsList.insert(name, language.toInt());
    }
}

QString CacheText::pullFriendsList(){
    auto it = friendsList.begin();
    QStringList friendslist;
    for(; it != friendsList.end(); it++){
        QString name = it.key();
        char slanguage[5];
        int ilanguage = static_cast<int>(it.value());
        sprintf(slanguage, "%d", ilanguage);
        QString language = QString(slanguage);
        QString item = name + ":" + language;
        friendslist << item;
    }
    QString friends = friendslist.join('#');
    qDebug() << "friends: " << friends;
    return friends;
}
