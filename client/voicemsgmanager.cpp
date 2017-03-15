#include <QDir>
#include "voicemsgmanager.h"
#include "ftpmanager.h"

VoiceMsgManager::VoiceMsgManager(QObject *parent)
    : QObject(parent)
{
    createftpThread();
    createVoiceDir();
}

FtpThread::FtpThread(QObject *receiver)
    : m_receiver(receiver)
{
}

void VoiceMsgManager::createVoiceDir(){
    QDir dir;
    QString voiceDir = QDir::currentPath()+"/voice";
    dir.mkdir(voiceDir);
}

void VoiceMsgManager::createftpThread(){
    ftpThread = new FtpThread(this);
    ftpThread->start();
}

void FtpThread::run(){
    FtpManager ftpManager;
    connect(m_receiver.data(), SIGNAL(upload(QString)), &ftpManager, SLOT(upload(QString)));
    connect(m_receiver.data(), SIGNAL(download(QString)), &ftpManager, SLOT(download(QString)));
    connect(&ftpManager, SIGNAL(finishUpload(QString, QString)), m_receiver.data(), SLOT(onFinishUpload(QString, QString)));
    connect(&ftpManager, SIGNAL(finishDownload(QString)), m_receiver.data(), SLOT(onFinishDownload(QString)));
    exec();
}

void VoiceMsgManager::addDownloadVoiceData(const QString &uVoicePath){
    ftpDownloadList.append(uVoicePath);
    if(ftpDownloadList.length() == 1){
        emit download(uVoicePath);
    }
}

void VoiceMsgManager::addUploadVoiceData(const QString &uVoicePath){
    ftpUploadList.append(uVoicePath);
    if(ftpUploadList.length() == 1){
        emit upload(uVoicePath);
    }
}

void VoiceMsgManager::onFinishDownload(const QString &uVoicePath){
    if(!ftpDownloadList.isEmpty()){
        ftpDownloadList.pop_front();
        if(!ftpDownloadList.isEmpty()){
            QString tuVoicePath = ftpDownloadList.first();
            emit download(tuVoicePath);
        }
        emit finishDownload(uVoicePath);
    }
}

void VoiceMsgManager::onFinishUpload(const QString &oppName, const QString &ftpPath){
    if(!ftpUploadList.isEmpty()){
        ftpUploadList.pop_front();
        if(!ftpUploadList.isEmpty()){
            QString uVoicePath = ftpUploadList.first();
            emit upload(uVoicePath);
        }
        emit finishUpload(oppName, ftpPath);
    }
}
