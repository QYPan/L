import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "HandleVerifyLogic.js" as HANDLE_VERIFY_LOGIC
import "TalkPageLogic.js" as TALK_PAGE_LOGIC

Rectangle {
    id: root
    color: "#212126"
    property string pageName: "mainTabPage"

    property int textSize1: 13
    property int textSize2: choseTextSize.sizeD
    property int textSize3: choseTextSize.sizeG
    property int textSize4: 11

    property int newMessageCount: 0
    property int newLinkmanCount: 0

    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Text {
            id: title
            text: qsTr("L");
            font.pointSize: textSize3
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
                id: addImage
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
                        lockAll(true);
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
        anchors.topMargin: topView.height * 0.15
        anchors.right: parent.right
        anchors.rightMargin: topView.height * 0.15
        visible: false;
        color: "#212126"
        z: 30
        GrayButton {
            anchors.fill: parent
            text: qsTr("添加朋友")
            textSize: textSize2
            onClicked: {
                addButton.visible = false;
                lockAll(false);
                stackView.push(Qt.resolvedUrl("SearchClientPage.qml"));
            }
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false
        z: 25
        onClicked: {
            if(addButton.visible){
                addButton.visible = false;
            }
            if(checkDialog.visible){
                checkDialog.visible = false;
            }
            enabled = false;
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
            id: messageTab
            title: qsTr("消息")
            source: "MessageList.qml"
        }
        Tab {
            id: linkmanTab
            title: qsTr("通讯录")
            source: "LinkmanList.qml"
        }
        Tab {
            id: systemTab
            title: qsTr("系统")
            source: "SystemList.qml"
        }
    }

    property var tabImageDefault: ["../images/message_tab_item_default.png",
                            "../images/linkman_tab_item_default.png",
                            "../images/system_tab_item_default.png",]
    property var tabImage: ["../images/message_tab_item.png",
                            "../images/linkman_tab_item.png",
                            "../images/system_tab_item.png",]

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item {}
            tab: Item {
                implicitWidth: control.width / control.count
                implicitHeight: Screen.height * 0.085
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: "../images/tabs_standard.png"
                    Image {
                        id: messageTabImage
                        width: height
                        height: parent.height * 0.5
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.1
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                        source: styleData.selected ? tabImage[styleData.index]
                                                   : tabImageDefault[styleData.index]
                        Image {
                            id: newMsgImage
                            width: Screen.height * 0.07 * 0.4
                            height: width
                            anchors.right: parent.right
                            anchors.rightMargin: - Screen.height * 0.07 * 0.2
                            anchors.top: parent.top
                            //anchors.topMargin: Screen.height * 0.07 * 0.2
                            visible: {
                                if(styleData.index === 0){
                                    return root.newMessageCount === 0 ? false : true;
                                }else if(styleData.index === 1){
                                    return root.newLinkmanCount === 0 ? false : true;
                                }else{
                                    return false;
                                }
                            }
                            source: "../images/messageBox.png"
                            fillMode: Image.PreserveAspectFit
                            Text {
                                id: messageNumber
                                color: "black"
                                text: {
                                    if(styleData.index === 0){
                                        return root.newMessageCount.toString();
                                    }else if(styleData.index === 1){
                                        return root.newLinkmanCount.toString();
                                    }else{
                                        return false;
                                    }
                                }
                                font.pointSize: textSize4
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Item {
                        width: parent.width
                        height: parent.height * 0.4
                        anchors.top: messageTabImage.bottom
                        Text {
                            anchors.centerIn: parent
                            color: styleData.selected ? "#3399ff" : "#c0c0c0"
                            text: styleData.title
                            font.pointSize: textSize1
                        }
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

    Connections { // 所有消息入口
        target: qmlInterface
        onQmlReadData: {
            dealResult(data);
        }
        onQmlConnectSuccessed: {
            reLogin();
        }
    }

    Connections {
        target: cacheManager
        onSendData: {
            qmlInterface.qmlSendData(data);
        }
        onFinishTranslate: {
            var tudata = JSON.parse(udata);
            TALK_PAGE_LOGIC.appendMessage(tudata.userInfo, tudata.msg, tudata.tmsg);
        }
    }

    Connections {
        target: signalManager
        onOpenHandleVerifyPage: {
            stackView.push(HANDLE_VERIFY_LOGIC.openHandleVerifyPage());
            root.newLinkmanCount = 0;
        }
        onGetRequestNumber: {
            signalManager.setRequestNumber(HANDLE_VERIFY_LOGIC.getNewRequestsCount());
        }
        onOpenTalkPage: {
            handleOpenTalkPageSignal(userInfoStr, isPush);
        }
        onUpdateNewMessageCount: {
            root.newMessageCount = count;
        }
    }

    Connections {
        target: voiceMsgManager
        onFinishUpload: {
            console.log("oppName: " + oppName);
            console.log("ftpPath: " + ftpPath);
            handleFtpVoice(oppName, ftpPath);
        }
        onFinishDownload: {
            var uVoiceInfo = JSON.parse(uVoicePath);
            console.log("name: " + uVoiceInfo.userInfo.name);
            console.log("language: " + uVoiceInfo.userInfo.language);
            console.log("sex: " + uVoiceInfo.userInfo.sex);
            console.log("voicePath: " + uVoiceInfo.voicePath);
            TALK_PAGE_LOGIC.appendVoice(uVoiceInfo.userInfo, uVoiceInfo.voicePath);
        }
    }

    GrayCheckDialog {
        id: checkDialog
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: textHeight + Screen.height * 0.07 * 1.4
        visible: false
        z: 30
        onButtonClicked: {
            lockAll(false);
            visible = false;
        }
        onYesClicked: {
            Qt.quit();
        }
        onNoClicked: {
        }
    }

    Component.onCompleted: {
        requestLinkmans();
        HANDLE_VERIFY_LOGIC.initVerifyPage(); // 初始化接受好友请求页面
    }

    function handleFtpVoice(oppName, ftpPath){
        var data = {};
        var msgInfo = {};
        var userInfo = {};
        userInfo.name = qmlInterface.clientName;
        userInfo.language = qmlInterface.clientLanguage;
        userInfo.sex = qmlInterface.sex;
        data.mtype = "SYN";
        data.dtype = "TRANSPOND";
        data.oppName = oppName;
        msgInfo.type = "VOICE";
        msgInfo.msg = ftpPath;
        data.userInfo = userInfo;
        data.msgInfo = msgInfo;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
    }

    function reLogin(){
        var data = {};
        var userInfo = {};
        data.mtype = "SYN";
        data.dtype = "RELOGIN";
        userInfo.name = qmlInterface.clientName;
        userInfo.password = qmlInterface.clientPassword;
        data.userInfo = userInfo;
        var strOut = JSON.stringify(data);
        qmlInterface.qmlSendData(strOut);
    }

    function handleOpenTalkPageSignal(userInfoStr, isPush){
        var userInfo = JSON.parse(userInfoStr);
        if(isPush){
            stackView.push(TALK_PAGE_LOGIC.openTalkPage(userInfo));
        }else{
            stackView.replace(TALK_PAGE_LOGIC.openTalkPage(userInfo));
        }
    }

    function dealResult(data){
        var newData = JSON.parse(data);
        if(newData.mtype === "ACK"){
            if(newData.dtype === "RELOGIN"){
                cacheManager.hadReceiveACK(false); // 重发消息
            }else{
                cacheManager.hadReceiveACK(true); // 发下一条消息
            }
            if(newData.dtype === "LINKMANS"){ // 获取联系人
                handleLinkmansAck(newData.linkmans);
            }else if(newData.dtype === "SEARCH_CLIENT"){ // 查找结果
                handleSearchClientAck(data);
            }else if(newData.dtype === "VERIFY"){ // 服务器回应好友请求发送成功
                handleVerifyAck();
            }else if(newData.dtype === "ACCEPT_VERIFY"){ // 服务器回应好友同意请求
                handleAcceptVerifySynOrAck(data);
            }else if(newData.dtype === "REMOVE_LINKMAN"){ // 服务器回应删除好友请求
                handleRemoveLinkmanAck(data);
            }else if(newData.dtype === "TRANSPOND"){ // 服务器回应转发请求
                handleTranspondAck(data);
            }
        }else if(newData.mtype === "SYN"){
            sendAck(); // 应答服务器
            if(newData.dtype === "VERIFY"){ // 有人向自己发出好友邀请
                handleVerifySyn(newData.userInfo, newData.verifyMsg);
            }else if(newData.dtype === "ACCEPT_VERIFY"){ // 对方已同意好友请求
                handleAcceptVerifySynOrAck(data);
            }else if(newData.dtype === "TRANSPOND"){
                handleTranspondSyn(data);
            }
        }
    }

    function handleTranspondSyn(data){
        var udataStr;
        var udata = {};
        var msgInfo = {};
        var newData = JSON.parse(data);
        udata.userInfo = newData.userInfo;
        msgInfo = newData.msgInfo;
        udata.msg = msgInfo.msg;
        if(msgInfo.type === "TEXT"){ // 文本消息
            if(udata.userInfo.language === qmlInterface.clientLanguage){
                TALK_PAGE_LOGIC.appendMessage(udata.userInfo, udata.msg, udata.msg);
            }else{
                udataStr = JSON.stringify(udata);
                cacheManager.addTranslateData(udataStr);
            }
        }else if(msgInfo.type === "VOICE"){ // 语音消息
            udataStr = JSON.stringify(udata);
            voiceMsgManager.addDownloadVoiceData(udataStr);
        }
    }

    function handleTranspondAck(data){
        signalManager.handleTranspondAck(data);
        var newData = JSON.parse(data);
        var name = newData.oppName;
        if(newData.isFriend){
            TALK_PAGE_LOGIC.killBusy(name);
        }else{
            TALK_PAGE_LOGIC.setError(name);
        }
    }

    function handleRemoveLinkmanAck(data){
        var newData = JSON.parse(data);
        var name = newData.name;
        var index = cacheManager.removeLinkman(name);
        if(index !== -1){
            signalManager.removeLinkman(name, index+1);
            TALK_PAGE_LOGIC.removePage(name);
            var top = stackView.depth - 1;
            if(stackView.get(top).pageName === "personalDataPage" &&
               stackView.get(top).name === name){
                stackView.pop();
            }
        }
    }

    function handleAcceptVerifySynOrAck(data){
        var newData = JSON.parse(data);
        var userInfo = newData.userInfo;
        if(!newData.isFriend){ // 尚未添加进好友列表
            if(!cacheManager.isLinkman(userInfo.name)){
                var index = cacheManager.addLinkman(userInfo.name, userInfo.language, userInfo.sex);
                var userInfoStr = JSON.stringify(userInfo);
                signalManager.addLinkman(index+1, userInfoStr);
            }
            if(newData.mtype === "ACK"){
                HANDLE_VERIFY_LOGIC.setButtonText(userInfo.name, qsTr("已接受"));
                //sayHello(userInfo.name);
            }
            userInfoStr = JSON.stringify(userInfo);
            TALK_PAGE_LOGIC.appendMessage(userInfo, "你好！(这是打招呼内容)",
                                          qsTr("你好！(这是打招呼内容)"));
        }else{
            if(newData.mtype === "ACK"){
                HANDLE_VERIFY_LOGIC.setButtonText(userInfo.name, qsTr("已接受"));
            }
        }
    }

    function handleVerifySyn(userInfo, msg){
        HANDLE_VERIFY_LOGIC.addVerifyItem(userInfo, msg);
        var top = stackView.depth - 1;
        if(stackView.get(top).pageName !== "handleVerifyPage"){
            signalManager.setRequestNumber(HANDLE_VERIFY_LOGIC.getNewRequestsCount());
            root.newLinkmanCount = HANDLE_VERIFY_LOGIC.getNewRequestsCount();
        }
    }

    function sendAck(){
        var data = {};
        data.mtype = "ACK";
        data.clientName = qmlInterface.clientName;
        var strOut = JSON.stringify(data);
        //cacheManager.addData(strOut);
        qmlInterface.qmlSendData(strOut);
    }

    function handleVerifyAck(){
        signalManager.verifyAck();
    }

    function handleSearchClientAck(data){
        signalManager.searchResult(data);
    }

    function handleLinkmansAck(linkmans){
        var i;
        for(i = 0; i < linkmans.length; i++){
            cacheManager.addLinkman(linkmans[i].name, linkmans[i].language, linkmans[i].sex);
            //signalManager.addLinkman(i+1, linkmans[i].name, linkmans[i].language, linkmans[i].sex);
            //console.log(linkmans[i].name+" "+linkmans[i].language+" "+linkmans[i].sex);
        }
        sendReady();
    }

    function sendReady(){
        var data = {};
        data.mtype = "SYN";
        data.dtype = "READY";
        data.clientName = qmlInterface.clientName;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
    }

    function requestLinkmans() {
        var data = {};
        data.mtype = "SYN";
        data.dtype = "LINKMANS";
        data.clientName = qmlInterface.clientName;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
    }

    function lockAll(flag){
        fillScreenMouse.enabled = flag;
    }

    function quit(){
        if(checkDialog.visible){
            checkDialog.visible = false;
            lockAll(false);
        }else{
            checkDialog.setMessageText(qsTr("退出系统后将不保存任何聊天记录"));
            checkDialog.visible = true;
            lockAll(true);
        }
    }
}
