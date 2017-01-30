import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "personalDataPage"

    property alias name: nameText.text
    property string language
    property int sex
    property bool isFriend
    property bool isSelf
    /*
    property alias canDelete: deleteButton.visible
    */

    property int textSize1 : 17
    property int textSize2 : 20

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("详细资料");
        titleSize: textSize2
        onBacked: {
            stackView.pop();
        }
    }

    Item {
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Column {
            id: all
            anchors.centerIn: parent
            spacing: topView.height * 0.5
            Column {
                id: userInfo
                Item {
                    id: nameItem
                    width: root.width * 0.7
                    height: topView.height
                    Text {
                        id: nameTextTag
                        font.pointSize: textSize1
                        text: qsTr("ID :");
                        color: "#dddddd"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: nameText
                        font.pointSize: textSize1
                        color: "#c0c0c0"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: "#424246"
                    }
                }
                Item {
                    id: languageItem
                    width: root.width * 0.7
                    height: topView.height
                    Text {
                        id: languageTextTag
                        font.pointSize: textSize1
                        color: "#dddddd"
                        text: qsTr("语言 :");
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: languageText
                        text: root.language == "CN" ? "中文" : "English"
                        font.pointSize: textSize1
                        color: "#c0c0c0"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: "#424246"
                    }
                }
                Item {
                    id: sexItem
                    width: root.width * 0.7
                    height: topView.height
                    Text {
                        id: sexTextTag
                        font.pointSize: textSize1
                        color: "#dddddd"
                        text: qsTr("性别 :");
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: sexText
                        text: sex ? qsTr("女") : qsTr("男")
                        font.pointSize: textSize1
                        color: "#c0c0c0"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: "#424246"
                    }
                }
            }
            GrayButton {
                id: sendOrAddButton
                width: nameItem.width
                height: nameItem.height
                text: root.isFriend ? qsTr("发消息") : qsTr("添加到通讯录")
                onClicked: {
                    if(!root.isFriend){
                        stackView.replace(Qt.resolvedUrl("VerifyPage.qml"));
                        var top = stackView.depth - 1;
                        stackView.get(top).titleName = root.name;
                    }
                }
            }
            GrayButton {
                id: removeButton
                width: nameItem.width
                height: nameItem.height
                text: qsTr("删除联系人");
                visible: ((!root.isFriend) || (root.name == qmlInterface.clientName))
                         ? false : true
            }
        }
    }
}
