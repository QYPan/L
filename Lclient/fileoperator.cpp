#include "fileoperator.h"
#include <QTextStream>
#include <QDir>
#include <QDebug>

FileOperator::FileOperator(QObject *parent)
    : QObject(parent)
{
}

bool FileOperator::touch(const QString &fileName){
    return m_file->exists(fileName);
}

void FileOperator::addFriend(const QString &friendName, int language){
    QTextStream out(m_file);
    qDebug() << "add friend: " << friendName;
    out << friendName << ":" << language << '\n';
}

QString FileOperator::readFriends(){
    QString friendNames;
    QTextStream in(m_file);
    seek(0);
    while(!in.atEnd()){
        qDebug() << "not empty";
        friendNames.append(in.readLine());
        if(!in.atEnd()){
            friendNames.append(QChar('#'));
        }
    }
    qDebug() << "read friends: " << friendNames;
    return friendNames;
}

bool FileOperator::seek(qint64 pos){
    return m_file->seek(pos);
}

void FileOperator::closeFile(){
    m_file->close();
    delete m_file;
    m_file = NULL;
}

bool FileOperator::openFile(const QString &fileName){
    QString path = QDir::currentPath();
    path.append("/"+fileName);
    m_file = new QFile(path);
    if(m_file && !m_file->open(QIODevice::ReadWrite | QIODevice::Text | QIODevice::Append)){
        qDebug() << "try open file: " << m_file->fileName() << " error";
        delete m_file;
        m_file = NULL;
        return false;
    }
    qDebug() << "try open file: " << fileName << " successed";
    return true;
}
