TEMPLATE = app

QT += core qml quick network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

SOURCES += main.cpp \
    clientmap.cpp \
    clientsocket.cpp \
    datastruct.cpp \
    myeventfilter.cpp \
    qmlinterface.cpp \
    socketthread.cpp \
    fileoperator.cpp

RESOURCES += resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    clientmap.h \
    clientsocket.h \
    datastruct.h \
    myeventfilter.h \
    qmlinterface.h \
    socketthread.h \
    fileoperator.h
