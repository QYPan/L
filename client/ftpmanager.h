#ifndef FTPMANAGER_H
#define FTPMANAGER_H

#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QEventLoop>
#include <QUrl>
#include <QUrlQuery>
#include <QFile>
#include <QNetworkReply>
#include <QNetworkAccessManager>

class FtpManager : public QObject
{
    Q_OBJECT
public:
    explicit FtpManager(QObject *parent = 0);
    // 设置地址和端口
    void setHostPort(const QString &host, int port = 21);
    // 设置登录 FTP 服务器的用户名和密码
    void setUserInfo(const QString &userName, const QString &password);
    // 上传文件
    void put(const QString &fileName, const QString &path);
    // 下载文件
    void get(const QString &path, const QString &fileName);
signals:
    void error(QNetworkReply::NetworkError);
    void finishUpload(const QString &name, const QString &ftpPath);
    void finishDownload(const QString &uVoicePath);
    // 上传进度
    //void uploadProgress(qint64 bytesSent, qint64 bytesTotal);
    // 下载进度
    //void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
public slots:
    void upload(const QString &uVoicePath);
    void download(const QString &uVoicePath);
private slots:
    void uploadFinished();
    // 下载过程中写文件
    void downloadFinished();

private:
    QUrl m_pUrl;
    QFile m_file;
    QString m_userName;
    QString m_ftpPath;
    QNetworkAccessManager m_manager;
    QJsonObject voiceInfoObj;
};

#endif // FTPMANAGER_H
