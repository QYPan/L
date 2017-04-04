#include <QDir>
#include "voicemsgmanager.h"
#include "ftpmanager.h"
#include <QByteArray>
#include <QDataStream>

VoiceHttpRequest::VoiceHttpRequest(QObject *parent)
    : QObject(parent)
{
}

VoiceMsgManager::VoiceMsgManager(QObject *parent)
    : QObject(parent)
{
    createVoiceTranslateThread();
    createftpThread();
    createVoiceDir();
}

VoiceTranslateThread::VoiceTranslateThread(QObject *receiver)
    : m_receiver(receiver)
{
}

QByteArray VoiceHttpRequest::readFile(const QString &filePath){
    qDebug() << "read: " << filePath;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)){
        qDebug() << "bad read";
        return "";
    }
    qDebug() << "good read";
    QByteArray data = file.readAll();
    file.close();
    return data;
}

bool VoiceHttpRequest::speech2text(const QString &language, const QString &voicePath, QString &text){
    QString baseUrl = "http://vop.baidu.com/server_api";
    QUrl url(baseUrl);

    QByteArray voiceF = readFile(voicePath);
    if(voiceF == ""){
        return false;
    }
    bool ok = false;
    qDebug() << "voiceF size: " << voiceF.size();

    QJsonObject json;
    json.insert("format", "amr");
    json.insert("rate", "8000");
    json.insert("channel", "1");
    json.insert("lan", language);
    json.insert("token", "24.dadd857936f104ecb9399b45cacf1a5d.2592000.1492495671.282335-9415054");
    json.insert("cuid", "jusatextname");
    json.insert("speech", QString(voiceF.toBase64()));
    json.insert("len", voiceF.size());

    QJsonDocument document;
    document.setObject(json);
    QByteArray dataArray = document.toJson(QJsonDocument::Compact);

    QNetworkRequest request;
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setUrl(url);

    //QNetworkAccessManager *manager = new QNetworkAccessManager();
    QNetworkReply *pReplay = m_networkManager.post(request, dataArray);

    qDebug() << "begin stt";
    QEventLoop eventLoop;
    QObject::connect(&m_networkManager, &QNetworkAccessManager::finished, &eventLoop, &QEventLoop::quit);
    eventLoop.exec();
    qDebug() << "end stt";

    QByteArray bytes = pReplay->readAll();
    QString ans(bytes);

    qDebug() << "stt ans: " << ans;

    QJsonParseError jsonError;
    QJsonDocument judgeDocument = QJsonDocument::fromJson(ans.toUtf8(), &jsonError);
    if(!judgeDocument.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = judgeDocument.object();
        int err_no = obj.value("err_no").toInt();
        if(!err_no){
            QJsonArray tarray = obj.value("result").toArray();
            text = tarray.at(0).toString();
            ok = true;
        }
    }
    qDebug() << "stt: " << text;
    pReplay->deleteLater();
    return ok;
}

bool VoiceHttpRequest::textTranslate(const QString &msg, QString &tmsg){
    // URL
    QString subBaseUrl = "http://fanyi.youdao.com/openapi.do?keyfrom=english-2-chinese&key=1263917877&type=data&doctype=json&version=1.1&only=translate&q=";
    QString baseUrl = subBaseUrl + msg;

    bool ok = false;

    // 构造请求
    QNetworkRequest request;
    request.setUrl(QUrl(baseUrl));

    //QNetworkAccessManager *manager = new QNetworkAccessManager();
    // 发送请求
    QNetworkReply *pReplay = m_networkManager.get(request);

    // 开启一个局部的事件循环，等待响应结束，退出
    QEventLoop eventLoop;
    QObject::connect(&m_networkManager, &QNetworkAccessManager::finished, &eventLoop, &QEventLoop::quit);
    eventLoop.exec();

    // 获取响应信息
    QByteArray bytes = pReplay->readAll();
    pReplay->deleteLater();
    QString ans = QString(bytes);
    qDebug() << "translate ans: " << ans;

    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(ans.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        int errorCode = obj.value("errorCode").toInt();
        if(!errorCode){
            QJsonArray tarray = obj.value("translation").toArray();
            tmsg = tarray.at(0).toString();
            ok = true;
        }
    }
    if(ok == false){
        tmsg = msg;
    }
    qDebug() << "translate: " << tmsg;
    pReplay->deleteLater();
    return ok;
}

bool VoiceHttpRequest::text2speech(const QString &text, QString &voicePath){
    QString baseUrl = "http://tsn.baidu.com/text2audio";
    QUrl url(baseUrl);

    QByteArray dataArray;
    QString ctex = "tex=" + QString(text.toUtf8()) + "&";
    //dataArray.append("tex=你好,你很漂亮&");
    dataArray.append(ctex);
    dataArray.append("lan=zh&");
    dataArray.append("tok=24.dadd857936f104ecb9399b45cacf1a5d.2592000.1492495671.282335-9415054&");
    dataArray.append("ctp=1&");
    dataArray.append("cuid=justatextname");

#if 0
    QJsonObject json;
    QString tex("你好，很高兴认识你");
    json.insert("tex", QString(tex.toUtf8()));
    json.insert("lan", "zh");
    json.insert("tok", "24.dadd857936f104ecb9399b45cacf1a5d.2592000.1492495671.282335-9415054");
    json.insert("ctp", "1");
    json.insert("cuid", "qypan");
    //json.insert("speech", QString(voiceF.toBase64()));
    //json.insert("len", voiceF.size());

    QJsonDocument document;
    document.setObject(json);
    QByteArray dataArray = document.toJson(QJsonDocument::Compact);
#endif

    QNetworkRequest request;
    //request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setUrl(url);

    //QNetworkAccessManager *manager = new QNetworkAccessManager();

    QNetworkReply *pReplay = m_networkManager.post(request, dataArray);

    qDebug() << "begin tts";
    QEventLoop eventLoop;
    QObject::connect(&m_networkManager, &QNetworkAccessManager::finished, &eventLoop, &QEventLoop::quit);
    eventLoop.exec();
    qDebug() << "end tts";

    QByteArray bytes = pReplay->readAll();

    static int voice_count = 0;
    char ch_count[100] = {0};
    voice_count += 1;
    sprintf(ch_count, "%d", voice_count);
    QString str_count(ch_count);
    QString voiceName = "translate" + str_count + ".mp3";

    voicePath= QDir::currentPath()+"/voice/" + voiceName;
    QFile file(voicePath);
    if (!file.open(QIODevice::WriteOnly)){
        qDebug() << "file: bad write";
        return false;
    }
    QDataStream out(&file);
    out << bytes;
    file.close();
    //QString ans(bytes);
    //qDebug() << "ans: " << ans;
    return true;
}

void VoiceHttpRequest::getRequest(const QString &language, const QString &voicePath, QString &tvoicePath){
    QString msg, tmsg;
    bool ok = false;
    if(speech2text(language, voicePath, msg)){
        if(textTranslate(msg, tmsg)){
            if(text2speech(tmsg, tvoicePath)){
                ok = true;
            }
        }
    }
    if(ok == false){
        tvoicePath = voicePath;
    }
}

void VoiceHttpRequest::sendRequest(const QString &udata){
    qDebug() << "in voice translate sendRequest: " << udata;
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(udata.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        QString voicePath = obj.value("voicePath").toString();
        QString tvoicePath;

        QJsonValue val = obj.value("userInfo");
        QJsonObject subObj = val.toObject();
        QString language = subObj.value("language").toString();
        QString lan;
        if(language == "EN") lan = "en";
        else if(language == "CN") lan = "zh";

        getRequest(lan, voicePath, tvoicePath); // 进行翻译
        qDebug() << "voicePath: " << voicePath;
        qDebug() << "tvoicePath: " << tvoicePath;

        QJsonObject tobj;
        tobj.insert("userInfo", obj.value("userInfo"));
        tobj.insert("voicePath", voicePath);
        tobj.insert("tvoicePath", tvoicePath);

        QJsonDocument tdocument;
        tdocument.setObject(tobj);
        QByteArray bytes = tdocument.toJson(QJsonDocument::Compact);
        QString tudata(bytes);

        emit finishRequest(tudata);
    }
}

FtpThread::FtpThread(QObject *receiver)
    : m_receiver(receiver)
{
}

void VoiceMsgManager::createVoiceDir(){
    QDir dir;
    QString voiceDir = QDir::currentPath()+"/voice";
    dir.mkdir(voiceDir);
}

void VoiceMsgManager::createVoiceTranslateThread(){
    voiceTranslateThread = new VoiceTranslateThread(this);
    voiceTranslateThread->start();
}

void VoiceMsgManager::createftpThread(){
    ftpThread = new FtpThread(this);
    ftpThread->start();
}

void VoiceTranslateThread::run(){
    VoiceHttpRequest translateRequest;
    connect(m_receiver.data(), SIGNAL(translateVoice(QString)), &translateRequest, SLOT(sendRequest(QString)));
    connect(&translateRequest, SIGNAL(finishRequest(QString)), m_receiver.data(), SLOT(onFinishTranslate(QString)));
    exec();
}

void FtpThread::run(){
    FtpManager ftpManager;
    connect(m_receiver.data(), SIGNAL(upload(QString)), &ftpManager, SLOT(upload(QString)));
    connect(m_receiver.data(), SIGNAL(download(QString)), &ftpManager, SLOT(download(QString)));
    connect(&ftpManager, SIGNAL(finishUpload(QString, QString)), m_receiver.data(), SLOT(onFinishUpload(QString, QString)));
    connect(&ftpManager, SIGNAL(finishDownload(QString)), m_receiver.data(), SLOT(onFinishDownload(QString)));
    exec();
}

void VoiceMsgManager::addTranslateVoiceData(const QString &uVoicePath){
    voiceTranslateList.append(uVoicePath);
    if(voiceTranslateList.length() == 1){
        //qDebug() << "add translate voice: " << uVoicePath;
        emit translateVoice(uVoicePath);
    }
}

QString VoiceMsgManager::userLanguage() const{
    return m_userLanguage;
}
void VoiceMsgManager::setUserLanguage(const QString &language){
    m_userLanguage = language;
}

void VoiceMsgManager::addDownloadVoiceData(const QString &uVoicePath){
    ftpDownloadList.append(uVoicePath);
    if(ftpDownloadList.length() == 1){
        emit download(uVoicePath);
    }
}

void VoiceMsgManager::addUploadVoiceData(const QString &uVoicePath){
    ftpUploadList.append(uVoicePath);
    if(ftpUploadList.length() == 1){
        emit upload(uVoicePath);
    }
}

void VoiceMsgManager::onFinishTranslate(const QString &uVoicePath){
    if(!voiceTranslateList.isEmpty()){
        voiceTranslateList.pop_front();
        if(!voiceTranslateList.isEmpty()){
            QString tuVoicePath = voiceTranslateList.first();
            emit translateVoice(tuVoicePath);
        }
        emit finishVoiceTranslate(uVoicePath);
    }
}

void VoiceMsgManager::judgeLanguage(const QString &uVoicePath){
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(uVoicePath.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        QJsonValue val = obj.value("userInfo");
        QString voicePath = obj.value("voicePath").toString();
        QJsonObject subObj = val.toObject();
        QString language = subObj.value("language").toString();
        if(m_userLanguage == language){
            qDebug() << "the same voice, no need to translate";
            QJsonObject tobj;
            tobj.insert("userInfo", obj.value("userInfo"));
            tobj.insert("voicePath", voicePath);
            tobj.insert("tvoicePath", voicePath);

            QJsonDocument document;
            document.setObject(tobj);
            QByteArray bytes = document.toJson(QJsonDocument::Compact);
            QString udata(bytes);

            emit finishVoiceTranslate(udata);
        }else{
            addTranslateVoiceData(uVoicePath);
        }
    }
}

void VoiceMsgManager::onFinishDownload(const QString &uVoicePath){
    if(!ftpDownloadList.isEmpty()){
        ftpDownloadList.pop_front();
        if(!ftpDownloadList.isEmpty()){
            QString tuVoicePath = ftpDownloadList.first();
            emit download(tuVoicePath);
        }
        judgeLanguage(uVoicePath);
    }
}

void VoiceMsgManager::onFinishUpload(const QString &oppName, const QString &ftpPath){
    if(!ftpUploadList.isEmpty()){
        ftpUploadList.pop_front();
        if(!ftpUploadList.isEmpty()){
            QString uVoicePath = ftpUploadList.first();
            emit upload(uVoicePath);
        }
        emit finishUpload(oppName, ftpPath);
    }
}
