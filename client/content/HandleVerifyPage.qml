import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "handleVerifyPage"
    property int newRequests: 0

    property int textSize1: 13
    property int textSize2: 15
    property int textSize3: 20
    property int textSize4: 17

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("新的朋友");
        titleSize: textSize3
        onBacked: {
            stackView.pop();
        }
    }

    ListView {
        id: verifyView
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        model: ListModel {}
        delegate: Item {
            id: itemDelegate
            width: parent.width
            height: Screen.height * 0.1
            property int sex: itemSex

            Rectangle {
                id: headImage
                width: parent.height * 0.7
                height: width
                color: "#dddddd"
                anchors.left: parent.left
                anchors.leftMargin: topView.height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                Item {
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    anchors.left: parent.left
                    anchors.top: parent.top
                    Text {
                        id: languageItem
                        text: itemLanguage
                        color: "black"
                        font.pointSize: textSize4
                        anchors.centerIn: parent
                    }
                }
                Image {
                    width: parent.width * 0.4
                    height: parent.height * 0.4
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    source: itemDelegate.sex ? "../images/woman_image.png"
                                     : "../images/man_image.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: "#424246"
            }

            Text {
                id: nameItem
                text: itemName
                color: "white"
                font.pointSize: textSize4
                anchors.top: headImage.top
                anchors.left: headImage.right
                anchors.leftMargin: topView.height * 0.3
            }

            Text {
                id: messageItem
                text: itemMessage
                color: "#c0c0c0"
                font.pointSize: textSize2
                anchors.bottom: headImage.bottom
                anchors.left: headImage.right
                anchors.leftMargin: topView.height * 0.3
            }

            GrayButton {
                id: acceptButton
                text: itemButtonText
                textSize: textSize1
                width: topView.height * 1.4
                height: parent.height * 0.4
                anchors.right: parent.right
                anchors.rightMargin: topView.height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    acceptVerify();
                }
            }

            function acceptVerify(){
                itemButtonText = qsTr("处理中");
                //acceptButton.text = qsTr("处理中");
                acceptButton.buttonPressed = true;
                //signalManager.acceptVerify(nameItem.text, languageItem.text, itemDelegate.sex);
                sendAcceptVerify(nameItem.text, languageItem.text, itemDelegate.sex);
            }
            function sendAcceptVerify(name, language, sex){
                var data = {};
                var userInfo = {};
                var oppUserInfo = {};
                data.mtype = "SYN";
                data.dtype = "ACCEPT_VERIFY";
                userInfo.name = qmlInterface.clientName;
                userInfo.language = qmlInterface.clientLanguage;
                userInfo.sex = qmlInterface.sex;
                oppUserInfo.name = name;
                oppUserInfo.language = language;
                oppUserInfo.sex = sex;
                data.userInfo = userInfo;
                data.oppUserInfo = oppUserInfo;
                var strOut = JSON.stringify(data);
                cacheManager.addData(strOut);
            }
        }
    }

    function findIndexByName(name){
        var i;
        for(i = 0; i < verifyView.count; i++){
            var currentItem = verifyView.model.get(i);
            if(currentItem.itemName === name){
                return i;
            }
        }
        return -1;
    }

    function setButtonText(index, text){
        verifyView.model.setProperty(index, "itemButtonText", text);
    }

    function addVerifyItem(userInfo, message){
        verifyView.model.insert(0, {"itemName" : userInfo.name,
                                            "itemLanguage" : userInfo.language,
                                            "itemSex" : userInfo.sex,
                                            "itemButtonText" : qsTr("接受"),
                                            "itemMessage" : message});
        newRequests += 1;
    }
}
