import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    property alias titleName: title.text
    property string oppName: ""
    property bool isTalkPage: true
    signal sendMessage(string msg)
    color: "#212126"
    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Rectangle {
            id: backButton
            width: opacity ? parent.height*0.7 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: parent.height * 0.7
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.fill: parent
                source: "../images/navigation_previous_item.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                //anchors.margins: -10
                onClicked:{
                    stackView.pop();
                }
            }
        }

        Text {
            id: title
            font.pixelSize: 60
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 30
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "L"
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
