import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "#212126"

    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

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
                    stackView.pop();
                }
            }
        }

        Text {
            id: title
            font.pixelSize: 60
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 30
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: qsTr("添加朋友");
        }
    }

    Row {
        id: user
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Image {
            id: userImage
            source: "../images/userall.png"
            width: 70
            height: width
        }
        Image {
            id: slashImage1
            source: "../images/slash.png"
            width: 50
            height: userImage.height
        }
        InputLine {
            id: inputName
            width: root.width * 0.50
            font.pixelSize: 55
            maximumLength: 15
            focus: false
        }
    }

    GrayButton {
        id: searchButton
        text: qsTr("搜 索");
        width: user.width
        height: 90
        anchors.top: user.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            //qmlInterface.qmlSendData(QmlInterface.ADD_ONE, inputName.text);
        }
    }
}
