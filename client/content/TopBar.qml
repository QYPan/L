import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

BorderImage {
    id: root
    border.bottom: 8
    source: "../images/toolbar.png"
    property alias title: title.text
    property alias titleSize: title.font.pixelSize
    signal back();

    Rectangle {
        id: backButton
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        width: parent.height * 0.7
        height: width
        radius: 4
        color: backmouse.pressed ? "#222" : "transparent"
        Image {
            anchors.fill: parent
            source: "../images/navigation_previous_item.png"
            fillMode: Image.PreserveAspectFit
        }
        MouseArea {
            id: backmouse
            anchors.fill: parent
            //anchors.margins: -10
            onClicked:{
                root.back();
            }
        }
    }

    Text {
        id: title
        //font.pixelSize: 60
        x: backButton.x + backButton.width + 30
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }
}
