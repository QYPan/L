import QtQuick 2.0
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "searchClientPage"

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("添加朋友");
        titleSize: 20
        onBack: {
            stackView.pop();
        }
    }

    Row {
        id: client
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Image {
            id: userImage
            source: "../images/userall.png"
            width: topView.height * 0.6
            height: width
        }
        Image {
            id: slashImage1
            source: "../images/slash.png"
            width: height * 0.5
            height: userImage.height
        }
        InputLine {
            id: inputName
            width: root.width * 0.50
            font.pointSize: 17
            maximumLength: 15
            inputMethodHints: Qt.ImhNoPredictiveText
            focus: false
        }
    }

    GrayButton {
        id: searchButton
        text: qsTr("搜 索");
        width: client.width
        height: topView.height * 0.7
        anchors.top: client.bottom
        anchors.topMargin: topView.height * 0.5
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
        anchors.topMargin: topView.height * 0.7
        height: 1
        color: "#424246"
    }

    Text {
        id: badMessage
        visible: false
        anchors.top: line.bottom
        anchors.topMargin: topView.height
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("查无此人")
        font.pointSize: 17
        color: "white"
    }

    GrayDialog {
        id: messageDialog
        visible: false
        height: parent.height / 5
        anchors.centerIn: parent
        textSize: 17
        onButtonClicked: {
            visible = false;
            root.setUnLockAll(true);
        }
    }

    GrayButton {
        id: friendID
        width: searchButton.width
        height: topView.height * 1.2
        visible: false;
        anchors.top: line.bottom
        anchors.topMargin: topView.height
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            tryAddClient();
        }
    }

    function tryAddClient(){
        var ok = cacheText.isExists(inputName.text);
        if(ok === false){
            var top = stackView.depth - 1;
            stackView.replace(Qt.resolvedUrl("AddClientPage.qml"));
            stackView.get(top).titleName = friendID.text;
            stackView.get(top).oppName = inputName.text;
        }else{
            messageDialog.setMessageText("无法重复添加好友！");
            messageDialog.visible = true;
            root.setUnLockAll(false);
        }
    }

    function setUnLockAll(flag){ // 禁止所有组件活动
        inputName.enabled = flag;
        searchButton.enabled = flag;
        friendID.enabled = flag;
    }

    function getLanguage(la){
        var language;
        if(parseInt(la) == QmlInterface.CHINESE){
            language = "中文";
        }else if(parseInt(la) == QmlInterface.ENGLISH){
            language = "English";
        }
        return language;
    }

    function searchResult(type, message){
        if(type === QmlInterface.SEARCH_SUCCESSED){
            var language;
            language = getLanguage(message);
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
