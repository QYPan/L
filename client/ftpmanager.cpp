#include <QFileInfo>
#include <QDir>
#include <QStringList>
#include "ftpmanager.h"

FtpManager::FtpManager(QObject *parent)
    : QObject(parent)
{
    // 设置协议
    m_pUrl.setScheme("ftp");
    setHostPort("118.89.35.51", 21);
    setUserInfo("anonymous", "");
}

// 设置地址和端口
void FtpManager::setHostPort(const QString &host, int port)
{
    m_pUrl.setHost(host);
    m_pUrl.setPort(port);
}

// 设置登录 FTP 服务器的用户名和密码
void FtpManager::setUserInfo(const QString &userName, const QString &password)
{
    m_pUrl.setUserName(userName);
    m_pUrl.setPassword(password);
}

// 上传文件
void FtpManager::put(const QString &fileName, const QString &path)
{
    QFile file(fileName);
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();

    m_pUrl.setPath(path);
    QNetworkReply *pReply = m_manager.put(QNetworkRequest(m_pUrl), data);

    //connect(pReply, SIGNAL(uploadProgress(qint64, qint64)), this, SIGNAL(uploadProgress(qint64, qint64)));
    connect(pReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SIGNAL(error(QNetworkReply::NetworkError)));
    connect(pReply, SIGNAL(finished()), this, SLOT(uploadFinished()));
}

void FtpManager::uploadFinished(){
    emit finishUpload(m_userName, m_ftpPath);
}

// 下载文件
void FtpManager::get(const QString &path, const QString &fileName)
{
    QFileInfo info;
    info.setFile(fileName);

    m_file.setFileName(fileName);
    m_file.open(QIODevice::WriteOnly | QIODevice::Append);
    m_pUrl.setPath(path);

    QNetworkReply *pReply = m_manager.get(QNetworkRequest(m_pUrl));

    connect(pReply, SIGNAL(finished()), this, SLOT(downloadFinished()));
    //connect(pReply, SIGNAL(downloadProgress(qint64, qint64)), this, SIGNAL(downloadProgress(qint64, qint64)));
    connect(pReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SIGNAL(error(QNetworkReply::NetworkError)));
}

void FtpManager::upload(const QString &uVoicePath){
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(uVoicePath.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        QString voicePath = obj.value("voicePath").toString();
        QStringList pathList = voicePath.split("/");
        qDebug() << "pathList: " << pathList;
        m_ftpPath = pathList.last();
        m_userName = obj.value("userName").toString();
        put(voicePath, "/voice/"+m_ftpPath);
    }
}

void FtpManager::download(const QString &uVoicePath){
    QJsonParseError jsonError;
    QJsonDocument document = QJsonDocument::fromJson(uVoicePath.toUtf8(), &jsonError);
    if(!document.isNull() && (jsonError.error == QJsonParseError::NoError)){
        QJsonObject obj = document.object();
        voiceInfoObj.insert("userInfo", obj.value("userInfo"));
        QString ftpPath = obj.value("msg").toString();
        QString downloadPath = QDir::currentPath() + "/voice/" + ftpPath;
        qDebug() << "downloadPath: " << downloadPath;
        get("/voice/"+ftpPath, downloadPath);
    }
}

// 下载过程中写文件
void FtpManager::downloadFinished()
{
    QNetworkReply *pReply = qobject_cast<QNetworkReply *>(sender());
    switch (pReply->error()) {
    case QNetworkReply::NoError : {
        m_file.write(pReply->readAll());
        m_file.flush();
    }
        break;
    default:
        break;
    }

    m_file.close();
    pReply->deleteLater();
    voiceInfoObj.insert("voicePath", m_file.fileName());
    QJsonDocument tdocument;
    tdocument.setObject(voiceInfoObj);
    QByteArray bytes = tdocument.toJson(QJsonDocument::Compact);
    QString tudata(bytes);
    emit finishDownload(tudata);
    qDebug() << "download finished";
}
