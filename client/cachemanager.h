#ifndef CACHEMANAGER_H
#define CACHEMANAGER_H

#include <QObject>
#include <QString>
#include <QThread>
#include <QPointer>
#include <QList>
#include <QMap>

class QNetworkAccessManager;

class HttpRequest : public QObject
{
    Q_OBJECT
public:
    HttpRequest(QObject *parent = 0);
signals:
    void finishRequest(const QString &udata);
public slots:
    void sendRequest(const QString &udata);
private:
    void getRequest(const QString &msg, QString &tmsg);
};

class TranslateThread : public QThread
{
    Q_OBJECT
public:
    TranslateThread(QObject *receiver);
protected:
    void run();
private:
    QPointer<QObject> m_receiver; // 智能指针，指向父对象
};

class CacheManager : public QObject
{
    Q_OBJECT
public:
    struct UserInfo{
        QString name;
        QString language;
        int sex;
    };

    CacheManager(QObject *parent = 0);
    Q_INVOKABLE void addData(const QString &data);
    Q_INVOKABLE void hadReceiveACK(bool flag);
    Q_INVOKABLE QString getLinkmans();
    Q_INVOKABLE int addLinkman(const QString &name, const QString &language, int sex);
    Q_INVOKABLE int removeLinkman(const QString &name);
    Q_INVOKABLE bool isLinkman(const QString &name);

    Q_INVOKABLE void addTranslateData(const QString &udata);
signals:
    void sendData(const QString &data);
    void sendToTranslate(const QString &udata);
    void finishTranslate(const QString &udata);
private slots:
    void onFinishTranslate();
private:
    void createTranslateThread();
    QList<QString> dataList; // 待发送的消息(JSON 字符串)
    QMap<QString, UserInfo> Linkmans; // 联系人
    QList<QString> translateList; // 待翻译的消息(含用户信息)(JSON 字符串)
    TranslateThread *translateThread;
};

#endif // CACHEMANAGER_H
