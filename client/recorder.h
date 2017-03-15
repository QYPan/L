#ifndef RECORDER_H
#define RECORDER_H

#include <QObject>
#include <QString>
#include <QMediaPlayer>
#include <QTimer>
#include <QAudioRecorder>
#include <QAudioEncoderSettings>

class Recorder : public QObject
{
    Q_OBJECT
public:
    Recorder(QObject *parent = 0);
    bool init(const QString &userName);
    void start();
    void play(const QString &voicePath);
    void stopTimer();
    QString stop();
signals:
    void recordError(QMediaRecorder::Error);
    void recordTimeout();
protected slots:
    void onRecordError(QMediaRecorder::Error);
private:
    void timeoutKillRecord();
    bool setupAudioRecorder();
    void setupAudioPlayer();
    int getFileSize(const QString &fName);
private:
    QMediaPlayer *m_player;
    QAudioRecorder m_recorder;
    QAudioEncoderSettings m_settings;
    QString m_filePath;
    QString m_userName;
    QTimer m_recordTimer;
    bool m_bRecorderValid;
    bool m_bRecordSuccess;
};

#endif // RECORDER_H
