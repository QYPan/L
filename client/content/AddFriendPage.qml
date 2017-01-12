import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    property string pageName: "addFriendPage"
    property alias titleName: topView.title
    property string oppName: ""
    signal sendMessage(string msg)
    color: "#212126"

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        titleSize: 60
        onBack: {
            stackView.pop();
        }
    }

    Column {
        id: checkMessage
        anchors.top: topView.bottom
        anchors.topMargin: topView.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 50
        Item {
            width: inputMessage.width
            height: checkTag.height + 20
            Text {
                id: checkTag
                text: qsTr("验证信息");
                color: "white"
                font.pixelSize: 50
                anchors.centerIn: parent
            }
        }
        InputLine {
            id: inputMessage
            width: root.width * 0.50
            font.pixelSize: 55
            maximumLength: 15
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: qsTr("非必须");
            focus: false
        }
    }

    GrayDialog {
        id: messageDialog
        visible: false
        height: parent.height / 5
        anchors.centerIn: parent
        textSize: 50
        onButtonClicked: {
            visible = false;
            root.setUnLockAll(true);
            addButton.enabled = false;
        }
    }

    GrayButton {
        id: addButton
        text: qsTr("加为好友");
        width: inputMessage.width
        height: topView.height
        anchors.top: checkMessage.bottom
        anchors.topMargin: height
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            root.setUnLockAll(false);
            if(oppName != ""){
                var language = qmlInterface.clientLanguage;
                var message = root.oppName + "#" + language.toString() + "#" +inputMessage.text;
                qmlInterface.qmlSendData(QmlInterface.ADD_ONE, message);
                messageDialog.setMessageText("请求已发送，等待对方回复！");
                messageDialog.visible = true;
            }
        }
    }

    function setUnLockAll(flag){ // 禁止所有组件活动
        inputMessage.enabled = flag;
        addButton.enabled = flag;
    }

}
