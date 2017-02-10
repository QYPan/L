import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    property int newRequest: 0
    property alias name: nameItem.text
    property alias language: languageItem.text
    property int sex

    property int textSize1: 12
    property int textSize2: choseTextSize.sizeB
    property int textSize3: 17
    property int textSize4: 11

    signal clicked()

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
            width: parent.width * 0.6
            height: parent.height * 0.6
            anchors.left: parent.left
            anchors.top: parent.top
            Text {
                id: languageItem
                color: "black"
                font.pointSize: textSize1
                anchors.centerIn: parent
            }
        }
        Image {
            width: parent.width * 0.4
            height: parent.height * 0.4
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            source: {
                if(root.sex === -1){
                     return "../images/man_or_woman_image.png"
                }else if(root.sex === 0){
                     return "../images/man_image.png"
                }else{
                     return "../images/woman_image.png"
                }
            }
            fillMode: Image.PreserveAspectFit
        }
    }

    Text {
        id: nameItem
        color: "white"
        font.pointSize: textSize3
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: headImage.right
        anchors.leftMargin: parent.height * 0.3
        //elide: Text.ElideRight
    }

    Image {
        id: messageBox
        width: Screen.height * 0.07 * 0.4
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
            font.pointSize: textSize4
            anchors.centerIn: parent
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#424246"
    }

    Image {
        id: nextItem
        width: parent.height * 0.5
        height: width
        anchors.right: parent.right
        anchors.rightMargin: Screen.height * 0.07 * 0.3
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/navigation_next_item.png"
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
        onDoubleClicked: {
        }
    }
}
