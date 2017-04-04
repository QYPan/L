#include "recordmanager.h"

RecordManager::RecordManager(QObject *parent)
    : QObject(parent)
{
    connect(&m_recorder, SIGNAL(recordError(QMediaRecorder::Error)),
            this, SIGNAL(recordError(QMediaRecorder::Error)));
    connect(&m_recorder, SIGNAL(recordTimeout()),
            this, SIGNAL(recordTimeout()));
}

QString RecordManager::userName() const{
    return m_userName;
}

void RecordManager::setUserName(const QString &name){
    m_userName = name;
}

bool RecordManager::recordReady(){
    return m_isReady;
}

void RecordManager::initRecord(){
    m_isReady = m_recorder.init(m_userName); // 检查录音设备
}

void RecordManager::startRecord(){
    m_recorder.start();
}

int RecordManager::getRecordTime(const QString &voicePath){
    int voiceTime = m_recorder.getVoiceTime(voicePath);
    qDebug() << "voiceTime in widget: " << voiceTime;
    return voiceTime;
}

void RecordManager::playRecord(const QString &voicePath){
    m_recorder.play(voicePath);
}

void RecordManager::stopPlayRecord(){
    m_recorder.stopPlay();
}

QString RecordManager::stopRecord(){
    QString fileName = m_recorder.stop();
    m_recorder.stopTimer();
    return fileName;
}
