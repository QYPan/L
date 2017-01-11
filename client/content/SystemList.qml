import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    signal cancellation()

    ListView {
        id: friendsListView
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                title: qsTr("关于")
            }
            ListElement {
                title: qsTr("注销")
            }
            ListElement {
                title: qsTr("退出")
            }
        }
        delegate: Item {
            id: subItem
            width: parent.width
            height: Screen.height * 0.08

            Rectangle {
                anchors.fill: parent
                color: "#11ffffff"
                visible: mouse.pressed
            }
            Text {
                id: titleItem
                color: "white"
                font.pixelSize: 55
                text: title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 50
                elide: Text.ElideRight
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
                source: title == "退出" ? "../images/quit.png" : "../images/navigation_next_item.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: {
                    if(title == "注销"){
                        cacheText.saveAll(qmlInterface.clientName);
                        cacheText.setClient(qmlInterface.clientName, qmlInterface.clientPassword);
                        cancellation();
                    }else if(title == "退出"){
                        cacheText.saveAll(qmlInterface.clientName);
                        cacheText.setClient(qmlInterface.clientName, qmlInterface.clientPassword);
                        Qt.quit();
                    }
                }
            }
        }
    }
}
