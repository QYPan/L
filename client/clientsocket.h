#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H

#include <QTcpSocket>
#include <QString>

class ClientSocket : public QTcpSocket
{
    Q_OBJECT
public:
    ClientSocket(QObject *parent = 0);
signals:
    void readData(const QString &data);
    void getError(int socketError, const QString &message);
public slots:
    void sendData(const QString &data);
private slots:
    void onReadyRead();
    void onError();
private:
};

#endif // CLIENTSOCKET_H
