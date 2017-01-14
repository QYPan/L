import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    id: root
    property string newMessage: "0"
    property real margins: Screen.height * 0.07
    property alias name: nameItem.text
    property alias language: languageItem.text
    property alias message: messageItem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Rectangle {
        id: headImage
        width: parent.height * 0.7
        height: width
        color: "#dddddd"
        anchors.left: parent.left
        anchors.leftMargin: margins * 0.3
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: languageItem
            text: languageText
            color: "black"
            font.pointSize: 15
            anchors.centerIn: parent
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        height: 1
        color: "#424246"
    }

    Text {
        id: nameItem
        text: nameText
        color: "white"
        font.pointSize: 15
        anchors.top: headImage.top
        anchors.left: headImage.right
        anchors.leftMargin: margins * 0.3
    }

    Text {
        id: messageItem
        text: messageText
        width: parent.width * 0.5
        color: "#c0c0c0"
        font.pointSize: 13
        anchors.bottom: headImage.bottom
        anchors.left: headImage.right
        anchors.leftMargin: margins * 0.3
        elide: Text.ElideRight
    }

    Image {
        id: messageBox
        width: margins * 0.35
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: nextItem.left
        anchors.rightMargin: parent.height * 0.3
        visible: (root.newMessage === "0" // 如果没有新好友消息
                  ? false : true)
        source: "../images/messageBox.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: messageNumber
            color: "black"
            text: root.newMessage
            font.pointSize: 10
            anchors.centerIn: parent
        }
    }

    Image {
        id: nextItem
        width: margins * 0.5
        height: width
        anchors.right: parent.right
        anchors.rightMargin: margins * 0.3
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/navigation_next_item.png"
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            root.clicked();
        }
    }

}
