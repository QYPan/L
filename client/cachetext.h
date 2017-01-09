#ifndef CACHETEXT_H
#define CACHETEXT_H

#include <QObject>
#include <QMap>
#include <QString>
#include <QStringList>
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
    Q_INVOKABLE QString pullFriendsList(); // 把好友列表推送给 UI
    Q_INVOKABLE int addFriend(const QString &name, int language);
    Q_INVOKABLE int removeFriend(const QString &name);
    Q_INVOKABLE bool isExists(const QString &name);
private:
    QChar seg_char;
    QMap<int, QStringList> messageList;
    QMap<QString, int> friendsList;
};

#endif // CACHETEXT_H
