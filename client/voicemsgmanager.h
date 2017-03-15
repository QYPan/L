#ifndef VOICEMSGMANAGER_H
#define VOICEMSGMANAGER_H

#include <QObject>
#include <QPointer>
#include <QThread>
#include <QList>

class FtpThread : public QThread
{
    Q_OBJECT
public:
    FtpThread(QObject *receiver);
protected:
    void run();
private:
    QPointer<QObject> m_receiver; // 智能指针，指向父对象
};

class VoiceMsgManager : public QObject
{
    Q_OBJECT
public:
    VoiceMsgManager(QObject *parent = 0);
    Q_INVOKABLE void addUploadVoiceData(const QString &uVoicePath);
    Q_INVOKABLE void addDownloadVoiceData(const QString &uVoicePath);
signals:
    void upload(const QString &uVoicePath);
    void download(const QString &uVoicePath);
    void finishUpload(const QString &oppName, const QString &ftpPath);
    void finishDownload(const QString &uVoicePath);
public slots:
    void onFinishUpload(const QString &oppName, const QString &ftpPath);
    void onFinishDownload(const QString &uVoicePath);
private:
    void createftpThread();
    void createVoiceDir();
    QList<QString> ftpUploadList; // 待上传的语音消息(含用户信息，JSON 字符串)
    QList<QString> ftpDownloadList; // 待下载的语音消息(含用户信息，JSON 字符串)
    FtpThread *ftpThread;
};

#endif // VOICEMSGMANAGER_H
