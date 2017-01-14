import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Item {
    id: root
    signal messageClicked(string name, int language)

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
            onClicked: {
                newMessageNumber = "0";
                root.messageClicked(name, modelLanguage(languageText));
            }
        }
    }

    function modelLanguage(la){
        if(la == "CN"){
            //return qmlInterface.CHINESE;
            return 0;
        }else{
            //return qmlInterface.ENGLISH;
            return 1;
        }
    }

    function removeItem(name){
        var index = findItem(name);
        if(index != -1){
            messageListView.model.remove(index);
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
        if(stackView.get(top).pageName == "talkPage" && stackView.get(top).clientName == item.nameText){
            return;
        }
        var number = parseInt(item.newMessageNumber);
        number++;
        messageListView.model.setProperty(index, "newMessageNumber", number.toString());
    }

    function appendMessage(index, name, language, message){
        var slanguage;
        if(language === QmlInterface.CHINESE){
            slanguage = "CN";
        }else if(language === QmlInterface.ENGLISH){
            slanguage = "EN";
        }
        var value;
        if(qmlInterface.clientName == name){
            value = "0";
        }else{
            value = "1";
        }
        messageListView.model.insert(index, {"nameText" : name,
                                             "languageText" : slanguage,
                                             "messageText" : message,
                                             "newMessageNumber" : value})
    }
}
