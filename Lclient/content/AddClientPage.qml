import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    property string pageName: "addClientPage"
    property alias titleName: topView.title
    property string oppName: ""
    signal sendMessage(string msg)
    color: "#212126"

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        titleSize: 20
        onBack: {
            stackView.pop();
        }
    }

    Column {
        id: checkMessage
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 2.0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: topView.height * 0.4
        Item {
            width: inputMessage.width
            height: topView.height
            Text {
                id: checkTag
                text: qsTr("验证信息");
                color: "white"
                font.pointSize: 15
                anchors.centerIn: parent
            }
        }
        InputLine {
            id: inputMessage
            width: root.width * 0.50
            font.pointSize: 15
            maximumLength: 15
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: qsTr("非必须");
            focus: false
            Component.onCompleted: {
                text = qsTr("我是") + qmlInterface.clientName;
            }
        }
    }

    GrayButton {
        id: addButton
        text: qsTr("加为好友");
        width: parent.width * 0.5
        height: topView.height * 0.7
        anchors.top: checkMessage.bottom
        anchors.topMargin: height
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            sendRequest();
        }
    }

    function sendRequest(){
        if(oppName != ""){
            var language = qmlInterface.clientLanguage;
            var message = oppName + "#" + language.toString() + "#" +inputMessage.text;
            qmlInterface.qmlSendData(QmlInterface.ADD_ONE, message);
            addButton.text = "请求已发送！"
            addButton.enabled = false;
        }
    }

}
