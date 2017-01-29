#ifndef CACHEMANAGER_H
#define CACHEMANAGER_H

#include <QObject>
#include <QString>
#include <QList>

class CacheManager : public QObject
{
    Q_OBJECT
public:
    CacheManager(QObject *parent = 0);
    void hadReceiveACK(bool flag);
    void addData(const QString &data);
signals:
    void sendData(const QString &data);
private:
    QList<QString> dataList; // 待发送的消息(JSON 字符串)
};

#endif // CACHEMANAGER_H
