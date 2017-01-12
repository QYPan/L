import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    //height: parent.height * 0.125
    height: Screen.height * 0.1

    property alias name: nameitem.text
    property alias message: messageItem.text
    property alias language: languageItem.text
    property alias numberText: messageNumber.text
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

    Item {
        id: personMsg
        width: parent.width * 0.5
        height: headImage.height
        anchors.left: headImage.right
        anchors.leftMargin: 40
        Text {
            id: nameitem
            anchors.top: parent.top
            anchors.left: parent.left
            color: "white"
            width: personMsg.width
            font.pixelSize: 55
            elide: Text.ElideRight
        }
        Text {
            id: messageItem
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "#c0c0c0"
            font.pixelSize: 50
            elide: Text.ElideRight
        }
    }

    Image {
        id: messageBox
        width: headItem.width
        height: width
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: headImage.right
        anchors.rightMargin: 20
        visible: (messageNumber.text === "0" || // 如果没有缓存消息或者这是一个网络链接出错消息
                  messageNumber.text === "-") ? false : true
        source: "../images/messageBox.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: messageNumber
            color: "black"
            text: modelData
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
