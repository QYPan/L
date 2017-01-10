#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include "socketthread.h"
#include "datastruct.h"

class QmlInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString clientName READ clientName WRITE setClientName)
    Q_PROPERTY(QString clientPassword READ clientPassword WRITE setClientPassword)
    Q_PROPERTY(Language clientLanguage READ clientLanguage WRITE setClientLanguage)
    Q_ENUMS(MessageType)
    Q_ENUMS(Language)
public:
    enum MessageType {LOGIN, ADD_ONE, ADD_ONE_SUCCESSED, ADD_ONE_FAILURE, ADD_ALL, TRANSPOND
                      , ADD_ALL_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED
                      , OFFLINE, TRANSPOND_SUCCESSED, REGISTER, REMOVE_ONE
                      , REGISTER_FAILURE, REGISTER_SUCCESSED, CONNECT, SEARCH_REQUEST, SEARCH_SUCCESSED,
                        SEARCH_FAILURE};
    enum Language {CHINESE, ENGLISH};
    Q_INVOKABLE void qmlSendData(int type, const QString &message);
    Q_INVOKABLE void tryConnect(MessageType type);
    QmlInterface(QObject *parent = 0);
    QString clientName() const;
    void setClientName(const QString &name);
    QString clientPassword() const;
    void setClientPassword(const QString &password);
    Language clientLanguage() const;
    void setClientLanguage(Language language);
    void createSocketThread();
signals:
    void displayError(int socketError, const QString &message);
    void qmlReadData(int type, const QString &message);
    void sendData(const DataStruct &data);
public slots:
    void readData(const DataStruct &data);
    void tryLoginOrRegister();
private:
    void tryLogin();
    void tryRegister();
    SocketThread *thread;
    QString m_name;
    QString m_password;
    Language m_language;
    QChar seg_char;
    MessageType connectType; // 登录或注册 ?
};

#endif // QMLINTERFACE_H
