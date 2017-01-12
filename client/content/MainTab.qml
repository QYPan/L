import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.0
import QmlInterface 1.0
import FileOperator 1.0
import CacheText 1.0
import "TalkPageLogic.js" as TALK_PAGE_LOGIC

Item {
    id: root
    width: parent.width
    height: parent.height
    signal setNoteNumber(int val)
    signal changeOnFriends(int type, string message)
    signal changeMessageList(string name, string language, string message)
    signal cancellation()
    property bool isMailListLoad: false

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    GrayDialog {
        id: messageDialog
        visible: false
        height: parent.height / 5
        anchors.centerIn: parent
        textSize: 50
        onButtonClicked: {
            visible = false;
        }
    }

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: "L"
        titleSize: 100
        Rectangle {
            id: addOption
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.rightMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            color: addMouse.pressed ? "#222" : "transparent"
            Image {
                id: add
                width: parent.width
                height: parent.height
                source: "../images/add.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: addMouse
                anchors.fill: parent
                onClicked: {
                    if(addButton.visible){
                        addButton.visible = false;
                    }else{
                        addButton.visible = true;
                        fillScreenMouse.enabled = true;
                    }
                }
            }
        }
    }

    Rectangle {
        id: addButton
        width: parent.width * 0.5;
        height: topView.height
        anchors.top: topView.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        visible: false;
        color: "#212126"
        z: 20
        GrayButton {
            anchors.fill: parent
            text: qsTr("添加朋友")
            textSize: 50
            onClicked: {
                addButton.visible = false;
                fillScreenMouse.enabled = false;
                stackView.push(Qt.resolvedUrl("SearchFriendsPage.qml"));
            }
        }
    }

    TabView {
        id: tabView
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        style: touchStyle
        tabPosition: Qt.BottomToolBarArea
        Tab {
            id: tab1
            title: qsTr("消息")
            MessageList {
                id: messageList
                anchors.fill: parent
                onLoaded: {
                    root.changeMessageList.connect(messageList.changeMessage);
                }
                onOpenTalkPage: {
                    stackView.replace(TALK_PAGE_LOGIC.openTalkPage(name, language));
                }
            }
        }
        Tab {
            id: tab2
            title: qsTr("通讯录")
            FriendsList {
                id: friendsList
                anchors.fill: parent
                onLoaded: {
                    friendsList.addFriends(cacheText.pullFriendsList());
                    isMailListLoad = true;
                    friendsList.setNoteNumber(cacheText.getCount(QmlInterface.ADD_ONE));
                    friendsList.pullChangeOnFriends();
                    root.setNoteNumber.connect(friendsList.setNoteNumber);
                    root.changeOnFriends.connect(friendsList.dealType);
                }
                onOpenTalkPage: {
                    stackView.replace(TALK_PAGE_LOGIC.openTalkPage(name, language));
                }
            }
        }
        Tab {
            id: tab3
            title: qsTr("系统")
            SystemList {
                id: systemPage
                onCancellation: {
                    root.cancellation();
                }
            }
        }
    }

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item { }
            tab: Item {
                implicitWidth: control.width/control.count
                implicitHeight: Screen.height * 0.07
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "../images/tabs_standard.png":"../images/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: styleData.selected ? "#3399ff" : "white"
                        text: styleData.title
                        font.pixelSize: 45
                    }
                    Rectangle {
                        visible: index > 0
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width:1
                        color: "#3a3a3a"
                    }
                }
            }
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false;
        z: 10
        onClicked: {
            addButton.visible = false;
            enabled = false;
        }
    }

    Connections {
        target: qmlInterface
        onQmlReadData: {
            console.log(type);
            console.log("maintab: " + message);
            deal(type, message);
        }
    }

    Component.onCompleted: { // 加载好友列表
        qmlInterface.qmlSendData(QmlInterface.ADD_ALL, ""); // 发送获取好友列表请求
        /*
        var fileName = qmlInterface.clientName + "-friends.txt";
        if(fileOperator.openFile(fileName)){
            var friends = fileOperator.readFriends();
            fileOperator.closeFile();
            if(friends === ""){ // 好友列表尚未保存在本地
            }
        }
        */
    }

    function deal(type, message){
        var top = stackView.depth-1;
        if(type === QmlInterface.ADD_ONE_SUCCESSED || type === QmlInterface.REMOVE_ONE){
            if(isMailListLoad == false){ // 通讯录界面还没有加载
                cacheText.push(type, message); // 缓存消息
            }else{
                root.changeOnFriends(type, message);
            }
        }else if(type === QmlInterface.SEARCH_SUCCESSED || type === QmlInterface.SEARCH_FAILURE){
            if(stackView.get(top).pageName === "searchFriendsPage"){ // 栈顶为查找好友页面
                stackView.get(top).searchResult(type, message); // 交给查找页面处理
            }
        }else if(type === QmlInterface.ADD_ALL_SUCCESSED){ // 从服务器获取好友列表成功
            cacheText.initFriendsList(message);
        }else if(type === QmlInterface.TRANSPOND_SUCCESSED){ // 好友信息
            transpondMessage(message);
        }else if(type === QmlInterface.ADD_ONE){ // 是一个好友请求
        cacheText.push(type, message);
        root.setNoteNumber(cacheText.getCount(type));
        }
    }

    function transpondMessage(message){
        var friend = message.split("#", 2)
        var toName = friend[0];
        var toMessage = message.substring(friend[0].length+friend[1].length+2);
        var ilanguage = parseInt(friend[1]);
        var language;
        if(ilanguage == QmlInterface.CHINESE){
            language = "中文";
        }else if(ilanguage == QmlInterface.ENGLISH){
            language = "English";
        }
        TALK_PAGE_LOGIC.appendTalkMessage(toName, language, toMessage);
        root.changeMessageList(toName, language, toMessage);
    }

    function setFriends(friends){
        var fileName = qmlInterface.clientName + "-friends.txt";
        if(fileOperator.openFile(fileName)){
            var splitFriends = friends.split("#");
            var i;
            for(i = 0; i < splitFriends.length; i++){
                var two = splitFriends[i].split(":");
                var name = two[0];
                var language = parseInt(two[1]);
                fileOperator.addFriend(name, language); // 把服务器发送来的好友名单保存在本地
            }
        }else{
            console.log("打开好友列表文件失败");
        }
    }

}
