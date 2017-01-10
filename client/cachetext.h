#ifndef CACHETEXT_H
#define CACHETEXT_H

#include <QObject>
#include <QMap>
#include <QString>
#include <QStringList>
#include <QHash>
#include "qmlinterface.h"

class CacheText : public QObject
{
    Q_OBJECT
    Q_ENUMS(CacheType)
public:
    //enum CacheType {MESSAGE_TAB, MAIL_LIST_TAB, SYSTEM_TAB};
    CacheText(QObject *parent = 0);
    Q_INVOKABLE void push(int type, const QString &message);
    Q_INVOKABLE QString pop(int type);
    Q_INVOKABLE void readed(int type);
    Q_INVOKABLE int getCount(int type);

    Q_INVOKABLE void initFriendsList(const QString &friends); // 初始化从服务器拉取的好友列表
    Q_INVOKABLE void loadToCache(const QString &friends); // 从本地加载未读信息到缓存
    Q_INVOKABLE QString pullFriendsList(); // 把好友列表推送给 UI
    Q_INVOKABLE int addFriend(const QString &name, int language);
    Q_INVOKABLE int removeFriend(const QString &name);
    Q_INVOKABLE bool isExists(const QString &name);

    Q_INVOKABLE void clearAll();
    Q_INVOKABLE void saveAll(const QString &name);
    Q_INVOKABLE void saveCache(const QString &name); // 把 name 用户的所有缓存消息写入本地保存
    Q_INVOKABLE void saveFriends(const QString &name); // 把 name 用户的所有好友写入本地保存
    Q_INVOKABLE void setClient(const QString &name, const QString &password); // 把从本地登录的用户设置为 name
private:
    void splitString(const QString &str, int k, QString &sub);
    QChar seg_char;
    QHash<int, QStringList> messageList;
    QMap<QString, int> friendsList;
};

#endif // CACHETEXT_H
