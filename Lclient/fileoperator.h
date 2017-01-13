#ifndef FILEOPERATOR_H
#define FILEOPERATOR_H

#include <QFile>
#include <QString>
#include <QObject>

class FileOperator : public QObject
{
    Q_OBJECT
public:
    FileOperator(QObject *parent = 0);
    Q_INVOKABLE bool touch(const QString &fileName);
    Q_INVOKABLE bool openFile(const QString &fileName);
    Q_INVOKABLE void closeFile();
    Q_INVOKABLE bool seek(qint64 pos);
    Q_INVOKABLE void addFriend(const QString &friendName, int language);
    Q_INVOKABLE QString readFriends();
private:
    QFile *m_file;
};

#endif // FILEOPERATOR_H
