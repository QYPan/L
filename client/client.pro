TEMPLATE = app

QT += core qml quick network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

SOURCES += main.cpp \
    clientsocket.cpp \
    datastruct.cpp \
    myeventfilter.cpp \
    qmlinterface.cpp \
    socketthread.cpp \
    fileoperator.cpp \
    cachetext.cpp

RESOURCES += resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    clientsocket.h \
    datastruct.h \
    myeventfilter.h \
    qmlinterface.h \
    socketthread.h \
    fileoperator.h \
    cachetext.h
