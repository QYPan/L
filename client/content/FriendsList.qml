import QtQuick 2.4
import QtQuick.Controls 1.3
import FileOperator 1.0
import QmlInterface 1.0
import CacheText 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    signal loaded()
    signal setNewFriends(string friends)

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
                    //stackView.push(Qt.resolvedUrl("DealRequestPage.qml"));
                    stackView.push(dealRequestView);
                    var newFriends = cacheText.pull(CacheText.MAIL_LIST_TAB);
                    var top = stackView.depth-1;
                    stackView.get(top).dealNewFriends(newFriends);
                    stackView.get(top).acceptFriend.connect(addFriend);
                    newRequestText = "0";
                    cacheText.readed(CacheText.MAIL_LIST_TAB);
                }
            }
        }
    }

    Component.onCompleted: {
        loaded();
    }

    function dealType(type, message){
        /*
        if(type === QmlInterface.ADD_ONE_SUCCESSED){
            var two = message.split("#");
            addFriend(two[0], getLanguage(two[1]));
        }
        */
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
            addFriend(two[0], language);
        }
    }

    function getLanguage(la){
        var language;
        if(parseInt(la) == QmlInterface.CHINESE){
            language = "中文";
        }else if(parseInt(la) == QmlInterface.ENGLISH){
            language = "English";
        }
        return language;
    }

    function addFriend(name, language){
        friendsListView.model.append({"nameText" : name, "languageText" : language});
    }
}
