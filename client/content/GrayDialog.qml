import QtQuick 2.0

Rectangle {
    id: root
    property alias textSize: dialogMessage.font.pixelSize
    signal buttonClicked()
    z: 20
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
        GrayButton {
            id: dialogButton
            text: qsTr("确 定")
            width: parent.width * 0.7
            height: parent.height * 0.55
            anchors.centerIn: parent;
            onClicked: {
                buttonClicked();
            }
        }
    }
    function setMessageText(message){
        dialogMessage.text = message;
        var minWidth = dialogMessage.width + 20;
        root.width = minWidth > root.parent.width / 2 ? minWidth : root.parent.width / 2;
    }
}
