#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H

#include <QTcpSocket>
#include "datastruct.h"

class ClientSocket : public QTcpSocket
{
    Q_OBJECT
public:
    ClientSocket(QObject *parent = 0);
signals:
    void readData(const DataStruct &data);
    void getError(int socketError, const QString &message);
private slots:
    void sendData(const DataStruct &data);
    void onReadyRead();
    void onError();
private:
    void resolve(const QString &buffer);
    void merge(const DataStruct &data);
};

#endif // CLIENTSOCKET_H
