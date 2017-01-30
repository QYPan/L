import QtQuick 2.0
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "searchClientPage"

    property int textSize1 : 17
    property int textSize2 : 20

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("添加朋友");
        titleSize: textSize2
        onBacked: {
            stackView.pop();
        }
    }

    Item {
        id: client
        width: root.width * 0.7
        height: root.width * 0.1
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: userImage
            source: "../images/userall.png"
            width: parent.height
            height: width
            anchors.left: parent.left
        }
        Image {
            id: slashImage1
            source: "../images/slash.png"
            width: userImage.width * 0.33
            height: userImage.height
            anchors.left: userImage.right
        }
        TextInput {
            id: inputName
            font.pointSize: 20
            color: "white"
            width: downLine1.width
            maximumLength: 16
            anchors.left: slashImage1.right
            anchors.leftMargin: slashImage1.width
            anchors.verticalCenter: slashImage1.verticalCenter
            onTextChanged: {
                //checkInput();
            }
        }
        Rectangle {
            id: downLine1
            height: 2
            color: "#3399ff"
            anchors.left: slashImage1.right
            anchors.leftMargin: slashImage1.width * 0.8
            anchors.right: parent.right
            anchors.bottom: parent.bottom
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
            goSearch();
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
        id: noticeMessage
        visible: false
        anchors.top: line.bottom
        anchors.topMargin: topView.height
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: textSize1
        color: "white"
    }

    GrayButton {
        id: friendID
        width: searchButton.width
        height: topView.height * 1.2
        visible: false;
        anchors.top: line.bottom
        anchors.topMargin: topView.height
        anchors.horizontalCenter: parent.horizontalCenter
        property string name
        property string language
        property int sex
        onClicked: {
            stackView.push(Qt.resolvedUrl("PersonalDataPage.qml"));
            var top = stackView.depth - 1;
            stackView.get(top).name = name;
            stackView.get(top).language = language;
            stackView.get(top).sex = sex;
            stackView.get(top).isFriend = qmlInterface.isLinkman(name);
        }
    }

    Connections {
        target: signalManager
        onSearchResult: {
            handleSearchResult(data);
        }
    }

    function handleSearchResult(data){
        var newData = JSON.parse(data);
        if(newData.result){
            friendID.name = newData.userInfo.name;
            friendID.language = newData.userInfo.language;
            friendID.sex = newData.userInfo.sex;
            friendID.text = newData.userInfo.name;
            friendID.visible = true;
            noticeMessage.visible = false;
        }else{
            noticeMessage.text = qsTr("用户 ID 不存在");
            noticeMessage.visible = true;
            friendID.visible = false;
        }
        lockAll(false);
    }

    function goSearch(){
        if(inputName.length && inputName.text != searchButton.preName){
            sendSearchRequest(inputName.text);
            noticeMessage.text = qsTr("正在搜索...");
            noticeMessage.visible = true;
            friendID.visible = false;
            lockAll(true);
            searchButton.preName = inputName.text;
        }
    }

    function sendSearchRequest(name){
        var data = {};
        data.mtype = "SYN";
        data.dtype = "SEARCH_CLIENT";
        data.clientName = name;
        var strOut = JSON.stringify(data);
        qmlInterface.qmlSendData(strOut);
    }

    function lockAll(flag){
        inputName.enabled = !flag;
        searchButton.buttonPressed = flag;
    }
}
