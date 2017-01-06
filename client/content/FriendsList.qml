import QtQuick 2.4
import QtQuick.Controls 1.3
import ClientMap 1.0
import FileOperator 1.0
import QmlInterface 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    FileOperator {
        id: fileOperator
    }
    ListView {
        id: friendsListView
        clip: true
        anchors.fill: parent
        model: ListModel {
        }
        delegate: ItemDelegate {
            id: client
            name: nameText
            language: languageText
            onClicked:{}
        }
    }
    Component.onCompleted: { // 从本地加载好友列表
        var fileName = qmlInterface.clientName + "-friends.txt";
        if(fileOperator.openFile(fileName)){
            var friends = fileOperator.readFriends();
            if(friends === ""){
                fileOperator.addFriend(qmlInterface.clientName, qmlInterface.clientLanguage);
            }
            friends = fileOperator.readFriends();
            console.log("in qml: " + friends);
            addFriends(friends);
            fileOperator.closeFile();
        }
    }

    function addFriends(friends){
        var splitFriends = friends.split("#");
        var i;
        for(i = 0; i < splitFriends.length; i++){
            var two = splitFriends[i].split(":");
            var language;
            if(parseInt(two[1]) == QmlInterface.CHINESE){
                language = "中文";
            }else if(parseInt(two[1]) == QmlInterface.ENGLISH){
                language = "English";
            }
            friendsListView.model.append({"nameText" : two[0], "languageText" : language});
        }
    }
}
