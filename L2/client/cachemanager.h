#ifndef CACHEMANAGER_H
#define CACHEMANAGER_H

#include <QObject>
#include <QString>
#include <QList>
#include <QMap>

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
signals:
    void sendData(const QString &data);
private:
    QList<QString> dataList; // 待发送的消息(JSON 字符串)
    QMap<QString, UserInfo> Linkmans; // 联系人
};

#endif // CACHEMANAGER_H
