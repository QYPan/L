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
    void removeLinkman(int index);
    void searchResult(const QString &data);
    void getLinkmans();
    void verifyAck();
    void openHandleVerifyPage();
    void getRequestNumber();
    void setRequestNumber(int number);
    void handleAcceptVerifyAck(const QString &data);
    void handleRemoveLinkmanAck(const QString &data);
    void setLinkmans(const QString &linkmans);
    void acceptVerify(const QString &name, const QString &language, int sex);
};

#endif // SIGNALMANAGER_H
