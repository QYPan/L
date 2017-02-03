import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Item {
    id: root

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: messageList
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: Item {
            id: itemDelegate
            width: parent.width
            height: Screen.height * 0.1
            property int sex: itemSex
            property real edge: Screen.height * 0.07 * 0.3

            Rectangle {
                id: headImage
                width: parent.height * 0.7
                height: width
                color: "#dddddd"
                anchors.left: parent.left
                anchors.leftMargin: edge
                anchors.verticalCenter: parent.verticalCenter
                Item {
                    width: parent.width * 0.2
                    height: parent.height * 0.2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    Text {
                        id: sexText
                        text: itemDelegate.sex.toString()
                        font.pointSize: 13
                        color: "black"
                        anchors.centerIn: parent
                    }
                }
                Text {
                    id: languageItem
                    text: itemLanguage
                    color: "black"
                    font.pointSize: 20
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 15
                height: 1
                color: "#424246"
            }

            Text {
                id: nameItem
                text: itemName
                color: "white"
                font.pointSize: 15
                anchors.top: headImage.top
                anchors.left: headImage.right
                anchors.leftMargin: edge
            }

            Text {
                id: messageItem
                text: itemMessage
                color: "#c0c0c0"
                font.pointSize: 13
                anchors.bottom: headImage.bottom
                anchors.left: headImage.right
                anchors.leftMargin: edge
            }
        }
    }

    function findIndexByName(name){
        var i;
        for(i = 0; i < messageList.count; i++){
            var currentItem = messageList.model.get(i);
            if(currentItem.itemName === name){
                return i;
            }
        }
        return -1;
    }

    function addMessageItem(userInfo, message){
        messageList.model.insert(0, {"itemName" : userInfo.name,
                                            "itemLanguage" : userInfo.language,
                                            "itemSex" : userInfo.sex,
                                            "itemMessage" : message});
    }
    Component.onCompleted: {
        var u = {};
        u.name = "abe";
        u.language = "CN";
        u.sex = 1;
        addMessageItem(u, "jofefjeofj");
    }
}
