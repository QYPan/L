import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QmlInterface 1.0

Rectangle {
    id: root
    color: "black"
    //property int textSize1: choseTextSize.sizeB
    property int textSize2: choseTextSize.sizeC
    property int textSize3: choseTextSize.sizeE

    Image {
        id: logo
        width: parent.width * 0.17
        height: width
        source: "../images/LLogo.png"
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.25
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column {
        id: uandp // user and password
        anchors.top: logo.bottom
        anchors.topMargin: userImage.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: slashImage1.width
        Item {
            id: user
            width: root.width * 0.7
            height: root.width * 0.1
            Image {
                id: userImage
                source: "../images/userall.png"
                fillMode: Image.PreserveAspectFit
                width: parent.height
                height: width
                anchors.left: parent.left
            }
            Image {
                id: slashImage1
                source: "../images/slash.png"
                width: userImage.width * 0.33
                height: userImage.height
                anchors.left: userImage.right
            }
            TextInput {
                id: inputName
                font.pointSize: textSize3
                color: "white"
                width: downLine1.width
                maximumLength: 16
                anchors.left: slashImage1.right
                anchors.leftMargin: slashImage1.width
                anchors.verticalCenter: slashImage1.verticalCenter
                onTextChanged: {
                    checkInput();
                }
            }
            Rectangle {
                id: downLine1
                height: 2
                color: "#3399ff"
                anchors.left: slashImage1.right
                anchors.leftMargin: slashImage1.width * 0.8
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
        Item {
            id: password
            width: user.width
            height: user.height
            Image {
                id: passwordImage
                source: "../images/passwordall.png"
                fillMode: Image.PreserveAspectFit
                width: userImage.width
                height: width
                anchors.left: parent.left
            }
            Image {
                id: slashImage2
                source: "../images/slash.png"
                width: slashImage1.width
                height: passwordImage.height
                anchors.left: passwordImage.right
            }
            TextInput {
                id: inputPassword
                font.pointSize: textSize3
                color: "white"
                echoMode: TextInput.Password
                width: downLine1.width
                maximumLength: 16
                anchors.left: slashImage2.right
                anchors.leftMargin: slashImage2.width
                anchors.verticalCenter: slashImage2.verticalCenter
                onTextChanged: {
                    checkInput();
                }
            }
            Rectangle {
                id: downLine2
                height: 2
                color: "#3399ff"
                anchors.left: slashImage2.right
                anchors.leftMargin: slashImage2.width * 0.8
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
    }

    GrayButton {
        id: loginButton
        text: qsTr("登 录")
        width: uandp.width
        height: width * 0.17
        buttonPressed: true
        anchors.top: uandp.bottom
        anchors.topMargin: height * 0.7
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            //console.log("login clicked");
            tryLogin();
        }
    }

    WordButton {
        id: registerButton
        text: qsTr("新用户注册")
        textSize: textSize2
        anchors.right: parent.right
        anchors.rightMargin: loginButton.height * 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: loginButton.height * 0.3
        onClicked: {
            stackView.push(Qt.resolvedUrl("RegisterPage.qml"));
        }
    }

    GrayDialog {
        id: noticeDialog
        width: parent.width * 0.5
        height: parent.height * 0.2
        //textSize: textSize2
        anchors.centerIn: parent
        visible: false
        onButtonClicked: {
            visible = false;
            lockAll(false);
            loginButton.text = qsTr("登 录");
        }
    }

    Component.onCompleted: {
        cacheManager.sendData.connect(qmlInterface.qmlSendData);
        qmlInterface.qmlReadData.connect(dealResult);
        qmlInterface.qmlConnectSuccessed.connect(cacheManager.hadReceiveACK);
    }

    /*
    Connections {
        id: connectToCache
        target: cacheManager
        onSendData: {
            qmlInterface.qmlSendData(data);
        }
    }

    Connections {
        id: connectToInterface
        target: qmlInterface
        onQmlReadData: {
            console.log("before logined !!!!!!!!!!!!!!!!!!!!");
            dealResult(data);
        }
    }
    */

    //Component.onDestruction: console.log("destruction, current depth - " + stackView.depth);

    function dealResult(data){
        cacheManager.hadReceiveACK(true);
        var newData = JSON.parse(data);
        if(newData.mtype === "ACK"){
            if(newData.dtype === "REGISTER"){
                var top = stackView.depth - 1;
                if(stackView.get(top).pageName === "registerPage"){
                    stackView.get(top).handleResult(newData.result);
                }
            }else if(newData.dtype === "LOGIN"){
                if(newData.result === true && newData.logined === false){
                    saveUserInfo(newData.userInfo);
                    cacheManager.sendData.disconnect(qmlInterface.qmlSendData);
                    qmlInterface.qmlReadData.disconnect(dealResult);
                    qmlInterface.qmlConnectSuccessed.disconnect(cacheManager.hadReceiveACK);
                    stackView.replace(Qt.resolvedUrl("MainTab.qml"));
                }else if(newData.result === true){
                    noticeDialog.setMessageText(qsTr("无法重复登录！"));
                    noticeDialog.visible = true;
                    lockAll(true);
                }else{
                    noticeDialog.setMessageText(qsTr("用户名或密码不正确！"));
                    noticeDialog.visible = true;
                    lockAll(true);
                }
            }
        }
    }

    function saveUserInfo(userInfo){
        /*
        console.log(userInfo.name);
        console.log(userInfo.password);
        console.log(userInfo.language);
        console.log(userInfo.sex);
        */
        qmlInterface.clientName = userInfo.name;
        recordManager.userName = userInfo.name;
        qmlInterface.clientPassword = userInfo.password;
        qmlInterface.clientLanguage = userInfo.language;
        qmlInterface.sex = userInfo.sex;
        recordManager.initRecord();
    }

    function tryLogin(){
        var data = {};
        var userInfo = {};
        data.mtype = "SYN";
        data.dtype = "LOGIN";
        userInfo.name = inputName.text;
        userInfo.password = inputPassword.text;
        data.userInfo = userInfo;
        var strOut = JSON.stringify(data);
        cacheManager.addData(strOut);
        lockAll(true);
        loginButton.text = qsTr("正在登录...");
    }

    function lockAll(flag){
        inputName.enabled = !flag;
        inputPassword.enabled = !flag;
        registerButton.enabled = !flag;
        loginButton.buttonPressed = flag;
    }

    function checkInput(){
        if(inputName.length && inputPassword.length){
            loginButton.buttonPressed = false;
        }else{
            loginButton.buttonPressed = true;
        }
    }
}
