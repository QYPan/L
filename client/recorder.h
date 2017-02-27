#ifndef RECORDER_H
#define RECORDER_H

#include <QObject>
#include <QString>
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
    void stop();
    void stopTimer();
signals:
    void recordError(QMediaRecorder::Error);
    void recordTimeout();
protected slots:
    void onRecordError(QMediaRecorder::Error);
private:
    void timeoutKillRecord();
    bool setupAudioRecorder();
    int getFileSize(const QString &fName);
private:
    QAudioRecorder m_recorder;
    QAudioEncoderSettings m_settings;
    QString m_filePath;
    QString m_userName;
    QTimer m_recordTimer;
    bool m_bRecorderValid;
    bool m_bRecordSuccess;
};

#endif // RECORDER_H
