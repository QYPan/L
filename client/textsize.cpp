#include "textsize.h"

TextSize::TextSize(QObject *parent)
    : QObject(parent)
    , m_sizeA(10)
    , m_sizeB(13)
    , m_sizeC(15)
    , m_sizeD(17)
    , m_sizeE(20)
    , m_sizeF(25)
    , m_sizeG(30)
{

}

int TextSize::sizeA() const{
    return m_sizeA;
}

void TextSize::setSizeA(int textSize){
    m_sizeA = textSize;
}

int TextSize::sizeB() const{
    return m_sizeB;
}

void TextSize::setSizeB(int textSize){
    m_sizeB = textSize;
}

int TextSize::sizeC() const{
    return m_sizeC;
}

void TextSize::setSizeC(int textSize){
    m_sizeC = textSize;
}

int TextSize::sizeD() const{
    return m_sizeD;
}

void TextSize::setSizeD(int textSize){
    m_sizeD = textSize;
}

int TextSize::sizeE() const{
    return m_sizeE;
}

void TextSize::setSizeE(int textSize){
    m_sizeE = textSize;
}

int TextSize::sizeF() const{
    return m_sizeF;
}

void TextSize::setSizeF(int textSize){
    m_sizeF = textSize;
}

int TextSize::sizeG() const{
    return m_sizeG;
}

void TextSize::setSizeG(int textSize){
    m_sizeG = textSize;
}
