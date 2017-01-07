import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.0
import QmlInterface 1.0
import FileOperator 1.0

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#212126"
    property string pageName: "searchFriendsPage"

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
            text: qsTr("添加朋友");
        }
    }

    Row {
        id: user
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Image {
            id: userImage
            source: "../images/userall.png"
            width: 70
            height: width
        }
        Image {
            id: slashImage1
            source: "../images/slash.png"
            width: 50
            height: userImage.height
        }
        InputLine {
            id: inputName
            width: root.width * 0.50
            font.pixelSize: 55
            maximumLength: 15
            inputMethodHints: Qt.ImhNoPredictiveText
            focus: false
        }
    }

    GrayButton {
        id: searchButton
        text: qsTr("搜 索");
        width: user.width
        height: 90
        anchors.top: user.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        property string preName: ""
        onClicked: {
            focus = true;
            if(inputName.length && inputName.text != preName){
                qmlInterface.qmlSendData(QmlInterface.SEARCH_REQUEST, inputName.text);
                preName = inputName.text;
            }
        }
    }

    Rectangle {
        id: line
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        anchors.top: searchButton.bottom
        anchors.topMargin: 50
        height: 1
        color: "#424246"
    }

    Text {
        id: badMessage
        visible: false
        anchors.top: line.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("查无此人")
        font.pixelSize: 50
        color: "white"
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
        }
    }

    GrayButton {
        id: friendID
        width: searchButton.width
        height: topView.height * 1.3
        visible: false;
        anchors.top: line.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            var ok = root.isExistsFriend(inputName.text);
            if(ok === true){
                stackView.replace(Qt.resolvedUrl("AddFriendPage.qml"));
                stackView.get(stackView.depth-1).titleName = friendID.text;
                stackView.get(stackView.depth-1).oppName = inputName.text;
            }else{
                messageDialog.setMessageText("无法重复添加好友！");
                messageDialog.visible = true;
                root.setUnLockAll(false);
            }
        }
    }

    FileOperator {
        id: fileOperator
    }

    function setUnLockAll(flag){ // 禁止所有组件活动
        inputName.enabled = flag;
        searchButton.enabled = flag;
        friendID.enabled = flag;
    }

    function isExistsFriend(name){
        var fileName = qmlInterface.clientName + "-friends.txt";
        if(fileOperator.openFile(fileName)){
            var friends = fileOperator.readFriends();
            fileOperator.closeFile();
            console.log("in qml: " + friends);
            return checkFriends(name, friends);
            //addFriends(friends);
        }
    }

    function checkFriends(name, friends){
        if(friends.length === 0)
            return false;
        var splitFriends = friends.split("#");
        var i;
        for(i = 0; i < splitFriends.length; i++){
            var two = splitFriends[i].split(":");
            if(name === two[0]){
                return false;
            }
        }
        return true;
    }

    function searchResult(type, message){
        if(type === QmlInterface.SEARCH_SUCCESSED){
            var language;
            if(parseInt(message) == QmlInterface.CHINESE){
                language = "中文";
            }else if(parseInt(message) == QmlInterface.ENGLISH){
                language = "English";
            }
            friendID.text = inputName.text + "  |  " + language;
            friendID.visible = true;
            if(badMessage.visible){
                badMessage.visible = false;
            }
        }else{
            badMessage.visible = true;
            if(friendID.visible){
                friendID.visible = false;
            }
        }
    }
}
