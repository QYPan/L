import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Item {
    id: root
    //property int textSize1: 13
    property int textSize2: 15
    property int textSize3: 17
    property int textSize4: 11

    property int totalNewMsgCount: 0

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: messageList
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: Item {
            id: itemDelegate
            width: parent.width
            height: Screen.height * 0.1
            property real edge: Screen.height * 0.07 * 0.3

            Rectangle {
                anchors.fill: parent
                color: "#11ffffff"
                visible: mouse.pressed
            }

            Rectangle {
                id: headImage
                width: parent.height * 0.7
                height: width
                color: "#dddddd"
                anchors.left: parent.left
                anchors.leftMargin: edge
                anchors.verticalCenter: parent.verticalCenter
                Item {
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    anchors.left: parent.left
                    anchors.top: parent.top
                    Text {
                        id: languageItem
                        text: itemLanguage
                        color: "black"
                        font.pointSize: textSize3
                        anchors.centerIn: parent
                    }
                }
                Image {
                    width: parent.width * 0.4
                    height: parent.height * 0.4
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    source: itemSex ? "../images/woman_image.png"
                                     : "../images/man_image.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#424246"
            }

            Text {
                id: nameItem
                text: itemName
                color: "white"
                font.pointSize: textSize3
                anchors.top: headImage.top
                anchors.left: headImage.right
                anchors.leftMargin: edge
            }

            Text {
                id: messageItem
                text: itemMessage
                width: parent.width * 0.6
                color: "#c0c0c0"
                font.pointSize: textSize2
                anchors.bottom: headImage.bottom
                anchors.left: headImage.right
                anchors.leftMargin: edge
                elide: Text.ElideRight
            }

            Image {
                id: messageBox
                width: Screen.height * 0.07 * 0.4
                height: width
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: parent.height * 0.3
                visible: (itemNewMsgCount === 0 // 如果没有新消息
                          ? false : true)
                source: "../images/messageBox.png"
                fillMode: Image.PreserveAspectFit
                Text {
                    id: messageNumber
                    color: "black"
                    text: itemNewMsgCount.toString()
                    font.pointSize: textSize4
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: {
                    touchMsgItem();
                }
                onDoubleClicked: {
                }
            }

            function touchMsgItem(){
                var userInfo = {};
                userInfo.name = itemName;
                userInfo.language = itemLanguage;
                userInfo.sex = itemSex;
                var userInfoStr = JSON.stringify(userInfo);
                signalManager.openTalkPage(userInfoStr, true);
            }
        }
    }

    Connections {
        target: signalManager
        onSendMessage: {
            handleSendMessageSignal(userInfoStr, msg);
        }
        onReceiveMessage: {
            handleReceiveMessageSignal(userInfoStr, msg);
        }
        onRemoveLinkman: {
            handleRemoveLinkmanSignal(name);
        }
        onStackPop: {
            handleStackPopSignal();
        }
    }


    function handleStackPopSignal(){
        var top = stackView.depth - 1;
        var topItem = stackView.get(top);
        if(topItem.pageName === "talkPage"){
            var index = findIndexByName(topItem.clientName);
            if(index !== -1){
                var curItem = messageList.model.get(index);
                root.totalNewMsgCount -= curItem.itemNewMsgCount;
                signalManager.updateNewMessageCount(root.totalNewMsgCount);
                messageList.model.setProperty(index, "itemNewMsgCount", 0);
                recordManager.stopPlayRecord();
            }
        }
        stackView.pop();
    }

    function handleRemoveLinkmanSignal(name){
        var index = findIndexByName(name);
        if(index !== -1){
            var curItem = messageList.model.get(index);
            root.totalNewMsgCount -= curItem.itemNewMsgCount;
            signalManager.updateNewMessageCount(root.totalNewMsgCount);
            messageList.model.remove(index);
        }
    }

    function handleReceiveMessageSignal(userInfoStr, msg){
        var userInfo = JSON.parse(userInfoStr);
        changeMessage(userInfo, msg);
    }

    function handleSendMessageSignal(userInfoStr, msg){
        var userInfo = JSON.parse(userInfoStr);
        changeMessage(userInfo, msg);
    }

    function changeMessage(userInfo, msg){
        var index = findIndexByName(userInfo.name);
        root.totalNewMsgCount += 1;
        signalManager.updateNewMessageCount(root.totalNewMsgCount);
        if(index !== -1){
            setMessage(index, msg);
        }else{
            addMessageItem(userInfo, msg);
        }
    }

    function findIndexByName(name){
        var i;
        for(i = 0; i < messageList.count; i++){
            var currentItem = messageList.model.get(i);
            if(currentItem.itemName === name){
                return i;
            }
        }
        return -1;
    }

    function setMessage(index, msg){
        var data = messageList.model.get(index);
        var newMsgCount = data.itemNewMsgCount + 1;
        messageList.model.setProperty(index, "itemMessage", msg);
        messageList.model.setProperty(index, "itemNewMsgCount", newMsgCount);
        messageList.model.move(index, 0, 1);
    }

    function addMessageItem(userInfo, msg){
        messageList.model.insert(0, {"itemName" : userInfo.name,
                                            "itemLanguage" : userInfo.language,
                                            "itemSex" : userInfo.sex,
                                            "itemNewMsgCount" : 1,
                                            "itemMessage" : msg});
    }

    Component.onCompleted: {
    }
}
