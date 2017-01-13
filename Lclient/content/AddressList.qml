import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0
import "DealRequestLogic.js" as DEAL_REQUEST_LOGIC

Item {
    id: root
    signal sayHello(string name, int language, string message)

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: friendsListView
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                nameText: qsTr("新的朋友")
                languageText: "C/E"
                newRequestText: "0"
            }
        }
        delegate: AddressItemDelegate {
            width: parent.width
            height: Screen.height * 0.07
            name: nameText
            language: languageText
            newRequest: newRequestText
            onClicked: {
                if(name == "新的朋友"){
                    openRequestPage();
                }
            }

            function openRequestPage(){
                stackView.push(DEAL_REQUEST_LOGIC.openDealRequestPage());
                var newFriends = cacheText.pop(QmlInterface.ADD_ONE);
                var top = stackView.depth-1;
                stackView.get(top).dealNewFriends(newFriends);
                if(stackView.get(top).isLoaded == false){
                    stackView.get(top).acceptFriend.connect(pushFriend);
                    stackView.get(top).isLoaded = true;
                }
                newRequestText = "0";
            }
        }
    }

    function pushFriend(name, language){
        console.log("push friend:" + name + language);
        // 在好友列表里添加好友
        var index = cacheText.addFriend(name, language);
        addFriend(index+1, name, getLanguage(language));
        // 回应对方
        var clanguage = qmlInterface.clientLanguage;
        var message = name + "#" + clanguage.toString()
        qmlInterface.qmlSendData(QmlInterface.ADD_ONE_SUCCESSED, message);
        // 向消息列表发信号，在消息列表添加问候消息
        sayHello(name, language, "你好！");
    }

    function setNoteNumber(val){
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
        friendsListView.model.insert(index, {"nameText" : name,
                                             "languageText" : language,
                                             "newRequestText" : "0"});
    }
}
