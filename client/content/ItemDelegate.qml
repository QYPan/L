import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: root
    width: parent.width
    //height: parent.height * 0.125
    height: Screen.height * 0.1

    property string newRequest: "0"
    property alias name: nameitem.text
    property alias language: languageitem.text
    property alias dealRequestView: dealRequestPage
    signal clicked

    DealRequestPage {
        id: dealRequestPage
        visible: false
    }

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouse.pressed
    }

    Text {
        id: nameitem
        color: "white"
        width: downLine.x - 5
        font.pixelSize: 55
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 50
        elide: Text.ElideRight
    }

    Rectangle {
        id: downLine
        x: parent.width * 0.55
        width: 1
        height: parent.height * 0.2
        anchors.verticalCenter: parent.verticalCenter
        color: "#424246"
    }

    Image {
        id: messageBox
        width: 50
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: downLine.right
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

    Text {
        id: languageitem
        color: "white"
        font.pixelSize: 50
        visible: languageitem.text != ""
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: downLine.right
        anchors.leftMargin: 50
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
