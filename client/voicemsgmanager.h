#ifndef VOICEMSGMANAGER_H
#define VOICEMSGMANAGER_H

#include <QObject>
#include <QPointer>
#include <QThread>
#include <QList>
#include <QNetworkAccessManager>
#include <time.h>

class QByteArray;

class TranslateHttpRequest : public QObject
{
    Q_OBJECT
public:
    TranslateHttpRequest(QObject *parent = 0);
    void getVoiceTranslateRequest(int sex, const QString &language, const QString &voicePath, QString &tvoicePath);
    bool speech2text(const QString &language, const QString &voicePath, QString &text);
    bool textTranslate(const QString &msg, QString &tmsg);
    bool text2speech(int sex, const QString &text, QString &voicePath);
signals:
    void finishVoiceRequest(const QString &udata);
    void finishTextRequest(const QString &udata);
public slots:
    void sendVoiceRequest(const QString &udata);
    void sendTextRequest(const QString &udata);
private:
    QString getHostMacAddress();
    QString getRandID();
    void initRand();

    QByteArray readFile(const QString &filePath);
    QNetworkAccessManager m_networkManager;
};

class VoiceTranslateThread : public QThread
{
    Q_OBJECT
public:
    VoiceTranslateThread(QObject *receiver);
protected:
    void run();
private:
    QPointer<QObject> m_receiver; // 智能指针，指向父对象
};

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
    Q_PROPERTY(QString userLanguage READ userLanguage WRITE setUserLanguage NOTIFY userLanguageChanged)
public:
    VoiceMsgManager(QObject *parent = 0);
    Q_INVOKABLE void addUploadVoiceData(const QString &uVoicePath);
    Q_INVOKABLE void addDownloadVoiceData(const QString &uVoicePath);
    Q_INVOKABLE void addTranslateVoiceData(const QString &uVoicePath);
    QString userLanguage() const;
    void setUserLanguage(const QString &language);
signals:
    void userLanguageChanged(const QString &language);
    void upload(const QString &uVoicePath);
    void download(const QString &uVoicePath);
    void translateVoice(const QString &uVoicePath);
    void finishUpload(const QString &oppName, const QString &ftpPath);
    void finishDownload(const QString &uVoicePath);
    void finishVoiceTranslate(const QString &uVoicePath);
public slots:
    void onFinishUpload(const QString &oppName, const QString &ftpPath);
    void onFinishDownload(const QString &uVoicePath);
    void onFinishTranslate(const QString &uVoicePath);
private:
    void createftpThread();
    void createVoiceTranslateThread();
    void createVoiceDir();
    void judgeLanguage(const QString &uVoicePath);
    QList<QString> ftpUploadList; // 待上传的语音消息(含用户信息，JSON 字符串)
    QList<QString> ftpDownloadList; // 待下载的语音消息(含用户信息，JSON 字符串)
    QList<QString> voiceTranslateList; // 待翻译的语音消息(含用户信息，JSON 字符串)
    FtpThread *ftpThread;
    VoiceTranslateThread *voiceTranslateThread;
    QString m_userLanguage;
};

#endif // VOICEMSGMANAGER_H
