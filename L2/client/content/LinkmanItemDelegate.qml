import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    property int newRequest: 0
    property alias name: nameItem.text
    property alias language: languageItem.text
    property int sex

    property int textSize1: choseTextSize.sizeA
    property int textSize2: choseTextSize.sizeB
    property int textSize3: choseTextSize.sizeC
    property int textSize4: 9

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
        Item {
            width: parent.width * 0.2
            height: parent.height * 0.2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            Text {
                id: sexText
                text: root.sex.toString()
                font.pointSize: textSize4
                color: "black"
                anchors.centerIn: parent
            }
        }
        Text {
            id: languageItem
            color: "black"
            font.pointSize: textSize3
            anchors.centerIn: parent
        }
    }

    Text {
        id: nameItem
        color: "white"
        font.pointSize: textSize2
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
        visible: (root.newRequest === 0 // 如果没有新好友请求
                  ? false : true)
        source: "../images/messageBox.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: messageNumber
            color: "black"
            text: root.newRequest.toString()
            font.pointSize: textSize1
            anchors.centerIn: parent
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
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
