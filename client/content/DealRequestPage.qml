import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QmlInterface 1.0

Rectangle {
    id: root
    color: "#212126"

    property alias titleName: title.text
    signal acceptFriend(string name, string language)

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
            text: qsTr("新的朋友")
        }
    }

    ListView {
        id: newFriendsListView
        clip: true
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        model: ListModel {}
        delegate: Rectangle {
            id: rectItem
            width: parent.width
            height: Screen.height * 0.1
            color: "transparent"
            Item {
                id: personMsg
                width: parent.width * 0.3
                height: Screen.height * 0.1
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 50
                    spacing: 5
                    Text {
                        id: nameitem
                        text: fname
                        color: "white"
                        width: personMsg.width
                        font.pixelSize: 55
                        elide: Text.ElideRight
                    }
                    Text {
                        id: languageItem
                        text: flanguage
                        width: personMsg.width
                        color: "white"
                        font.pixelSize: 55
                        elide: Text.ElideRight
                    }
                }
            }
            Rectangle {
                id: downLine
                width: 2
                height: parent.height * 0.6
                anchors.left: personMsg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                color: "#424246"
            }
            Text {
                id: messageItem
                text: fmessage
                color: "white"
                font.pixelSize: 55
                anchors.left: downLine.right
                anchors.leftMargin: 20
                anchors.right: judgeButtonRow.left
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 15
                height: 1
                color: "#424246"
            }
            GrayButton {
                id: answerButton
                width: rectItem.width * 0.16 * 2
                height: rectItem.height * 0.69
                //anchors.right: parent.right
                //anchors.rightMargin: rectItem.height * 0.25
                //anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: judgeButtonRow
                buttonPressed: true
                enabled: false
                visible: false
            }
            Row {
                id: judgeButtonRow
                anchors.right: parent.right
                anchors.rightMargin: rectItem.height * 0.25
                anchors.verticalCenter: parent.verticalCenter
                spacing: rectItem.height * 0.25
                GrayButton {
                    id: acceptButton
                    text: qsTr("接受");
                    width: rectItem.width * 0.16
                    height: rectItem.height * 0.69
                    onClicked: {
                        answerButton.text = "已接受";
                        answerButton.visible = true;
                        judgeButtonRow.visible = false;
                        var clanguage = qmlInterface.clientLanguage;
                        qmlInterface.qmlSendData(QmlInterface.ADD_ONE_SUCCESSED, fname+"#"+clanguage.toString());
                        root.acceptFriend(fname, flanguage);
                    }
                }
                GrayButton {
                    id: refuseButton
                    text: qsTr("拒绝");
                    width: rectItem.width * 0.16
                    height: rectItem.height * 0.69
                    onClicked: {
                        answerButton.text = "已拒绝";
                        answerButton.visible = true;
                        judgeButtonRow.visible = false;
                        var clanguage = qmlInterface.clientLanguage;
                        qmlInterface.qmlSendData(QmlInterface.ADD_ONE_FAILURE, fname+"#"+clanguage.toString());
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        //newFriendsListView.model.append({"fname" : "fuck", "flanguage" : "English"});
    }

    function dealNewFriends(message){
        if(message !== ""){
            var splitFriends = message.split('\n');
            var i;
            for(i = 0; i < splitFriends.length; i++){
                var friend = splitFriends[i].split("#");
                newFriends(friend);
            }
        }
    }

    function newFriends(friend){
        var name = friend[0];
        var str_language = friend[1];
        var checkMessage = friend[2];
        var language;
        console.log("try add new friend");
        console.log("name: " + name);
        console.log("language: " + str_language);
        console.log("checkMessage: " + checkMessage);
        if(parseInt(str_language) == QmlInterface.CHINESE){
            language = "中文";
        }else if(parseInt(str_language) == QmlInterface.ENGLISH){
            language = "English";
        }
        addNoteItem(name, language, checkMessage);
    }

    function addNoteItem(name, language, checkMessage){
        newFriendsListView.model.insert(0, {"fname" : name,
                                            "flanguage" : language,
                                            "fmessage": checkMessage});
    }
}
