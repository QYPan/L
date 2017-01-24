import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QmlInterface 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Text {
        id: socketState
        anchors.top: parent.top
        font.pointSize: 25
        text: "state: init"
    }

    Text {
        id: message
        anchors.top: socketState.bottom
        font.pointSize: 25
        text: "message:"
    }

    Text {
        id: error
        anchors.top: message.bottom
        font.pointSize: 25
        text: "error: no error"
    }

    Connections {
        target: qmlInterface
        onQmlReadData: {
            message.text = "message: " + data;
        }
        onDisplayError: {
            error.text = "error: " + message;
        }
        onQmlGetSocketState: {
            socketState.text = "state: " + stateMessage;
        }
    }

    TextEdit {
        id: textEdit
        text: qsTr("Enter some text...")
        font.pointSize: 27
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "transparent"
            border.width: 1
        }
    }

    Button {
        id: pushButton
        anchors.top: textEdit.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.5
        height: textEdit.height
        text: "发送"
        onClicked: {
            qmlInterface.qmlSendData(textEdit.text);
        }
    }
}
