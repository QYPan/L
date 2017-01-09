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

void CacheText::push(CacheType type, const QString &message){
    messageList[type] << message;
}

QString CacheText::pull(CacheType type){
    return messageList[type].join(seg_char);
}

void CacheText::readed(CacheType type){
    messageList[type].clear();
}

int CacheText::addFriend(const QString &name, QmlInterface::Language language){
    friendsList.insert(name, language);
    auto it = friendsList.begin();
    int index = 0;
    for(; it != friendsList.end(); it++, index++){
        if(it.key() == name){
            break;
        }
    }
    return index;
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
        qDebug() << "name: " << name;
        qDebug() << "language: " << language;
        friendsList.insert(name, static_cast<QmlInterface::Language>(language.toInt()));
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
