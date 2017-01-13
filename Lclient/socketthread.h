#ifndef SOCKETTHREAD_H
#define SOCKETTHREAD_H

#include <QThread>
#include <QObject>
#include <QPointer>

class SocketThread : public QThread
{
    Q_OBJECT
public:
    SocketThread(QObject *receiver);
    bool tryConnect();
    void setClientName(const QString &name);
signals:
    void error(int socketError, const QString &message);
    void connectSuccessed();
protected:
    void run();
private:
    QPointer<QObject> m_receiver; // 智能指针，指向父对象
};
#endif // SOCKETTHREAD_H
