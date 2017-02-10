import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: root
    property alias textHeight: dialogMessage.height
    property int textSize: 17
    property int textSize1: 15
    signal buttonClicked()
    signal yesClicked()
    signal noClicked()
    z: 30
    gradient: Gradient {
                GradientStop {position: 0.0; color: "#969696"}
                GradientStop {position: 1.0; color: "#242424"}
    }
    Item {
        id: textBackground
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonRows.top
        Text {
            id: dialogMessage
            font.pointSize: textSize
            width: root.width - Screen.height * 0.07 * 0.4
            anchors.centerIn: parent
            wrapMode: Text.Wrap
        }
    }
    Item {
        id: buttonRows
        width: parent.width
        height: Screen.height * 0.07
        anchors.bottom: parent.bottom
        Row {
            anchors.centerIn: parent
            spacing: root.width * 0.2
            GrayButton {
                id: yesButton
                text: qsTr("确 定")
                textSize: textSize1
                width: buttonRows.width * 0.3
                height: width * 0.45
                onClicked: {
                    buttonClicked();
                    yesClicked();
                }
            }
            GrayButton {
                id: noButton
                text: qsTr("取 消")
                textSize: textSize1
                width: buttonRows.width * 0.3
                height: width * 0.45
                onClicked: {
                    buttonClicked();
                    noClicked();
                }
            }
        }
    }

    function setMessageText(message){
        dialogMessage.text = message;
        var minWidth = dialogMessage.width + 20;
        root.width = minWidth > root.parent.width / 2 ? minWidth : root.parent.width / 2;
    }
}
