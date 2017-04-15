import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Item {
    id: root

    property int textSize1: 17

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: systemList
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                systemTitle: qsTr("关于")
            }
            ListElement {
                systemTitle: qsTr("翻译")
            }
            ListElement {
                systemTitle: qsTr("设置")
            }
        }
        delegate: Item {
            id: itemDelegate
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
                source: "../images/navigation_next_item.png"
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
                    root.touchSystemItem(nameItem.text, index);
                }
                onDoubleClicked: {
                }
            }
        }
    }

    function touchSystemItem(name, index){
        if(index === 0){
            stackView.push(Qt.resolvedUrl("AboutPage.qml"));
            var top = stackView.depth - 1;
            stackView.get(top).itemName = name;
        }else if(index === 1){
            stackView.push(Qt.resolvedUrl("TranslatePage.qml"));
            top = stackView.depth - 1;
            stackView.get(top).itemName = name;
        }else if(index === 2){
            stackView.push(Qt.resolvedUrl("SettingPage.qml"));
            top = stackView.depth - 1;
            stackView.get(top).itemName = name;
        }
    }

}
