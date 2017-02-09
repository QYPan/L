#include "cachemanager.h"
#include <QDebug>
#include <QEventLoop>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QByteArray>

HttpRequest::HttpRequest(QObject *parent)
    : QObject(parent)
{
}

void HttpRequest::getRequest(const QString &msg, QString &tmsg){
    // URL
    QString subBaseUrl = "http://fanyi.youdao.com/openapi.do?keyfrom=english-2-chinese&key=1263917877&type=data&doctype=json&version=1.1&only=translate&q=";
    QString baseUrl = subBaseUrl + msg;

    // 构造请求
    QNetworkRequest request;
    request.setUrl(QUrl(baseUrl));

    //QNetworkAccessManager *manager = new QNetworkAccessManager();
    QNetworkAccessManager manager;
    // 发送请求
    QNetworkReply *pReplay = manager.get(request);

    // 开启一个局部的事件循环，等待响应结束，退出
    QEventLoop eventLoop;
    QObject::connect(&manager, &QNetworkAccessManager::finished, &eventLoop, &QEventLoop::quit);
    eventLoop.exec();

    // 获取响应信息
    QByteArray bytes = pReplay->readAll();
    QString ans = QString(bytes);

    qDebug() << "ans: " << ans;

    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(ans.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        int errorCode = obj.value("errorCode").toInt();
        if(!errorCode){
            QJsonArray tarray = obj.value("translation").toArray();
            tmsg = tarray.at(0).toString();
            qDebug() << "translation: " << tmsg;
            return;
        }
    }
    tmsg = msg;
}

void HttpRequest::sendRequest(const QString &udata){
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(udata.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        QString msg = obj.value("msg").toString();
        QString tmsg;
        getRequest(msg, tmsg); // 进行翻译

        QJsonObject tobj;
        tobj.insert("userInfo", obj.value("userInfo"));
        tobj.insert("msg", msg);
        tobj.insert("tmsg", tmsg);
        QJsonDocument tdocument;
        tdocument.setObject(tobj);
        QByteArray bytes = tdocument.toJson(QJsonDocument::Compact);
        QString tudata(bytes);

        emit finishRequest(tudata);
    }
}

TranslateThread::TranslateThread(QObject *receiver)
    : m_receiver(receiver)
{
}

void TranslateThread::run(){
    HttpRequest httpRequest;
    //connect(m_receiver.data(), &CacheManager::sendToTranslate, &httpRequest, &HttpRequest::sendRequest);
    //connect(&httpRequest, &HttpRequest::finishRequest, m_receiver.data(), &CacheManager::finishTranslate);
    //connect(&httpRequest, &HttpRequest::finishRequest, m_receiver.data(), &CacheManager::onFinishTranslate);
    connect(m_receiver.data(), SIGNAL(sendToTranslate(QString)), &httpRequest, SLOT(sendRequest(QString)));
    connect(&httpRequest, SIGNAL(finishRequest(QString)), m_receiver.data(), SLOT(onFinishTranslate()));
    connect(&httpRequest, SIGNAL(finishRequest(QString)), m_receiver.data(), SIGNAL(finishTranslate(QString)));
    exec();
}

CacheManager::CacheManager(QObject *parent)
    : QObject(parent)
{
    createTranslateThread();
}

void CacheManager::createTranslateThread(){
    translateThread = new TranslateThread(this);
    translateThread->start();
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

void CacheManager::addTranslateData(const QString &udata){
    qDebug() << "add translate data: " << udata;
    translateList.append(udata);
    if(translateList.length() == 1){
        emit sendToTranslate(udata);
    }
}

void CacheManager::onFinishTranslate(){
    if(!translateList.isEmpty()){
        translateList.pop_front();
        if(!translateList.isEmpty()){
            QString udata = translateList.first();
            emit sendToTranslate(udata);
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
