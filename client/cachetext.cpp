#include "cachetext.h"

CacheText::CacheText(QObject *parent)
    : QObject(parent)
    , seg_char('\n')
{

}

void CacheText::push(CacheType type, const QString &message){
    if(type == NEW_FRIEND){
        if(!newFriendRequest.isEmpty()) // 非空时加入分隔符
            newFriendRequest.append(QString(seg_char));
        newFriendRequest.append(message);
        typeCount[type]++;
    }
}

int CacheText::getCount(CacheType type){
    return typeCount[type];
}

QString CacheText::pull(CacheType type){
    if(type == NEW_FRIEND){
        return newFriendRequest;
    }
}

void CacheText::readed(CacheType type){
    if(type == NEW_FRIEND){
        newFriendRequest.clear();
        typeCount[type] = 0;
    }
}
