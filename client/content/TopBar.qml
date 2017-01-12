import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0

BorderImage {
    id: root
    border.bottom: 8
    source: "../images/toolbar.png"
    signal back()
    property alias title: title.text
    property alias titleSize: title.font.pixelSize

    Rectangle {
        id: backButton
        width: opacity ? parent.height*0.7 : 0
        anchors.left: parent.left
        anchors.leftMargin: 20
        opacity: stackView.depth > 1 ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        height: parent.height * 0.7
        radius: 4
        color: backmouse.pressed ? "#222" : "transparent"
        Behavior on opacity { NumberAnimation{} }
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
        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
        x: backButton.x + backButton.width + 30
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }
}
