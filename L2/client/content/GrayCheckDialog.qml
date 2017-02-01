import QtQuick 2.0

Rectangle {
    id: root
    property alias textSize: dialogMessage.font.pointSize
    property int textSize1: 13
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
        width: parent.width
        height: parent.height / 2
        Text {
            id: dialogMessage
            anchors.centerIn: parent
        }
    }
    Item {
        width: parent.width
        height: parent.height / 2
        anchors.top: textBackground.bottom
        Row {
            anchors.centerIn: parent
            spacing: root.width * 0.2
            GrayButton {
                id: yesButton
                text: qsTr("确 定")
                textSize: textSize1
                width: root.width * 0.3
                height: width * 0.4
                onClicked: {
                    buttonClicked();
                    yesClicked();
                }
            }
            GrayButton {
                id: noButton
                text: qsTr("取 消")
                textSize: textSize1
                width: root.width * 0.3
                height: width * 0.4
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
