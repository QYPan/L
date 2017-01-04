#include "clientmap.h"

ClientMap::ClientMap(QObject *parent)
    : QObject(parent)
{
}

bool ClientMap::has(const QString &name){
    QMap<QString, QString>::iterator it = m_map.find(name);
    if(it != m_map.end())
        return true;
    return false;
}

void ClientMap::set(const QString &name, const QString &message){
    m_map.insert(name, message);
    int pre = m_mapNumber[name];
    m_mapNumber.insert(name, pre+1);
}

int ClientMap::getNumber(const QString &name){
    return m_mapNumber[name];
}

QString ClientMap::get(const QString &name){
    if(has(name))
        return m_map[name];
    return "";
}

void ClientMap::clear(const QString &name){
    m_map.erase(m_map.find(name));
    m_mapNumber.erase(m_mapNumber.find(name));
}
