import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.0
import QmlInterface 1.0

Item {
    id: root
    width: parent.width
    height: parent.height

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    GrayDialog {
        id: messageDialog
        visible: false
        height: parent.height / 5
        anchors.centerIn: parent
        textSize: 50
        onButtonClicked: {
            visible = false;
        }
    }

    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Text {
            font.pixelSize: 100
            x: 50
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "L"
        }
        Rectangle {
            id: addOption
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.rightMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            color: addMouse.pressed ? "#222" : "transparent"
            Image {
                id: add
                width: parent.width
                height: parent.height
                source: "../images/quit.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: addMouse
                anchors.fill: parent
                onClicked: {
                    if(addButton.visible){
                        addButton.visible = false;
                    }else{
                        addButton.visible = true;
                        fillScreenMouse.enabled = true;
                    }
                }
            }
        }
    }

    Rectangle {
        id: addButton
        width: parent.width * 0.5;
        height: topView.height
        anchors.top: topView.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        visible: false;
        color: "#212126"
        z: 20
        GrayButton {
            anchors.fill: parent
            text: qsTr("添加朋友")
            textSize: 50
            onClicked: {
                addButton.visible = false;
                fillScreenMouse.enabled = false;
                stackView.push(Qt.resolvedUrl("SearchFriendsPage.qml"));
            }
        }
    }

    TabView {
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        style: touchStyle
        tabPosition: Qt.BottomToolBarArea
        Tab {
            title: qsTr("消息")
            MessageList {
                id: messageList
                anchors.fill: parent
            }
        }
        Tab {
            title: qsTr("通讯录")
            FriendsList {
                id: friendsList
                anchors.fill: parent
            }
        }
        Tab {
            title: qsTr("系统")
        }
    }

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item { }
            tab: Item {
                implicitWidth: control.width/control.count
                implicitHeight: Screen.height * 0.07
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "../images/tabs_standard.png":"../images/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: styleData.selected ? "#3399ff" : "white"
                        text: styleData.title
                        font.pixelSize: 45
                    }
                    Rectangle {
                        visible: index > 0
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width:1
                        color: "#3a3a3a"
                    }
                }
            }
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false;
        z: 10
        onClicked: {
            addButton.visible = false;
            enabled = false;
        }
    }

    Connections {
        target: qmlInterface
        onQmlReadData: {
            console.log(type);
            console.log("maintab: " + message);
        }
    }

}
