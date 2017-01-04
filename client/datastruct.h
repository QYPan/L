#ifndef DATASTRUCT_H
#define DATASTRUCT_H

#include <QString>

class ClientSocket;

struct DataStruct
{
    DataStruct()
        : message("")
        , name("")
        , ip("")
    {}
    QString message;
    QString name;
    QString ip;
    int port;
    int mark;
    ClientSocket *socket;
};

#endif // CLIENTTHREAD_H
