import QtQuick 2.0
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import QtQuick.Window 2.0

Rectangle {
    id: root
    color: "#212126"

    property string pageName: "talkPage"
    property string clientName
    property string language
    property int sex
    property real recordLimitTime: 15.0
    property bool ifRecordOk: true

    property int textSize1: 15
    property int textSize2: 17
    property int textSize3: 20
    property int textSize4: 13

    signal startRecord()
    signal stopRecord()

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: clientName
        titleSize: textSize3
        onBacked: {
            signalManager.stackPop();
        }
    }

    MediaPlayer {
        id: voicePlayer
        autoPlay: false
    }

    ListView {
        id: msgList
        anchors.left: parent.left
        anchors.leftMargin: topView.height * 0.2
        anchors.right: parent.right
        anchors.rightMargin: topView.height * 0.2
        anchors.top: topView.bottom
        anchors.bottom: inputBackground.top
        currentIndex: count - 1
        clip: true
        spacing: topView.height * 0.3
        model: ListModel {}
        /*
        Loader {
            id: voiceLoader
            sourceComponent: {
                if(isVoice) return voicePlayerComponent;
                else return undefined;
            }
        }
        Component {
            id: voicePlayerComponent
            MediaPlayer {
                id: voicePlayer
                autoPlay: false
            }
        }
        */
        delegate: Item {
            id: talkDelegate
            property bool isSelf: itemName == qmlInterface.clientName
            property real xCoor: isSelf ? width - headImage.width : 0.0
            property real edge: topView.height * 0.2
            property real msgLimitLength: width - 2 * headImage.width - 6 * edge
            anchors.left: parent.left
            anchors.right: parent.right
            height: edge + msgBackground.height + originalItem.height
            Rectangle {
                id: headImage
                color: isSelf ? "#808080" : "#c0c0c0"
                width: topView.height * 0.85
                height: width
                x: xCoor
                y: edge
                Item {
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    anchors.left: parent.left
                    anchors.top: parent.top
                    Text {
                        id: languageItem
                        text: itemLanguage
                        color: "black"
                        font.pointSize: textSize1
                        anchors.centerIn: parent
                    }
                }
                Image {
                    width: parent.width * 0.4
                    height: parent.height * 0.4
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    source: itemSex ? "../images/woman_image.png"
                                     : "../images/man_image.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
            Canvas {
                id: triangleLeft
                visible: !isSelf
                x: headImage.width
                y: edge
                width: 2*edge
                height: headImage.height
                contextType: "2d"
                onPaint: {
                    context.lineWidth = 0;
                    context.strokeStyle = "#dddddd";
                    context.fillStyle = "#dddddd";
                    var startX = width / 2;
                    var startY = height / 2;
                    context.beginPath();
                    context.moveTo(startX, startY);
                    context.lineTo(width, height/3);
                    context.lineTo(width, 2*height/3);
                    context.closePath();
                    context.fill();
                    context.stroke();
                }
            }
            Canvas {
                id: triangleRight
                visible: isSelf
                x: parent.width - headImage.width - 2*edge
                y: edge
                width: 2*edge
                height: headImage.height
                contextType: "2d"
                onPaint: {
                    context.lineWidth = 0;
                    context.strokeStyle = "#969696";
                    context.fillStyle = "#969696";
                    var startX = width / 2;
                    var startY = height / 2;
                    context.beginPath();
                    context.moveTo(startX, startY);
                    context.lineTo(0, height/3);
                    context.lineTo(0, 2*height/3);
                    context.closePath();
                    context.fill();
                    context.stroke();
                }
            }
            Image {
                id: busyState
                width: headImage.width * 0.4
                height: width
                source: "../images/busy.png"
                fillMode: Image.PreserveAspectFit
                visible: isItemBusy
                anchors.verticalCenter: headImage.verticalCenter
                x: isSelf ? msgBackground.x - width - edge :
                            msgBackground.x + msgBackground.width + edge
                RotationAnimation {
                    id: anim
                    target: busyState
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite // 无限循环
                    running: true
                }
            }
            /*
            Text {
                id: voiceTime
                color: "white"
                font.pointSize: textSize1
                width: headImage.width * 0.5
                height: width
                visible: (isItemBusy == false) && isVoice  && (isItemError == false)
                anchors.verticalCenter: headImage.verticalCenter
                x: isSelf ? msgBackground.x - width - edge :
                            msgBackground.x + msgBackground.width + edge
            }
            */
            Image {
                id: errorNote
                width: headImage.width * 0.5
                height: width
                source: "../images/error.png"
                fillMode: Image.PreserveAspectFit
                visible: isItemError
                anchors.verticalCenter: headImage.verticalCenter
                x: isSelf ? msgBackground.x - width - edge :
                            msgBackground.x + msgBackground.width + edge
            }
            Rectangle {
                id: msgBackground
                x: isSelf ? parent.width - headImage.width - 2*edge - width : headImage.width + 2*edge
                y: edge
                width: tmsg.width + 2 * edge
                height: tmsg.height + 2 * edge > headImage.height ?
                            tmsg.height + 2 * edge : headImage.height
                color: isSelf ? (textTouch.pressed ? "#808080" : "#969696")
                           :(textTouch.pressed ? "#c0c0c0" : "#dddddd")
                radius: 6
                Text {
                    id: tmsg
                    text: itemTMsg
                    font.pointSize: textSize2
                    anchors.centerIn: parent
                    width: tmsgLength < talkDelegate.msgLimitLength ?
                               tmsgLength : talkDelegate.msgLimitLength
                    wrapMode: Text.Wrap
                }
                MouseArea {
                    id: textTouch
                    anchors.fill: parent
                    onClicked: {
                        if(isVoice){
                            console.log("in talk appendVoice: " + itemVoiceUrl);
                            recordManager.playRecord(itemVoiceUrl);
                            /*
                            if(voiceLoader.item.source !== itemVoiceUrl)
                                voiceLoader.item.source = itemVoiceUrl;
                            if(voiceLoader.item.playbackState === MediaPlayer.StoppedState){
                                voiceLoader.item.play();
                            }else{
                                voiceLoader.item.stop();
                            }
                            */
                        }
                    }
                    onPressAndHold: {
                        talkDelegate.showOriginalMsg();
                    }
                }
            }

            Rectangle {
                id: originalItem
                x: isSelf ? parent.width - headImage.width - 2*edge - width : headImage.width + 2*edge
                y: edge + msgBackground.height
                width: msg.width + 2 * edge
                height: 0
                color: isSelf ? (originalTouch.pressed ? "#808080" : "#969696")
                           :(originalTouch.pressed ? "#c0c0c0" : "#dddddd")
                radius: 6
                Text {
                    id: msg
                    font.pointSize: textSize2
                    anchors.centerIn: parent
                    width: msgLength < talkDelegate.msgLimitLength ?
                               msgLength : talkDelegate.msgLimitLength
                    wrapMode: Text.Wrap
                }
                MouseArea {
                    id: originalTouch
                    anchors.fill: parent
                    property bool isPlaying: false
                    onClicked: {
                        if(isVoice){
                            recordManager.playRecord(oItemVoiceUrl);
                            /*
                            if(voiceLoader.item.source !== oItemVoiceUrl)
                                voiceLoader.item.source = oItemVoiceUrl;
                            if(voiceLoader.item.playbackState === MediaPlayer.StoppedState){
                                voiceLoader.item.play();
                            }else{
                                voiceLoader.item.stop();
                            }
                            */
                        }
                    }
                    onPressAndHold: {
                        talkDelegate.hideOriginalMsg();
                    }
                }
            }

            function showOriginalMsg(){
                if(originalItem.height === 0){
                    msg.text = itemMsg;
                    originalItem.height =  msg.height + 2 * edge > headImage.height ?
                                msg.height + 2 * edge : headImage.height
                }else{
                    hideOriginalMsg();
                }
            }

            function hideOriginalMsg(){
                originalItem.height = 0;
                msg.text = "";
            }
        }
    }

    Item {
        property int h: sayOrWrite.height + downRect.height
        id: inputBackground
        width: parent.width
        height: h > inputMsg.height ? h : inputMsg.height
        anchors.bottom: downRect.top
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#424246"
        }
        Image {
            id: sayOrWrite
            property var talkImageDefault: ["../images/voice_default.png",
                                    "../images/write_default.png",]
            property var talkImagePressed: ["../images/voice_pressed.png",
                                    "../images/write_pressed.png",]
            property int isSay: 0
            width: topView.height * 0.7
            height: width
            anchors.left: parent.left
            anchors.leftMargin: topView.height * 0.2
            anchors.bottom: parent.bottom
            source: talkMouse.pressed ?
                    talkImagePressed[isSay] : talkImageDefault[isSay];
            MouseArea {
                id: talkMouse
                anchors.fill: parent
                onClicked: {
                    sayOrWrite.talkModelClicked();
                }
            }
            function talkModelClicked(){
                if(isSay){
                    isSay = 0;
                    sayButton.visible = false;
                    inputBox.visible = true;
                    sendButton.buttonPressed = false;
                }else{
                    isSay = 1;
                    inputBox.visible = false;
                    sayButton.visible = true;
                    sendButton.buttonPressed = true;
                }
            }
        }
        GrayButton {
            id: sayButton
            visible: false
            height: sayOrWrite.height
            anchors.left: sayOrWrite.right
            anchors.leftMargin: topView.height * 0.15
            anchors.right: sendButton.left
            anchors.rightMargin: topView.height * 0.15
            anchors.bottom: parent.bottom
            text: qsTr("按住说话");
            textSize: textSize1
            property bool isRecordOk
            onPressedChanged: {
                if(pressed){ // 按下
                    console.log("pressed");
                    startRecord();
                }else{ // 松开
                    console.log("release");
                    stopRecord();
                }
            }
        }

        Item {
            id: inputBox
            visible: true
            height: sayOrWrite.height
            anchors.left: sayOrWrite.right
            anchors.leftMargin: topView.height * 0.15
            anchors.right: sendButton.left
            anchors.rightMargin: topView.height * 0.15
            anchors.bottom: parent.bottom
            TextInput {
                id: inputMsg
                color: "white"
                font.pointSize: textSize2
                maximumLength: 200
                wrapMode: TextInput.WrapAnywhere
                anchors.left: parent.left
                anchors.leftMargin: topView.height * 0.15
                anchors.right: parent.right
                anchors.rightMargin: topView.height * 0.15
                anchors.bottom: downLine.top
                onAccepted: {
                    sendButtonClicked();
                }
            }
            Rectangle {
                id: downLine
                height: 2
                color: "#3399ff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
        GrayButton {
            id: sendButton
            width: root.width * 0.16
            height: sayOrWrite.height
            text: qsTr("发送");
            textSize: textSize1
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.2
            anchors.bottom: parent.bottom
            onClicked: {
                sendButtonClicked();
            }
        }
    }

    Loader {
        id: recordBarLoader
        width: parent.width * 0.4
        height: width * 1.7
        anchors.centerIn: parent
        sourceComponent: undefined
    }

    Component {
        id: recordBarComponent
        Rectangle {
            id: remainRecordTimeBox
            visible: true
            z: 10
            color: "#b2242424"
            radius: 4
            Rectangle {
                id: warnningBar
                color: "#c0c0c0"
                width: parent.width * 0.07
                height: parent.height * 0.7
                anchors.bottom: recordWarnText.top
                anchors.bottomMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                NumberAnimation {
                    id: animationBar
                    target: warnningBar
                    property: "height"
                    to: 0
                    duration: root.recordLimitTime * 1000
                    running: true
                }
            }
            Text {
                id: recordWarnText
                color: "#c0c0c0"
                text: qsTr("正在录音...")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: textSize4
            }
        }
    }

    Item {
        id : downRect
        width: parent.width
        height: topView.height * 0.25
        anchors.bottom: parent.bottom
    }

    Text { // 用来测量消息长度
        id: msgDont
        visible: false
        font.pointSize: textSize2
    }

    Connections {
        target: recordManager
        onRecordError: {
            ifRecordOk = false;
            console.log("录音出错");
        }
        onRecordTimeout: {
            console.log("达到录音时长限制");
            sayButton.buttonPressed = true;
            sayButton.buttonPressed = false;
        }
    }

    Connections {
        target: root
        onStartRecord: {
            showRecordBar();
        }
        onStopRecord: {
            hideRecordBar();
        }
    }

    function showRecordBar(){
        var isRecordOk = recordManager.recordReady();
        if(isRecordOk){
            isRecordOk = true;
            recordManager.startRecord();
            recordBarLoader.sourceComponent = recordBarComponent;
        }
    }

    function hideRecordBar(){
        var isRecordOk = recordManager.recordReady();
        if(isRecordOk){
            var voicePath = recordManager.stopRecord();
            recordBarLoader.sourceComponent = undefined;
            sayButtonRelease(voicePath);
        }
    }

    function sayButtonRelease(voicePath){
        var userInfo = {};
        userInfo.name = qmlInterface.clientName;
        userInfo.language = qmlInterface.clientLanguage;
        userInfo.sex = qmlInterface.sex;
        var msg, tmsg;
        var oppUserInfo = {};
        oppUserInfo.name = root.clientName;
        oppUserInfo.language = root.language;
        oppUserInfo.sex = root.sex;
        var userInfoStr = JSON.stringify(oppUserInfo);
        if(ifRecordOk){
            msg = qsTr("语音消息");
            tmsg = qsTr("语音消息");
            appendVoice(userInfo, msg, tmsg, true, false, voicePath, voicePath);
            signalManager.sendMessage(userInfoStr, qsTr("[语音消息]"));
            uploadVoice(root.clientName, voicePath);
        }else{
            msg = qsTr("录音出错");
            tmsg = qsTr("录音出错");
            appendMsg(userInfo, msg, tmsg, false, false);
            signalManager.sendMessage(userInfoStr, qsTr("[录音出错]"));
            ifRecordOk = true;
        }
    }

    function uploadVoice(name, voicePath){
        var udata = {};
        udata.userName = name;
        udata.voicePath = voicePath;
        var udataStr = JSON.stringify(udata);
        voiceMsgManager.addUploadVoiceData(udataStr);
    }

    function sendButtonClicked(){
        if(inputMsg.length){
            var userInfo = {};
            userInfo.name = qmlInterface.clientName;
            userInfo.language = qmlInterface.clientLanguage;
            userInfo.sex = qmlInterface.sex;
            appendMsg(userInfo, inputMsg.text, inputMsg.text, true, false);
            sendMessage(userInfo, root.clientName, inputMsg.text);

            var oppUserInfo = {};
            oppUserInfo.name = root.clientName;
            oppUserInfo.language = root.language;
            oppUserInfo.sex = root.sex;
            var userInfoStr = JSON.stringify(oppUserInfo);
            signalManager.sendMessage(userInfoStr, inputMsg.text);

            inputMsg.text = "";
        }
    }

    function sendMessage(userInfo, oppName, msg){
        var data = {};
        var msgInfo = {};
        data.mtype = "SYN";
        data.dtype = "TRANSPOND";
        data.oppName = oppName;
        msgInfo.type = "TEXT";
        msgInfo.msg = msg;
        data.userInfo = userInfo;
        data.msgInfo = msgInfo;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
    }

    function appendVoice(userInfo, msg, tmsg, isItemBusy, isItemError, oVoiceUrl, voiceUrl){
        msg = qsTr("原声: ") + msg;
        msgDont.text = msg;
        var len = msgDont.width;
        msgDont.text = tmsg;
        var tlen = msgDont.width;
        msgList.model.append({"itemName" : userInfo.name,
                              "itemLanguage" : userInfo.language,
                              "itemMsg" : msg,
                              "itemTMsg" : tmsg,
                              "msgLength" : len,
                              "tmsgLength" : tlen,
                              "isItemBusy" : isItemBusy,
                              "isItemError" : isItemError,
                              "isVoice" : true,
                              "itemVoiceUrl" : voiceUrl,
                              "oItemVoiceUrl" : oVoiceUrl,
                              "itemSex" : userInfo.sex});
    }

    function appendMsg(userInfo, msg, tmsg, isItemBusy, isItemError){
        msg = qsTr("原文: ") + msg;
        msgDont.text = msg;
        var len = msgDont.width;
        msgDont.text = tmsg;
        var tlen = msgDont.width;
        msgList.model.append({"itemName" : userInfo.name,
                              "itemLanguage" : userInfo.language,
                              "itemMsg" : msg,
                              "itemTMsg" : tmsg,
                              "msgLength" : len,
                              "tmsgLength" : tlen,
                              "isItemBusy" : isItemBusy,
                              "isItemError" : isItemError,
                              "isVoice" : false,
                              "itemVoiceUrl" : "",
                              "oItemVoiceUrl" : "",
                              "itemSex" : userInfo.sex});
    }

    function findFirstBusyIndex(){
        var i;
        var currentItem;
        for(i = msgList.count-1; i >= 0; i--){
            currentItem = msgList.model.get(i);
            if(currentItem.itemName === qmlInterface.clientName && (!currentItem.isItemBusy)){
                break; // 找到第一个己方的非发送状态的消息
            }
        }
        var j;
        for(j = i+1; j < msgList.count; j++){
            currentItem = msgList.model.get(j);
            if(currentItem.itemName === qmlInterface.clientName && currentItem.isItemBusy){
                break;
            } // 找到己方的第一个处于正在发送状态的消息
        }
        return j;
    }

    function killBusy(index){
        msgList.model.setProperty(index, "isItemBusy", false);
    }

    function setError(index){
        msgList.model.setProperty(index, "isItemError", true);
    }

}
