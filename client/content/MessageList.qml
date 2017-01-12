import QtQuick 2.4
import QtQuick.Controls 1.3
import FileOperator 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    signal loaded()
    signal openTalkPage(string name, string language)

    ListView {
        id: messageListView
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: MsgDelegate {
            id: client
            name: cname
            message: cmessage
            language: clanguage
            numberText: numberValue
            onClicked:{
                numberValue = "0";
                openTalkPage(cname, clanguage);
            }
        }
    }

    Connections {
        id: receiveError
        target: qmlInterface
        onDisplayError: {
            //messageListView.model.insert(0, {"title" : message, "numberValue" : "-"})
        }
    }

    Component.onCompleted: { // 从本地加载消息列表
        loaded();
        //messageListView.model.insert(0, {"cname" : "fuck", "cmessage" : "一起吃饭"})
        //messageListView.model.insert(0, {"title" : "simple2", "numberValue" : "3"})
    }

    function findItem(name){
        var i;
        for(i = 0; i < messageListView.count; i++){
            var currentItem = messageListView.model.get(i);
            if(currentItem.cname === name){
                return i;
            }
        }
        return -1;
    }

    function changeMessage(name, language, message){
        var index = findItem(name);
        if(index != -1){
            setMessage(index, message);
        }else{
            appendMessage(0, name, language, message);
        }
    }

    function setMessage(index, message){
        messageListView.model.setProperty(index, "cmessage", message);
        var item = messageListView.model.get(index);
        var top = stackView.depth - 1;
        console.log(stackView.get(top).pageName);
        console.log(stackView.get(top).clientName);
        console.log(item.cname);
        if(stackView.get(top).pageName == "talkPage" && stackView.get(top).clientName == item.cname){
            return;
        }
        var number = parseInt(item.numberValue);
        number++;
        messageListView.model.setProperty(index, "numberValue", number.toString());
    }

    function appendMessage(index, name, language, message){
        if(language == "中文") language = "CN";
        else if(language == "English") language = "EN";
        messageListView.model.insert(index, {"cname" : name,
                                             "clanguage" : language,
                                             "cmessage" : message,
                                             "numberValue" : "1"})
    }
}
