import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

Rectangle {
    id: root
    color: "#212126"

    property string pageName: "talkPage"
    property string clientName
    property string language
    property int sex

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: clientName
        titleSize: 20
        onBacked: {
            stackView.pop();
        }
    }

    ListView {
        id: msgList
        anchors.left: parent.left
        anchors.leftMargin: topView.height * 0.2
        anchors.right: parent.right
        anchors.rightMargin: topView.height * 0.2
        anchors.top: topView.bottom
        anchors.bottom: inputBackground.top
        currentIndex: count - 1
        clip: true
        spacing: topView.height * 0.3
        model: ListModel {}
        delegate: Item {
            id: talkDelegate
            property bool isSelf: itemName == qmlInterface.clientName
            property real xCoor: isSelf ? width - headImage.width : 0.0
            property real edge: topView.height * 0.2
            property real msgLimitLength: width - 2 * headImage.width - 6 * edge
            anchors.left: parent.left
            anchors.right: parent.right
            height: edge + msgBackground.height
            Rectangle {
                id: headImage
                color: "#dddddd"
                width: topView.height
                height: width
                x: xCoor
                y: edge
                Item {
                    width: parent.width * 0.2
                    height: parent.height * 0.2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    Text {
                        id: sexText
                        text: itemSex.toString()
                        font.pointSize: 13
                        color: "black"
                        anchors.centerIn: parent
                    }
                }
                Text {
                    id: languageItem
                    text: itemLanguage
                    color: "black"
                    font.pointSize: 20
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                id: busyState
                width: headImage.width * 0.4
                height: width
                color: "blue"
                visible: isItemBusy
                anchors.verticalCenter: headImage.verticalCenter
                x: isSelf ? msgBackground.x - width - edge :
                            msgBackground.x + msgBackground.width + edge
            }

            Rectangle {
                id: msgBackground
                x: isSelf ? parent.width - headImage.width - 2*edge - width : headImage.width + 2*edge
                y: edge
                width: msg.width + 2 * edge
                height: msg.height + 2 * edge > headImage.height ?
                            msg.height + 2 * edge : headImage.height
                color: isSelf ? (textTouch.pressed ? "#808080" : "#969696")
                           :(textTouch.pressed ? "#c0c0c0" : "#dddddd")
                radius: 6
                Text {
                    id: msg
                    text: itemMsg
                    font.pointSize: 17
                    anchors.centerIn: parent
                    width: msgLength < talkDelegate.msgLimitLength ?
                               msgLength : talkDelegate.msgLimitLength
                    wrapMode: Text.Wrap
                }
                MouseArea {
                    id: textTouch
                    anchors.fill: parent
                }
            }
        }
    }

    Item {
        property int h: sayOrInput.height + 2 * downRect.height
        id: inputBackground
        width: parent.width
        height: h > inputMsg.height ? h : inputMsg.height
        anchors.bottom: downRect.top
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#424246"
        }
        Rectangle {
            id: sayOrInput
            width: topView.height * 0.7
            height: width
            color: "transparent"
            border.color: "#3399ff"
            border.width: 1
            anchors.left: parent.left
            anchors.leftMargin: topView.height * 0.2
            anchors.bottom: parent.bottom
        }
        Item {
            id: inputBox
            height: sayOrInput.height
            anchors.left: sayOrInput.right
            anchors.leftMargin: topView.height * 0.15
            anchors.right: sendButton.left
            anchors.rightMargin: topView.height * 0.15
            anchors.bottom: parent.bottom
            TextInput {
                id: inputMsg
                color: "white"
                font.pointSize: 17
                maximumLength: 200
                wrapMode: TextInput.WrapAnywhere
                anchors.left: parent.left
                anchors.leftMargin: topView.height * 0.15
                anchors.right: parent.right
                anchors.rightMargin: topView.height * 0.15
                anchors.bottom: downLine.top
            }
            Rectangle {
                id: downLine
                height: 2
                color: "#3399ff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
        GrayButton {
            id: sendButton
            width: root.width * 0.16
            height: sayOrInput.height
            text: qsTr("发送");
            textSize: 13
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.2
            anchors.bottom: parent.bottom
            onClicked: {
                sendButtonClicked();
            }
        }
    }

    Item {
        id : downRect
        width: parent.width
        height: topView.height * 0.15
        anchors.bottom: parent.bottom
    }

    Text { // 用来测量消息长度
        id: msgDont
        visible: false
        font.pointSize: 17
    }

    function sendButtonClicked(){
        if(inputMsg.length){
            var userInfo = {};
            userInfo.name = qmlInterface.clientName;
            userInfo.language = qmlInterface.clientLanguage;
            userInfo.sex = qmlInterface.sex;
            appendMsg(userInfo, inputMsg.text, true);
            sendMessage(userInfo, root.clientName, inputMsg.text);

            var oppUserInfo = {};
            oppUserInfo.name = root.clientName;
            oppUserInfo.language = root.language;
            oppUserInfo.sex = root.sex;
            var userInfoStr = JSON.stringify(oppUserInfo);
            signalManager.sendMessage(userInfoStr, inputMsg.text);

            inputMsg.text = "";
        }
    }

    function sendMessage(userInfo, oppName, msg){
        var data = {};
        data.mtype = "SYN";
        data.dtype = "TRANSPOND";
        data.oppName = oppName;
        data.msg = msg;
        data.userInfo = userInfo;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
    }

    function appendMsg(userInfo, msg, isItemBusy){
        msgDont.text = msg;
        var len = msgDont.width;
        msgList.model.append({"itemName" : userInfo.name,
                              "itemLanguage" : userInfo.language,
                              "itemMsg" : msg,
                              "msgLength" : len,
                              "isItemBusy" : isItemBusy,
                              "itemSex" : userInfo.sex});
    }

    function findFirstBusyIndex(){
        var i;
        var currentItem;
        for(i = msgList.count-1; i >= 0; i--){
            currentItem = msgList.model.get(i);
            if(currentItem.itemName === qmlInterface.clientName && (!currentItem.isItemBusy)){
                break; // 找到第一个己方的非发送状态的消息
            }
        }
        var j;
        for(j = i+1; j < msgList.count; j++){
            currentItem = msgList.model.get(j);
            if(currentItem.itemName === qmlInterface.clientName && currentItem.isItemBusy){
                break;
            } // 找到己方的第一个处于正在发送状态的消息
        }
        return j;
    }

    function killBusy(index){
        msgList.model.setProperty(index, "isItemBusy", false);
    }
}
