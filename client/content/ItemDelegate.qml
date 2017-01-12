import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    height: Screen.height * 0.1

    property string newRequest: "0"
    property alias name: nameitem.text
    property alias language: languageItem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Rectangle {
        id: headImage
        width: root.height * 0.8
        height: width
        color: "#dddddd"
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: languageItem
            color: "black"
            font.pixelSize: 80
            anchors.centerIn: parent
        }
    }

    Text {
        id: nameitem
        color: "white"
        font.pixelSize: 55
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: headImage.right
        anchors.leftMargin: 40
        //elide: Text.ElideRight
    }

    Image {
        id: messageBox
        width: 50
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: nameitem.right
        anchors.leftMargin: 50
        visible: (root.newRequest === "0" // 如果没有新好友请求
                  ? false : true)
        source: "../images/messageBox.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: messageNumber
            color: "black"
            text: root.newRequest
            font.pixelSize: 35
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
        width: 70
        height: 70
        anchors.right: parent.right
        anchors.rightMargin: 20
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
