#include "qmlinterface.h"
#include <QDebug>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , thread(NULL)
    , m_language(CHINESE)
    , seg_char('#')
{
    qRegisterMetaType<DataStruct>("DataStruct");
    createSocketThread();
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    //connect(thread, &SocketThread::finished, thread, &SocketThread::deleteLater);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::tryLoginOrRegister);
}

void QmlInterface::tryConnect(MessageType type){
    connectType = type;
    if(!thread->tryConnect()){ // 已经连接了
        tryLoginOrRegister();
    }
}

void QmlInterface::tryLoginOrRegister(){
    if(connectType == LOGIN){
        tryLogin(); // 尝试登陆
    }else if(connectType == REGISTER){
        tryRegister(); // 尝试注册
    }
}

void QmlInterface::tryLogin(){
    qmlSendData(LOGIN, m_password);
}

void QmlInterface::tryRegister(){
    QString message = m_password;
    message.append(seg_char);
    char language[5];
    sprintf(language, "%d", static_cast<int>(m_language));
    message.append(QString(language));
    qmlSendData(REGISTER, message);
}

void QmlInterface::qmlSendData(int type, const QString &message){
    DataStruct data;
    data.name = m_name;
    data.mark = type;
    data.message = message;
    qDebug() << m_name << " try to send data :" << message;
    emit sendData(data);
}

QString QmlInterface::clientName() const{
    return m_name;
}
void QmlInterface::setClientName(const QString &name){
    m_name = name;
}

QString QmlInterface::clientPassword() const{
    return m_password;
}

void QmlInterface::setClientPassword(const QString &password){
    m_password = password;
}

QmlInterface::Language QmlInterface::clientLanguage() const{
    return m_language;
}

void QmlInterface::setClientLanguage(Language language){
    m_language = language;
}

void QmlInterface::readData(const DataStruct &data){
    emit qmlReadData(data.mark, data.message);
}
