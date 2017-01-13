import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Item {
    id: root

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: messageListView
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: MessageItemDelegate{
            width: parent.width
            height: Screen.height * 0.1
            name: nameText
            language: languageText
            message: messageText
            newMessage: newMessageNumber
        }
    }

    function findItem(name){
        var i;
        for(i = 0; i < messageListView.count; i++){
            var currentItem = messageListView.model.get(i);
            if(currentItem.nameText === name){
                return i;
            }
        }
        return -1;
    }

    function addMessage(name, language, message){
        var index = findItem(name);
        if(index != -1){
            setMessage(index, message);
        }else{
            appendMessage(0, name, language, message);
        }
    }

    function setMessage(index, message){
        messageListView.model.setProperty(index, "messageText", message);
        var item = messageListView.model.get(index);
        var top = stackView.depth - 1;
        /*
        if(stackView.get(top).pageName == "talkPage" && stackView.get(top).clientName == item.nameText){
            return;
        }
        var number = parseInt(item.numberValue);
        number++;
        messageListView.model.setProperty(index, "numberValue", number.toString());
        */
    }

    function appendMessage(index, name, language, message){
        var slanguage;
        if(language === QmlInterface.CHINESE){
            slanguage = "CN";
        }else if(language === QmlInterface.ENGLISH){
            slanguage = "EN";
        }
        messageListView.model.insert(index, {"nameText" : name,
                                             "languageText" : slanguage,
                                             "messageText" : message,
                                             "newMessageNumber" : "1"})
    }
}
