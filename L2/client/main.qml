import QtQuick 2.5
import QtQuick.Window 2.2
import QmlInterface 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    MouseArea {
        anchors.fill: parent
        onClicked: {
            qmlInterface.qmlSendData(textEdit.text);
        }
    }

    Text {
        id: socketState
        anchors.top: parent.top
        font.pointSize: 25
        text: "state: disconnect"
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
}
