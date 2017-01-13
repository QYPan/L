import QtQuick 2.0
import QtQuick.Window 2.0
import QmlInterface 1.0

Item {
    id: root


    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Text {
            id: title
            text: qsTr("L");
            font.pointSize: 30
            x: topView.height * 0.3
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }

        Rectangle {
            id: addOption
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.3
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
        anchors.topMargin: topView.height * 0.1
        anchors.right: parent.right
        anchors.rightMargin: topView.height * 0.1
        visible: false;
        color: "#212126"
        z: 30
        GrayButton {
            anchors.fill: parent
            text: qsTr("添加朋友")
            textSize: 17
            onClicked: {
                addButton.visible = false;
                fillScreenMouse.enabled = false;
                stackView.push(Qt.resolvedUrl("SearchClientPage.qml"));
            }
        }
    }

    MessageList {
        id: messageList
        z: 20
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: tabButtons.top
    }

    AddressList {
        id: addressList
        z: 0
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: tabButtons.top
        Component.onCompleted: {
            sayHello.connect(messageList.addMessage);
        }
    }

    Item {
        id: systemList
        z: 0
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: tabButtons.top
    }

    Row {
        id: tabButtons
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        property int chose: 0
        property int up: 20
        property int down: 0
        Rectangle {
            id: firstTab
            width: root.width / 3
            height: Screen.height * 0.08
            color: "#3a3a3b"
            Text {
                id: goMessage
                font.pointSize: 12
                anchors.centerIn: parent
                text: qsTr("消息");
                color: tabButtons.chose == 0 ? "#3399ff" : "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tabButtons.chose = 0;
                    messageList.z = tabButtons.up;
                    addressList.z = tabButtons.down;
                    systemList.z = tabButtons.down;
                }
            }
        }
        Rectangle {
            id: secondTab
            width: root.width / 3
            height: Screen.height * 0.08
            color: "#3a3a3b"
            Text {
                id: goAddress
                font.pointSize: 12
                anchors.centerIn: parent
                text: qsTr("通讯录");
                color: tabButtons.chose == 1 ? "#3399ff" : "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tabButtons.chose = 1;
                    messageList.z = tabButtons.down;
                    addressList.z = tabButtons.up;
                    systemList.z = tabButtons.down;
                }
            }
        }
        Rectangle {
            id: thirdTab
            width: root.width / 3
            height: Screen.height * 0.08
            color: "#3a3a3b"
            Text {
                id: goSystem
                font.pointSize: 12
                anchors.centerIn: parent
                text: qsTr("系统");
                color: tabButtons.chose == 2 ? "#3399ff" : "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tabButtons.chose = 2;
                    messageList.z = tabButtons.down;
                    addressList.z = tabButtons.down;
                    systemList.z = tabButtons.up;
                }
            }
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false
        z: 25
        onClicked: {
            addButton.visible = false;
            enabled = false;
        }
    }

    Component.onCompleted: {
        qmlInterface.qmlSendData(QmlInterface.ADD_ALL, ""); // 发送获取好友列表请求
    }

    Connections { // 所有消息入口，服务器应当等 MainTab 的所有组件加载完再发消息过来
        target: qmlInterface
        onQmlReadData: {
            console.log(type);
            console.log("maintab: " + message);
            dealMessage(type, message);
        }
    }

    function dealMessage(type, message){
        switch(type){
            case QmlInterface.ADD_ALL_SUCCESSED:
                initAddressList(message);
                break;
            case QmlInterface.SEARCH_SUCCESSED:
            case QmlInterface.SEARCH_FAILURE:
                searchRequestAnswer(type, message);
                break;
            case QmlInterface.ADD_ONE: // 收到一个好友请求
                dealAddOne(type, message);
                break;
            case QmlInterface.ADD_ONE_SUCCESSED: // 对方同意请求
                addNewFriend(message);
                break;
        }
    }

    function addNewFriend(message){
        var friend = message.split("#");
        var name = friend[0];
        var slanguage = friend[1];
        var language = parseInt(slanguage);
        messageList.addMessage(name, language, "你好！");
        var index = cacheText.addFriend(name, language);
        addressList.addFriend(index+1, name, addressList.getLanguage(language));
    }

    function dealAddOne(type, message){
        cacheText.push(type, message);
        addressList.setNoteNumber(cacheText.getCount(type));
    }

    function searchRequestAnswer(type, message){
        var top = stackView.depth - 1;
        if(stackView.get(top).pageName === "searchClientPage"){ // 栈顶为查找好友页面
            stackView.get(top).searchResult(type, message); // 交给查找页面处理
        }
    }

    function initAddressList(message){
        cacheText.initAddressList(message);
        addressList.addFriends(cacheText.pullAddressList());
    }
}
