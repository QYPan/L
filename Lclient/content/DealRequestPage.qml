import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "dealRequestPage"
    property bool isLoaded: false
    signal acceptFriend(string name, int language)

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: qsTr("新的朋友");
        titleSize: 20
        onBack: {
            stackView.pop();
        }
    }

    ListView {
        id: newFriendsListView
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        model: ListModel {}
        delegate: Item {
            width: parent.width
            height: Screen.height * 0.1

            Rectangle {
                id: headImage
                width: parent.height * 0.7
                height: width
                color: "#dddddd"
                anchors.left: parent.left
                anchors.leftMargin: topView.height * 0.3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: languageItem
                    text: languageText
                    color: "black"
                    font.pointSize: 15
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
                text: nameText
                color: "white"
                font.pointSize: 15
                anchors.top: headImage.top
                anchors.left: headImage.right
                anchors.leftMargin: topView.height * 0.3
            }

            Text {
                id: messageItem
                text: messageText
                color: "#c0c0c0"
                font.pointSize: 13
                anchors.bottom: headImage.bottom
                anchors.left: headImage.right
                anchors.leftMargin: topView.height * 0.3
            }

            GrayButton {
                id: choseButton
                textSize: 12
                width: refuseButton.width * 2 + topView.height * 0.2
                height: refuseButton.height
                anchors.right: parent.right
                anchors.rightMargin: topView.height * 0.2
                anchors.verticalCenter: parent.verticalCenter
                buttonPressed: true
                visible: false;
            }

            GrayButton {
                id: refuseButton
                text: qsTr("拒绝")
                textSize: 12
                width: topView.height * 0.9
                height: parent.height * 0.4
                anchors.right: parent.right
                anchors.rightMargin: topView.height * 0.2
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    hasChose(false);
                }
            }

            GrayButton {
                id: acceptButton
                text: qsTr("接受")
                textSize: 12
                width: topView.height * 0.9
                height: parent.height * 0.4
                anchors.right: refuseButton.left
                anchors.rightMargin: topView.height * 0.2
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    hasChose(true);
                }
            }

            function hasChose(flag){
                choseButton.visible = true;
                choseButton.enabled = false;
                acceptButton.visible = false;
                refuseButton.visible = false;
                if(flag){
                    choseButton.text = qsTr("已接受");
                    var ok = cacheText.isExists(nameText);
                    if(ok === false){
                        var language = intLanuage(languageText);
                        console.log("accept: " + nameText + language);
                        root.acceptFriend(nameText, language);
                    }
                }else{
                    choseButton.text = qsTr("已拒绝");
                }
            }
        }
    }


    function intLanuage(slanguage){
        if(slanguage == "CN"){
            return QmlInterface.CHINESE;
        }else if(slanguage == "EN"){
            return QmlInterface.ENGLISH;
        }
    }

    function dealNewFriends(message){
        if(message !== ""){
            var splitFriends = message.split('\n');
            var i;
            for(i = 0; i < splitFriends.length; i++){
                var friend = splitFriends[i].split("#");
                dealFriend(friend);
            }
        }
    }

    function dealFriend(friend){
        var name = friend[0];
        var slanguage = friend[1];
        var checkMessage = friend[2];
        var ilanguage;
        var language;
        ilanguage = parseInt(slanguage);
        if(ilanguage == QmlInterface.CHINESE){
            language = "CN";
        }else if(ilanguage == QmlInterface.ENGLISH){
            language = "EN";
        }
        appendItem(name, language, checkMessage);
    }

    function appendItem(name, language, message){
        newFriendsListView.model.insert(0, {"nameText" : name,
                                            "languageText" : language,
                                            "messageText" : message});
    }

}
