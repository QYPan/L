import QtQuick 2.0
import QtQuick.Layouts 1.1
import QmlInterface 1.0

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "black"
    //property alias userName: inputName.text
    //property alias dialogVisible: loginDialog.visible
    //property alias dialogMessage: loginDialog.dialogMessage

    Image {
        id: logo
        width: parent.width * 0.2
        height: width
        source: "../images/LLogo.png"
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.3
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column {
        id: uandp // user and password
        anchors.top: logo.bottom
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40
        Row {
            id: user
            spacing: 20
            Image {
                id: userImage
                source: "../images/userall.png"
                width: 70
                height: width
            }
            Image {
                id: slashImage1
                source: "../images/slash.png"
                width: 50
                height: userImage.height
            }
            InputLine {
                id: inputName
                width: root.width * 0.50
                font.pixelSize: 55
                maximumLength: 15
                focus: false
            }
        }
        Row {
            id: password
            spacing: 20
            Image {
                id: passwordImage
                source: "../images/passwordall.png"
                width: userImage.width
                height: width
            }
            Image {
                id: slashImage2
                source: "../images/slash.png"
                width: 50
                height: passwordImage.height
            }
            InputLine {
                id: inputPassword
                width: root.width * 0.50
                echoMode: TextInput.Password
                font.pixelSize: 55
                maximumLength: 15
                focus: false
            }
        }
    }

    Row {
        id: language
        anchors.top: uandp.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        spacing: uandp.width * 0.1
        GrayButton {
            id: chinese
            text: qsTr("中 文");
            width: uandp.width * 0.45
            height: 90
            onClicked: {
                buttonPressed = true;
                english.buttonPressed = false;
                qmlInterface.clientLanguage = QmlInterface.CHINESE;
            }
        }
        GrayButton {
            id: english
            text: qsTr("English");
            width: uandp.width * 0.45
            height: 90
            onClicked: {
                buttonPressed = true;
                chinese.buttonPressed = false;
                qmlInterface.clientLanguage = QmlInterface.ENGLISH;
            }
        }
    }

    GrayButton {
        id: loginButton
        text: qsTr("登 录");
        width: uandp.width
        height: 90
        anchors.top: uandp.bottom
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            tryLogin();
        }
    }

    GrayButton {
        id: registerButton
        text: qsTr("注 册");
        width: uandp.width
        height: 90
        anchors.top: loginButton.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        property bool isInLoginPage: true
        onClicked: {
            if(isInLoginPage){
                goRegister();
            }else{
                tryRegister();
            }
        }
    }

    GrayButton {
        id: back
        text: qsTr("返 回");
        width: uandp.width
        height: 90
        visible: false;
        anchors.top: registerButton.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            goLogin();
        }
    }

    GrayDialog {
        id: messageDialog
        visible: false
        height: parent.height / 5
        anchors.centerIn: parent
        dialogMessage.font.pixelSize: 50
        onButtonClicked: {
            visible = false;
            setUnLockAll(true);
            if(loginButton.visible && loginButton.text === "连接中..."){
                loginButton.text = "登 录";
            }
        }
    }

    Connections {
        target: qmlInterface
        onDisplayError: {
            messageDialog.dialogMessage.text = message;
            var minWidth = messageDialog.dialogMessage.width + 20;
            messageDialog.width = minWidth > root.width / 2 ? minWidth : root.width / 2;
            messageDialog.visible = true;
            setUnLockAll(false);
        }
    }

    function judgeUser(){
        var ok = true;
        if(inputName.length === 0 && inputPassword.length === 0){
            messageDialog.dialogMessage.text = qsTr("请输入用户名和密码");
            ok = false;
        }else if(inputName.length === 0){
            messageDialog.dialogMessage.text = qsTr("请输入用户名");
            ok = false;
        }else if(inputPassword.length === 0){
            messageDialog.dialogMessage.text = qsTr("请输入密码");
            ok = false;
        }
        if(ok === false){
            var minWidth = messageDialog.dialogMessage.width + 20;
            messageDialog.width = minWidth > root.width / 2 ? minWidth : root.width / 2;
            messageDialog.visible = true;
            setUnLockAll(false);
        }
        return ok;
    }

    function setUnLockAll(flag){ // 禁止所有组件活动
        inputName.enabled = flag;
        inputPassword.enabled = flag;
        uandp.enabled = flag;
        loginButton.enabled = flag;
        registerButton.enabled = flag;
        language.enabled = flag;
        back.enabled = flag;
    }

    function tryLogin(){
        if(!judgeUser())
            return;
        qmlInterface.clientName = inputName.text;
        qmlInterface.clientPassword = inputPassword.text;
        qmlInterface.tryConnect(QmlInterface.LOGIN);
        loginButton.text = qsTr("连接中...");
        setUnLockAll(false);
    }

    function tryRegister(){
        if(!judgeUser())
            return;
        qmlInterface.clientName = inputName.text;
        qmlInterface.clientPassword = inputPassword.text;
        qmlInterface.tryConnect(QmlInterface.REGISTER);
        registerButton.text = qsTr("正在注册...");
        setUnLockAll(false);
    }

    function goLogin(){
        registerButton.isInLoginPage = true;
        loginButton.visible = true;
        language.visible = false;
        registerButton.text = qsTr("注 册");
        back.visible = false;
        inputName.focus = false;
        inputPassword.focus = false;
        inputPassword.text = "";
    }

    function goRegister(){
        inputName.focus = false;
        inputPassword.focus = false;
        registerButton.isInLoginPage = false;
        loginButton.visible = false;
        language.visible = true;
        back.visible = true;
        chinese.buttonPressed = true;
        english.buttonPressed = false;
        inputName.text = "";
        inputPassword.text = "";
        registerButton.text = qsTr("确认注册");
    }

}
