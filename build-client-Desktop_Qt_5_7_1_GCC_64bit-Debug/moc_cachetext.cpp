/****************************************************************************
** Meta object code from reading C++ file 'cachetext.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../Lclient/cachetext.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'cachetext.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_CacheText_t {
    QByteArrayData data[23];
    char stringdata0[205];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_CacheText_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_CacheText_t qt_meta_stringdata_CacheText = {
    {
QT_MOC_LITERAL(0, 0, 9), // "CacheText"
QT_MOC_LITERAL(1, 10, 4), // "push"
QT_MOC_LITERAL(2, 15, 0), // ""
QT_MOC_LITERAL(3, 16, 4), // "type"
QT_MOC_LITERAL(4, 21, 7), // "message"
QT_MOC_LITERAL(5, 29, 3), // "pop"
QT_MOC_LITERAL(6, 33, 6), // "readed"
QT_MOC_LITERAL(7, 40, 8), // "getCount"
QT_MOC_LITERAL(8, 49, 15), // "initAddressList"
QT_MOC_LITERAL(9, 65, 7), // "friends"
QT_MOC_LITERAL(10, 73, 11), // "loadToCache"
QT_MOC_LITERAL(11, 85, 15), // "pullAddressList"
QT_MOC_LITERAL(12, 101, 9), // "addFriend"
QT_MOC_LITERAL(13, 111, 4), // "name"
QT_MOC_LITERAL(14, 116, 8), // "language"
QT_MOC_LITERAL(15, 125, 12), // "removeFriend"
QT_MOC_LITERAL(16, 138, 8), // "isExists"
QT_MOC_LITERAL(17, 147, 8), // "clearAll"
QT_MOC_LITERAL(18, 156, 7), // "saveAll"
QT_MOC_LITERAL(19, 164, 9), // "saveCache"
QT_MOC_LITERAL(20, 174, 11), // "saveFriends"
QT_MOC_LITERAL(21, 186, 9), // "setClient"
QT_MOC_LITERAL(22, 196, 8) // "password"

    },
    "CacheText\0push\0\0type\0message\0pop\0"
    "readed\0getCount\0initAddressList\0friends\0"
    "loadToCache\0pullAddressList\0addFriend\0"
    "name\0language\0removeFriend\0isExists\0"
    "clearAll\0saveAll\0saveCache\0saveFriends\0"
    "setClient\0password"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_CacheText[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      15,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    2,   89,    2, 0x02 /* Public */,
       5,    1,   94,    2, 0x02 /* Public */,
       6,    1,   97,    2, 0x02 /* Public */,
       7,    1,  100,    2, 0x02 /* Public */,
       8,    1,  103,    2, 0x02 /* Public */,
      10,    1,  106,    2, 0x02 /* Public */,
      11,    0,  109,    2, 0x02 /* Public */,
      12,    2,  110,    2, 0x02 /* Public */,
      15,    1,  115,    2, 0x02 /* Public */,
      16,    1,  118,    2, 0x02 /* Public */,
      17,    0,  121,    2, 0x02 /* Public */,
      18,    1,  122,    2, 0x02 /* Public */,
      19,    1,  125,    2, 0x02 /* Public */,
      20,    1,  128,    2, 0x02 /* Public */,
      21,    2,  131,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Void, QMetaType::Int, QMetaType::QString,    3,    4,
    QMetaType::QString, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Int, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::QString,
    QMetaType::Int, QMetaType::QString, QMetaType::Int,   13,   14,
    QMetaType::Int, QMetaType::QString,   13,
    QMetaType::Bool, QMetaType::QString,   13,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,   13,   22,

 // enums: name, flags, count, data

 // enum data: key, value

       0        // eod
};

void CacheText::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        CacheText *_t = static_cast<CacheText *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->push((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 1: { QString _r = _t->pop((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 2: _t->readed((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: { int _r = _t->getCount((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 4: _t->initAddressList((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->loadToCache((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: { QString _r = _t->pullAddressList();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 7: { int _r = _t->addFriend((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 8: { int _r = _t->removeFriend((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 9: { bool _r = _t->isExists((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 10: _t->clearAll(); break;
        case 11: _t->saveAll((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 12: _t->saveCache((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 13: _t->saveFriends((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 14: _t->setClient((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        default: ;
        }
    }
}

const QMetaObject CacheText::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_CacheText.data,
      qt_meta_data_CacheText,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *CacheText::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CacheText::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_CacheText.stringdata0))
        return static_cast<void*>(const_cast< CacheText*>(this));
    return QObject::qt_metacast(_clname);
}

int CacheText::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 15;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
