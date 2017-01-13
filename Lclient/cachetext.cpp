#include "cachetext.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <QDebug>
#include <QDir>
#include <QTextStream>

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
            qDebug() << "remove: " << name;
            break;
        }
    }
    if(it != friendsList.end()){
        friendsList.erase(it);
        return index;
    }
    return -1;
}

void CacheText::initAddressList(const QString &friends){
    QStringList friendslist = friends.split('#');
    for(auto item : friendslist){
        QString name = item.split(":")[0];
        QString language = item.split(":")[1];
        friendsList.insert(name, language.toInt());
    }
}

QString CacheText::pullAddressList(){
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
    return friends;
}

void CacheText::clearAll(){
    messageList.clear();
    friendsList.clear();
}

void CacheText::saveFriends(const QString &name){
    //QString path = QDir::currentPath()+"/"+name+"-friends.txt";
    QString path = name+"-friends.txt";
    QFile file(path);
    qDebug() << "friends save in: " << path;
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    for(auto it = friendsList.begin(); it != friendsList.end(); it++){
        out << it.key() << ":" << it.value() << '\n';
    }
    file.close();
}

void CacheText::loadToCache(const QString &name){
    QString path = name+"-cache.txt";
    QFile file(path);
    qDebug() << "cache save in: " << path;
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QString str_type, message;
        splitString(line, 0, str_type);
        splitString(line, 1, message);
        int type = str_type.toInt();
        qDebug() << "push: " << type << ":" << message;
        push(type, message);
    }
    file.close();
    file.remove();
}

void CacheText::saveCache(const QString &name){
    QString path = name+"-cache.txt";
    QFile file(path);
    qDebug() << "cache save in: " << path;
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    QHashIterator<int, QStringList> it(messageList);
    while (it.hasNext()) {
        it.next();
        for(auto item : it.value()){
            out << it.key() << ":" << item << '\n';
        }
    }
}

void CacheText::setClient(const QString &name, const QString &password){
    QString path = name+".txt";
    QFile file(path);
    qDebug() << "client save in: " << path;
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << name << '\n' << password << '\n';
    file.close();
}

void CacheText::saveAll(const QString &name){
    saveFriends(name);
    saveCache(name);
    clearAll();
}

void CacheText::splitString(const QString &str, int k, QString &sub){
    int count = 0;
    int beg = 0;
    for(int i= 0; i < str.size(); i++){
        if(str[i] == ':' || i == str.size()-1){
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
