#ifndef RECORDMANAGER_H
#define RECORDMANAGER_H

#include <QObject>
#include <QString>
#include "recorder.h"

class RecordManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
public:
    Q_INVOKABLE void startRecord();
    Q_INVOKABLE void stopRecord();
    Q_INVOKABLE bool recordReady();
    Q_INVOKABLE void initRecord();
    RecordManager(QObject *parent = 0);
    QString userName() const;
    void setUserName(const QString &name);
signals:
    void stopped();
    void recordError(QMediaRecorder::Error);
    void userNameChanged(const QString &name);
    void recordTimeout();
private:
    Recorder m_recorder;
    QString m_userName;
    bool m_isReady;
};

#endif // RECORDMANAGER_H
