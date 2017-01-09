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
    signal loaded()
    signal setNewFriends(string friends)

    Component {
        id: idPage // 个人信息页面
        Rectangle {
            id: inIdPage
            property string pageName: "idPage"
            property alias titleName: title.text
            property alias canRemove: removeButton.visible
            property alias cname : nameitem.text
            property alias clanguage : languageitem.text
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
                    text: qsTr("详细资料")
                }
            }

            Column {
                id: info
                //anchors.top: topView.bottom
                //anchors.topMargin: topView.height
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.centerIn: parent
                spacing: 50
                Item {
                    width: hLine.width
                    height: nameitem.height + 20
                    Text {
                        id: nameitem
                        color: "white"
                        text: "..."
                        font.pixelSize: 50
                        anchors.centerIn: parent
                    }
                }
                Rectangle {
                    id: hLine
                    width: inIdPage.width * 0.50
                    height: 2
                    color: "#424246"
                }
                Item {
                    width: hLine.width
                    height: languageitem.height + 20
                    Text {
                        id: languageitem
                        color: "white"
                        text: "..."
                        font.pixelSize: 50
                        anchors.centerIn: parent
                    }
                }
            }

            GrayButton {
                id: sendButton
                text: qsTr("发消息");
                width: hLine.width
                height: topView.height
                anchors.top: info.bottom
                anchors.topMargin: height
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                }
            }

            GrayButton {
                id: removeButton
                text: qsTr("删除好友");
                //visible: nameitem.text != qmlInterface.clientName
                width: hLine.width
                height: topView.height
                anchors.top: sendButton.bottom
                anchors.topMargin: height
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                }
            }
        }
    }

    ListView {
        id: friendsListView
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                nameText: qsTr("新的朋友")
                languageText: ""
                newRequestText: "0"
            }
        }
        delegate: ItemDelegate {
            id: client
            name: nameText
            language: languageText
            newRequest: newRequestText == undefined ? "0" : newRequestText
            onClicked:{
                if(name == "新的朋友"){
                    stackView.push(dealRequestView);
                    var newFriends = cacheText.pop(QmlInterface.ADD_ONE);
                    var top = stackView.depth-1;
                    stackView.get(top).dealNewFriends(newFriends);
                    if(dealRequestView.isLoaded == false){
                        stackView.get(top).acceptFriend.connect(pushFriend);
                        dealRequestView.isLoaded = true;
                    }
                    newRequestText = "0";
                }else{
                    stackView.push(idPage);
                    top = stackView.depth-1;
                    var la;
                    if(language == "CN") la = "中文";
                    else if(language == "EN") la = "English";
                    stackView.get(top).cname = name;
                    stackView.get(top).clanguage = la;
                    if(name == qmlInterface.clientName){
                        stackView.get(top).canRemove = false;
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loaded();
    }

    function pullChangeOnFriends(){
        var friends = cacheText.pop(QmlInterface.ADD_ONE_SUCCESSED);
        if(friends != ""){
            var splitFriends = friends.split('\n');
            var i;
            for(i = 0; i < splitFriends.length; i++){
                friendsList.dealType(QmlInterface.ADD_ONE_SUCCESSED, splitFriends[i]);
            }
        }
    }

    function dealType(type, message){
        if(type === QmlInterface.ADD_ONE_SUCCESSED){
            var two = message.split("#");
            pushFriend(two[0], parseInt(two[1]));
        }
    }

    function pushFriend(name, language){
        console.log("accept: " + name + language);
        var index = cacheText.addFriend(name, language);
        addFriend(index+1, name, getLanguage(language));
    }

    function setNoteNumber(val){
        console.log("set in list: " + val);
        if(val){
            friendsListView.model.setProperty(0, "newRequestText", val.toString());
        }
    }

    function addFriends(friends){
        var splitFriends = friends.split("#");
        var i;
        for(i = 0; i < splitFriends.length; i++){
            var two = splitFriends[i].split(":");
            var language = getLanguage(two[1]);
            addFriend(i+1, two[0], language);
        }
    }

    function getLanguage(la){
        var language;
        if(parseInt(la) == QmlInterface.CHINESE){
            language = "CN";
        }else if(parseInt(la) == QmlInterface.ENGLISH){
            language = "EN";
        }
        return language;
    }

    function addFriend(index, name, language){
        friendsListView.model.insert(index, {"nameText" : name, "languageText" : language});
    }
}
