#ifndef TEXTSIZE_H
#define TEXTSIZE_H

#include <QObject>

class TextSize : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(QString clientName READ clientName WRITE setClientName)
    Q_PROPERTY(int sizeA READ sizeA WRITE setSizeA NOTIFY sizeAChanged)
    Q_PROPERTY(int sizeB READ sizeB WRITE setSizeB NOTIFY sizeBChanged)
    Q_PROPERTY(int sizeC READ sizeC WRITE setSizeC NOTIFY sizeCChanged)
    Q_PROPERTY(int sizeD READ sizeD WRITE setSizeD NOTIFY sizeDChanged)
    Q_PROPERTY(int sizeE READ sizeE WRITE setSizeE NOTIFY sizeEChanged)
    Q_PROPERTY(int sizeF READ sizeF WRITE setSizeF NOTIFY sizeFChanged)
    Q_PROPERTY(int sizeG READ sizeG WRITE setSizeG NOTIFY sizeGChanged)
public:
    TextSize(QObject *parent = 0);
    int sizeA() const;
    void setSizeA(int textSize);
    int sizeB() const;
    void setSizeB(int textSize);
    int sizeC() const;
    void setSizeC(int textSize);
    int sizeD() const;
    void setSizeD(int textSize);
    int sizeE() const;
    void setSizeE(int textSize);
    int sizeF() const;
    void setSizeF(int textSize);
    int sizeG() const;
    void setSizeG(int textSize);
signals:
    void sizeAChanged(int textSize);
    void sizeBChanged(int textSize);
    void sizeCChanged(int textSize);
    void sizeDChanged(int textSize);
    void sizeEChanged(int textSize);
    void sizeFChanged(int textSize);
    void sizeGChanged(int textSize);
private:
    int m_sizeA, m_sizeB, m_sizeC, m_sizeD, m_sizeE, m_sizeF, m_sizeG;
};

#endif // TEXTSIZE_H
