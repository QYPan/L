#include "qmlinterface.h"
#include <QTest>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonParseError>

QmlInterface::QmlInterface(QObject *parent)
    : QObject(parent)
    , cacheManager(NULL)
    , thread(NULL)
{
    initCacheManager();
    createSocketThread();
    tryConnect();
}

void QmlInterface::initCacheManager(){
    cacheManager = new CacheManager(this);
    connect(cacheManager, &CacheManager::sendData, this, &QmlInterface::sendData);
    connect(this, &QmlInterface::qmlSendData, cacheManager, &CacheManager::addData);
}

void QmlInterface::createSocketThread(){
    thread = new SocketThread(this);
    connect(thread, &SocketThread::finished, this, &QmlInterface::reconnect);
    connect(thread, &SocketThread::error, this, &QmlInterface::displayError);
    connect(thread, &SocketThread::connectSuccessed, this, &QmlInterface::connectSuccessed);
    connect(this, &QmlInterface::tryDisconnect, thread, &SocketThread::quit);
}

void QmlInterface::readData(const QString &data){
    emit qmlReadData(data); // 发给 UI 处理
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(data.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        QString mtype = obj.value("mtype").toString();
        QString dtype = obj.value("dtype").toString();
        if(mtype == "ACK"){
            if(dtype != "HEART"){
                cacheManager->hadReceiveACK(true);
            }
        }
    }
}

void QmlInterface::reconnect(){
    qDebug() << "thread death!";
    QTest::qWait(3000);
    tryConnect();
}

void QmlInterface::connectSuccessed(){
    getSocketState(QAbstractSocket::ConnectedState);
    cacheManager->hadReceiveACK(false); // 重新分发未发送成功的数据
    displayError(-2, "no error");
}

void QmlInterface::tryConnect(){
    if(!thread->tryConnect()){ // 已经连接了
    }
}

void QmlInterface::socketDisconnected(){
    emit displayError(-2, "socket disconnected!");
    emit tryDisconnect(); // 结束 socket 线程
}

void QmlInterface::getSocketState(QAbstractSocket::SocketState socketState){
    QString stateString;
    switch(socketState){
        case QAbstractSocket::UnconnectedState:
            stateString = "The socket is not connected";
            break;
        case QAbstractSocket::HostLookupState:
            stateString = "The socket is performing a host name lookup";
            break;
        case QAbstractSocket::ConnectingState:
            stateString = "The socket has started establishing a connection";
            break;
        case QAbstractSocket::ConnectedState:
            stateString = "A connection is established";
            break;
        case QAbstractSocket::BoundState:
            stateString = "The socket is bound to an address and port";
            break;
        case QAbstractSocket::ClosingState:
            stateString = "The socket is about to close (data may still be waiting to be written)";
            break;
        case QAbstractSocket::ListeningState:
            stateString = "For internal use only";
            break;
    }
    emit qmlGetSocketState(stateString);
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

QString QmlInterface::clientLanguage() const{
    return m_language;
}

void QmlInterface::setClientLanguage(const QString &language){
    m_language = language;
}

int QmlInterface::sex() const{
    return m_sex;
}

void QmlInterface::setSex(int s){
    m_sex = s;
}
