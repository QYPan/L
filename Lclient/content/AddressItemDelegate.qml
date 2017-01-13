import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    property string newRequest: "0"
    property alias name: nameItem.text
    property alias language: languageItem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Rectangle {
        id: headImage
        width: root.height * 0.7
        height: width
        color: "#dddddd"
        anchors.left: parent.left
        anchors.leftMargin: parent.height * 0.3
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: languageItem
            color: "black"
            font.pointSize: 15
            anchors.centerIn: parent
        }
    }

    Text {
        id: nameItem
        color: "white"
        font.pointSize: 13
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: headImage.right
        anchors.leftMargin: parent.height * 0.3
        //elide: Text.ElideRight
    }

    Image {
        id: messageBox
        width: parent.height * 0.35
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: nextItem.left
        anchors.rightMargin: parent.height * 0.3
        visible: (root.newRequest === "0" // 如果没有新好友请求
                  ? false : true)
        source: "../images/messageBox.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: messageNumber
            color: "black"
            text: root.newRequest
            font.pointSize: 10
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

    Image {
        id: nextItem
        width: parent.height * 0.5
        height: width
        anchors.right: parent.right
        anchors.rightMargin: parent.height * 0.3
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/navigation_next_item.png"
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
