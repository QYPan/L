import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "addClientPage"
    property alias titleName: topView.title

    property int textSize1 : 17
    property int textSize2 : 20

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        titleSize: textSize2
        onBacked: {
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
            width: root.width * 0.7
            height: topView.height
            Text {
                id: checkTag
                text: qsTr("验证信息");
                color: "white"
                font.pointSize: textSize1
                anchors.centerIn: parent
            }
        }
        Item {
            width: root.width * 0.7
            height: topView.height
            TextInput {
                id: inputMessage
                anchors.centerIn: parent
                font.pointSize: textSize1
                color: "white"
                maximumLength: 15
                horizontalAlignment: TextInput.AlignHCenter
                focus: false
                Component.onCompleted: {
                    text = qsTr("我是") + qmlInterface.clientName;
                }
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 2
                color: "#3399ff"
            }
        }
    }

    GrayButton {
        id: addButton
        text: qsTr("加为好友");
        width: parent.width * 0.7
        height: topView.height
        anchors.top: checkMessage.bottom
        anchors.topMargin: height
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            sendRequest(titleName, inputMessage.text);
        }
    }

    Connections {
        target: signalManager
        onVerifyAck: {
            handleVerifyAck();
        }
    }

    function handleVerifyAck(){
        addButton.text = qsTr("请求已发送");
    }

    function sendRequest(name, msg){
        var data = {};
        var userInfo = {};
        data.mtype = "SYN";
        data.dtype = "VERIFY";
        data.oppClientName = name;
        data.verifyMsg = msg;
        userInfo.name = qmlInterface.clientName;
        userInfo.language = qmlInterface.clientLanguage;
        userInfo.sex = qmlInterface.sex;
        data.userInfo = userInfo;
        var strOut = JSON.stringify(data);
        qmlInterface.qmlSendData(strOut);
        addButton.text = qsTr("正在发送请求...");
        addButton.buttonPressed = true;
    }
}
