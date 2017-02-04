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
    void addLinkman(int index, const QString &userInfoStr);
    void removeLinkman(int index);
    void searchResult(const QString &data);
    void openTalkPage(const QString &userInfoStr, bool isPush);
    void sendMessage(const QString &userInfoStr, const QString &msg);
    void receiveMessage(const QString &userInfoStr, const QString &msg);
    void getLinkmans();
    void verifyAck();
    void openHandleVerifyPage();
    void getRequestNumber();
    void setRequestNumber(int number);
    void handleTranspondAck(const QString &data);
    void setLinkmans(const QString &linkmans);
};

#endif // SIGNALMANAGER_H
