import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Item {
    id: root
    property string itemName

    property int textSize1: 17
    property int textSize2: 20

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: itemName
        titleSize: textSize2
        onBacked: {
            stackView.pop();
        }
    }

    ListView {
        id: systemList
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        model: ListModel {
            ListElement {
                systemTitle: qsTr("退出")
            }
        }
        delegate: Item {
            width: parent.width
            height: Screen.height * 0.08
            property real edge: Screen.height * 0.07 * 0.3

            Rectangle {
                anchors.fill: parent
                color: "#11ffffff"
                visible: mouse.pressed
            }
            Text {
                id: nameItem
                color: "white"
                text: systemTitle
                font.pointSize: textSize1
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: edge
                //elide: Text.ElideRight
            }
            Image {
                id: nextItem
                width: parent.height * 0.5
                height: width
                anchors.right: parent.right
                anchors.rightMargin: Screen.height * 0.07 * 0.3
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/quit.png"
                fillMode: Image.PreserveAspectFit
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#424246"
            }
            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: {
                    root.touchSystemItem();
                }
                onDoubleClicked: {
                }
            }
        }
    }

    GrayCheckDialog {
        id: checkDialog
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: textHeight + Screen.height * 0.07 * 1.4
        visible: false
        z: 30
        onButtonClicked: {
            lockAll(false);
            visible = false;
        }
        onYesClicked: {
            Qt.quit();
        }
        onNoClicked: {
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false
        z: 25
        onClicked: {
            checkDialog.visible = false;
            lockAll(false);
        }
    }

    function touchSystemItem(){
        checkDialog.setMessageText(qsTr("退出系统后将不保存任何聊天记录"));
        checkDialog.visible = true;
        lockAll(true);
    }

    function lockAll(flag){
        fillScreenMouse.enabled = flag;
    }
}
