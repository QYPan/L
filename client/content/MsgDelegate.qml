import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    //height: parent.height * 0.125
    height: Screen.height * 0.1

    property alias name: nameitem.text
    property alias message: messageItem.text
    property alias numberText: messageNumber.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Item {
        id: personMsg
        width: parent.width * 0.3
        height: parent.height
        Column {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 50
            spacing: 5
            Text {
                id: nameitem
                color: "white"
                width: personMsg.width
                font.pixelSize: 55
                elide: Text.ElideRight
            }
            Text {
                id: messageItem
                width: personMsg.width
                color: "#c0c0c0"
                font.pixelSize: 50
                elide: Text.ElideRight
            }
        }
    }

    Image {
        id: messageBox
        width: nameitem.height
        height: width
        anchors.top: parent.top
        anchors.left: personMsg.right
        anchors.leftMargin: 30
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
