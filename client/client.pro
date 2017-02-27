TEMPLATE = app

QT += gui qml quick network multimedia
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
CONFIG += c++11

SOURCES += main.cpp \
    cachemanager.cpp \
    clientsocket.cpp \
    qmlinterface.cpp \
    signalmanager.cpp \
    socketthread.cpp \
    textsize.cpp \
    recordmanager.cpp \
    recorder.cpp

RESOURCES += resources.qrc

RC_FILE += title_logo.rc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cachemanager.h \
    clientsocket.h \
    qmlinterface.h \
    signalmanager.h \
    socketthread.h \
    textsize.h \
    recordmanager.h \
    recorder.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
