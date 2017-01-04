#include "myeventfilter.h"
#include <QDebug>

MyEventFilter::MyEventFilter(QObject *parent)
    : QObject(parent)
    , m_root(NULL)
{
}

bool MyEventFilter::eventFilter(QObject *obj, QEvent *event){
    if(obj == m_root){
        QEvent::Type t = event->type();
        switch(t){
        case QEvent::KeyPress:
            if((static_cast<QKeyEvent *>(event))->key() == Qt::Key_Back){
                event->accept();
                return true;
            }
            break;
        case QEvent::KeyRelease:
            if((static_cast<QKeyEvent *>(event))->key() == Qt::Key_Back){
                qDebug() << "event filter for - " << obj;
                emit touchBackKey();
                event->accept();
                return true;
            }
            break;
        default:
            break;
        }
    }
    return QObject::eventFilter(obj, event);
}

void MyEventFilter::installRootEventFilter(){
    m_root->installEventFilter(this);
}

void MyEventFilter::setRoot(QObject *obj){
    m_root = obj;
}
