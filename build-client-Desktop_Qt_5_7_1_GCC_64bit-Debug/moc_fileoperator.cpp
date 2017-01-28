/****************************************************************************
** Meta object code from reading C++ file 'fileoperator.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../Lclient/fileoperator.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'fileoperator.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_FileOperator_t {
    QByteArrayData data[12];
    char stringdata0[99];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FileOperator_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FileOperator_t qt_meta_stringdata_FileOperator = {
    {
QT_MOC_LITERAL(0, 0, 12), // "FileOperator"
QT_MOC_LITERAL(1, 13, 5), // "touch"
QT_MOC_LITERAL(2, 19, 0), // ""
QT_MOC_LITERAL(3, 20, 8), // "fileName"
QT_MOC_LITERAL(4, 29, 8), // "openFile"
QT_MOC_LITERAL(5, 38, 9), // "closeFile"
QT_MOC_LITERAL(6, 48, 4), // "seek"
QT_MOC_LITERAL(7, 53, 3), // "pos"
QT_MOC_LITERAL(8, 57, 9), // "addFriend"
QT_MOC_LITERAL(9, 67, 10), // "friendName"
QT_MOC_LITERAL(10, 78, 8), // "language"
QT_MOC_LITERAL(11, 87, 11) // "readFriends"

    },
    "FileOperator\0touch\0\0fileName\0openFile\0"
    "closeFile\0seek\0pos\0addFriend\0friendName\0"
    "language\0readFriends"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FileOperator[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   44,    2, 0x02 /* Public */,
       4,    1,   47,    2, 0x02 /* Public */,
       5,    0,   50,    2, 0x02 /* Public */,
       6,    1,   51,    2, 0x02 /* Public */,
       8,    2,   54,    2, 0x02 /* Public */,
      11,    0,   59,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Void,
    QMetaType::Bool, QMetaType::LongLong,    7,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    9,   10,
    QMetaType::QString,

       0        // eod
};

void FileOperator::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        FileOperator *_t = static_cast<FileOperator *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { bool _r = _t->touch((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 1: { bool _r = _t->openFile((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 2: _t->closeFile(); break;
        case 3: { bool _r = _t->seek((*reinterpret_cast< qint64(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 4: _t->addFriend((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 5: { QString _r = _t->readFriends();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObject FileOperator::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_FileOperator.data,
      qt_meta_data_FileOperator,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *FileOperator::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FileOperator::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_FileOperator.stringdata0))
        return static_cast<void*>(const_cast< FileOperator*>(this));
    return QObject::qt_metacast(_clname);
}

int FileOperator::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
