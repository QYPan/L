#include "qmlinterface.h"
#include <QDebug>

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , thread(NULL)
    , m_language(CHINESE)
{
    qRegisterMetaType<DataStruct>("DataStruct");
    createSocketThread();
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    //connect(thread, &SocketThread::finished, thread, &SocketThread::deleteLater);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::tryLogin);
}

void QmlInterface::tryConnect(MessageType type){
    if(!thread->tryConnect()){ // 已经连接了
        if(type == LOGIN){
            tryLogin(); // 尝试登陆
        }else if(type == REGISTER){
            tryRegister(); // 尝试注册
        }
    }
}

void QmlInterface::tryLogin(){
    qmlSendData(LOGIN, m_password);
}

void QmlInterface::tryRegister(){
}

void QmlInterface::qmlSendData(int type, const QString &message){
    DataStruct data;
    data.name = m_name;
    data.mark = type;
    data.message = message;
    qDebug() << m_name << " try to send data";
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
