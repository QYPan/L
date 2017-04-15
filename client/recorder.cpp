#include "recorder.h"
#include <QDir>
#include <QUrl>
#include <QFile>
#include <QStringList>
#include <QDateTime>

Recorder::Recorder(QObject *parent)
    : QObject(parent)
    , m_recorder(this)
    , m_bRecorderValid(true)
    , m_bRecordSuccess(true)
{
    setupAudioPlayer();
    connect(&m_recordTimer, &QTimer::timeout, this, &Recorder::timeoutKillRecord);
}

void Recorder::timeoutKillRecord(){
    //m_recorder.stop();
    stopTimer();
    emit recordTimeout();
}

void Recorder::stopTimer(){
    m_recordTimer.stop();
}

bool Recorder::init(const QString &userName){
    m_userName = userName;
    m_bRecorderValid = setupAudioRecorder();
    if(!m_bRecorderValid){
        return false;
    }
    return true;
}

void Recorder::stopPlay(){
    if(m_player->state() == QMediaPlayer::PlayingState){
        m_player->stop();
    }
}

int Recorder::getVoiceTime(const QString &voicePath){
    m_player->setMedia(QMediaContent(QUrl::fromLocalFile(voicePath)));
    return m_player->duration() / 1000;
}

void Recorder::play(const QString &voicePath){
    static QString perVoice = "";
    if(m_player->state() == QMediaPlayer::PlayingState && perVoice == voicePath){
        m_player->stop();
    }else{
        perVoice = voicePath;
        m_player->setMedia(QMediaContent(QUrl::fromLocalFile(voicePath)));
        m_player->play();
    }
}

void Recorder::start(){
    if(m_bRecorderValid && m_recorder.state() == QMediaRecorder::StoppedState){
        qDebug() << "start record";
        m_bRecordSuccess = true;
        QString path = QString("%1%2%3.%4").arg(QDir::currentPath()+"/voice/")
                .arg(m_userName)
                .arg(QDateTime::currentDateTime().toString("yyMMdd-hhmmss"))
                .arg(m_recorder.containerFormat());
                //.arg("wav");
        qDebug() << "filePath: " << path;
        m_filePath = path;
        m_recorder.setOutputLocation(QUrl::fromLocalFile(m_filePath));
        m_recorder.record();
        m_recordTimer.start(15000);
    }
}

int Recorder::getFileSize(const QString &fName){
    QFile file(fName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return -1;
    }
    int s = file.size();
    file.close();
    return s;
}

QString Recorder::stop(){
    m_recorder.stop();
    int s = getFileSize(m_filePath);
    qDebug() << "fileSize: " << s / 1000 << " KB";
    QFile::setPermissions(m_filePath, QFile::ReadOwner |
                          QFile::WriteOwner | QFile::ReadOther |
                          QFile::ReadUser | QFile::ReadGroup);
    return m_filePath;
}

void Recorder::setupAudioPlayer(){
    m_player = new QMediaPlayer(this);
}

bool Recorder::setupAudioRecorder(){
    // inputs
    QStringList inputs = m_recorder.audioInputs();
    if(inputs.size() == 0) return false;
    qDebug() << "inputs: " << inputs;
    m_recorder.setAudioInput("default");

    // audio codecs
    QStringList codecs = m_recorder.supportedAudioCodecs();
    if(codecs.size() == 0) return false;
    qDebug() << "codecs: " << codecs;
    int sampleRate = 8000;
    if(codecs.contains("amr-nb")){
        m_settings.setCodec("amr-nb");
    }else if(codecs.contains("amr-wb")){
        m_settings.setCodec("amr-wb");
    }else{
        m_settings.setCodec(codecs.at(0));
        sampleRate = 8000;
    }
    qDebug() << "set codec: " << m_settings.codec();

    // containers
    QStringList containers = m_recorder.supportedContainers();
    if(containers.size() == 0) return false;
    qDebug() << "contatiners: " << containers;
    QString container;
    if(containers.contains("amr")){
        container = "amr";
    }else if(containers.contains("mp3")){
        container = "mp3";
    }else{
        container = containers.at(0);
    }

    // sample rate
    QList<int> sampleRates = m_recorder.supportedAudioSampleRates();
    if(sampleRates.size() == 0) return false;
    qDebug() << "sampleRates: " << sampleRates;
    if(sampleRates.size() && !sampleRates.contains(sampleRate)){
        sampleRate = sampleRates.at(0);
    }
    m_settings.setChannelCount(1);
    m_settings.setSampleRate(sampleRate);
    m_settings.setQuality(QMultimedia::NormalQuality);
    m_settings.setBitRate(64000);
    m_settings.setEncodingMode(QMultimedia::AverageBitRateEncoding);
    m_recorder.setEncodingSettings(m_settings,
                                   QVideoEncoderSettings(),
                                   container);
    connect(&m_recorder, SIGNAL(error(QMediaRecorder::Error)), this,
            SLOT(onRecordError(QMediaRecorder::Error)));
    return true;
}

void Recorder::onRecordError(QMediaRecorder::Error err){
    qDebug() << "record error - " << err;
    m_bRecordSuccess = false;
    emit recordError(err);
}
