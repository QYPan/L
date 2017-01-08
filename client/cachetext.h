#ifndef CACHETEXT_H
#define CACHETEXT_H

#include <QObject>
#include <QMap>
#include <QString>

class CacheText : public QObject
{
    Q_OBJECT
    Q_ENUMS(CacheType)
public:
    enum CacheType {NEW_FRIEND};
    CacheText(QObject *parent = 0);
    Q_INVOKABLE void push(CacheType type, const QString &message);
    Q_INVOKABLE QString pull(CacheType type);
    Q_INVOKABLE void readed(CacheType type);
    Q_INVOKABLE int getCount(CacheType type);
private:
    QChar seg_char;
    QString newFriendRequest;
    QMap<CacheType, int> typeCount;
};

#endif // CACHETEXT_H
