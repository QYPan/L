import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "personalDataPage"
    property alias name: nameItem.text
    property alias language: languageItem.text
    property alias canDelete: deleteButton.visible

    signal goDeleteFriend(string name)
    signal openTalkPageRequest(string name, int language)

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("详细资料");
        titleSize: 20
        onBack: {
            stackView.pop();
        }
    }

    Column {
        id: info
        anchors.top: parent.top
        anchors.topMargin: topView.height * 3
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: topView.height * 0.5
        Item {
            width: hLine.width
            height: nameItem.height
            Text {
                id: nameItem
                color: "white"
                font.pointSize: 17
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: hLine
            width: root.width * 0.50
            height: 2
            color: "#424246"
        }
        Item {
            width: hLine.width
            height: nameItem.height
            Text {
                id: languageItem
                color: "white"
                font.pointSize: 17
                anchors.centerIn: parent
            }
        }
    }

    GrayButton {
        id: sendButton
        width: hLine.width
        height: width * 0.2
        text: qsTr("发消息")
        anchors.top: info.bottom
        anchors.topMargin: topView.height * 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            //stackView.replace(Qt.resolvedUrl("TalkPage.qml"));
            root.openTalkPageRequest(root.name, getLanguage(root.language));
        }
    }

    GrayButton {
        id: deleteButton
        width: hLine.width
        height: width * 0.2
        text: qsTr("删除好友")
        anchors.top: sendButton.bottom
        anchors.topMargin: topView.height * 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            tryDeleteFriend(root.name);
        }
    }

    GrayCheckDialog {
        id: checkDialog
        anchors.centerIn: parent
        textSize: 13
        height: parent.height * 0.2
        visible: false
        onButtonClicked: {
            setUnLockAll(true);
            visible = false;
        }
        onYesClicked: {
            stackView.pop();
            goDeleteFriend(root.name);
        }
        onNoClicked: {
        }
    }

    function getLanguage(la){
        if(la == "中文"){
            //return qmlInterface.CHINESE;
            return 0;
        }else{
            //return qmlInterface.ENGLISH;
            return 1;
        }
    }

    function tryDeleteFriend(friendName){
        checkDialog.setMessageText("确认删除 "+friendName+" ？");
        checkDialog.visible = true;
        setUnLockAll(false);
    }

    function setUnLockAll(flag){ // 禁止所有组件活动
        sendButton.enabled = flag;
        deleteButton.enabled = flag;
    }

}

