#ifndef CLIENTMAP_H
#define CLIENTMAP_H

#include <QObject>
#include <QMap>

class ClientMap : public QObject
{
    Q_OBJECT
public:
    ClientMap(QObject *parent = 0);
    Q_INVOKABLE bool has(const QString &name);
    Q_INVOKABLE int getNumber(const QString &name);
    Q_INVOKABLE void set(const QString &name, const QString &data);
    Q_INVOKABLE void clear(const QString &name);
    Q_INVOKABLE QString get(const QString &name);
private:
    QMap<QString, QString> m_map;
    QMap<QString, int> m_mapNumber;
};

#endif // CLIENTMAP_H
