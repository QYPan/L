#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QWidget>
#include <QAbstractSocket>
#include "socketthread.h"

class QmlInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int sex READ sex WRITE setSex NOTIFY sexChanged)
    Q_PROPERTY(QString clientName READ clientName WRITE setClientName NOTIFY clientNameChanged)
    Q_PROPERTY(QString clientPassword READ clientPassword WRITE setClientPassword NOTIFY clientPasswordChanged)
    Q_PROPERTY(QString clientLanguage READ clientLanguage WRITE setClientLanguage NOTIFY clientLanguageChanged)
public:
    QmlInterface(QObject *parent = 0);
    QString clientName() const;
    void setClientName(const QString &name);
    QString clientLanguage() const;
    void setClientLanguage(const QString &language);
    QString clientPassword() const;
    void setClientPassword(const QString &password);
    int sex() const;
    void setSex(int s);
signals:
    void qmlSendData(const QString &data);
    void qmlReadData(const QString &data);
    void qmlConnectSuccessed(bool flag);
    void qmlGetSocketState(const QString &stateMessage);
    void displayError(int socketError, const QString &message);
    void tryDisconnect();

    void sexChanged(int s);
    void clientNameChanged(const QString &name);
    void clientPasswordChanged(const QString &password);
    void clientLanguageChanged(const QString &language);
public slots:
    void readData(const QString &data);
    void getSocketState(QAbstractSocket::SocketState socketState);
    void socketDisconnected(); // socket 断开
    void reconnect(); // 断线重连
    void connectSuccessed();
private:
    void createSocketThread();
    SocketThread *thread;
    QString m_name;
    QString m_password;
    QString m_language;
    int m_sex;
};

#endif // QMLINTERFACE_H
