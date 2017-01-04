#ifndef MYEVENTFILTER_H
#define MYEVENTFILTER_H

#include <QObject>
#include <QEvent>
#include <QKeyEvent>

class MyEventFilter : public QObject
{
    Q_OBJECT
public:
    MyEventFilter(QObject *parent = 0);
    void setRoot(QObject *obj);
    void installRootEventFilter();
signals:
    void touchBackKey();
protected:
    bool eventFilter(QObject *obj, QEvent *event);
private:
    QObject *m_root;
};

#endif // MYEVENTFILTER_H
