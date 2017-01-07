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
            fileOperator.closeFile();
            if(friends === ""){ // 好友列表尚未保存在本地
                //fileOperator.addFriend(qmlInterface.clientName, qmlInterface.clientLanguage);
                qmlInterface.qmlSendData(QmlInterface.ADD_ALL, ""); // 发送获取好友列表请求
            }else{
                console.log("in qml: " + friends);
                addFriends(friends);
            }
        }
    }

    function getFriends(friends){
        var fileName = qmlInterface.clientName + "-friends.txt";
        if(fileOperator.openFile(fileName)){
            var splitFriends = friends.split("#");
            var i;
            for(i = 0; i < splitFriends.length; i++){
                var two = splitFriends[i].split(":");
                var name = two[0];
                var language = parseInt(two[1]);
                fileOperator.addFriend(name, language); // 把服务器发送来的好友名单保存在本地文件
            }
            addFriends(friends); // 添加到应用中的好友列表
        }else{
            console.log("打开好友列表文件失败");
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
