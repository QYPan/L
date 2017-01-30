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
    void addLinkman(int index, const QString &name, const QString &language, int sex);
    void searchResult(const QString &data);
    void getLinkmans();
    void verifyAck();
    void setLinkmans(const QString &linkmans);
};

#endif // SIGNALMANAGER_H
