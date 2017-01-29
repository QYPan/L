#ifndef SIGNALMANAGER_H
#define SIGNALMANAGER_H

#include <QObject>
#include <QString>

class SignalManager : public QObject
{
    Q_OBJECT
public:
    SignalManager(QObject *parent = 0);
signals:
    void addLinkman(const QString &name, const QString &language, int sex);
};

#endif // SIGNALMANAGER_H
