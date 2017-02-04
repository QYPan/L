import QtQuick 2.0

Rectangle {
    id: root
    color: "black"
    property string pageName: "registerPage"
    property int textSize1: choseTextSize.sizeC
    property int textSize2: choseTextSize.sizeE

    Column {
        id: all
        anchors.centerIn: parent
        spacing: slashImage1.width
        Item {
            id: registerTag
            width: user.width
            height: user.height * 2.5
            Text {
                id: registerTagText
                text: qsTr("欢迎使用 L")
                color: "white"
                font.pointSize: textSize2
                anchors.centerIn: parent
            }
        }
        Item {
            id: user
            width: root.width * 0.7
            height: root.width * 0.1
            Image {
                id: userImage
                source: "../images/userall.png"
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
                font.pointSize: textSize2
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
                font.pointSize: textSize2
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
        /*
        Item {
            id: password2
            width: user.width
            height: user.height
            Image {
                id: passwordImage2
                source: "../images/passwordall.png"
                width: userImage.width
                height: width
                anchors.left: parent.left
            }
            Image {
                id: slashImage3
                source: "../images/slash.png"
                width: slashImage1.width
                height: passwordImage2.height
                anchors.left: passwordImage2.right
            }
            TextInput {
                id: inputPassword2
                font.pointSize: 20
                color: "white"
                echoMode: TextInput.Password
                width: downLine1.width
                maximumLength: 16
                anchors.left: slashImage3.right
                anchors.leftMargin: slashImage3.width
                anchors.verticalCenter: slashImage3.verticalCenter
                onTextChanged: {
                    checkInput();
                }
            }
            Rectangle {
                id: downLine3
                height: 2
                color: "#3399ff"
                anchors.left: slashImage3.right
                anchors.leftMargin: slashImage3.width * 0.8
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
        }
        */
        Item {
            id: language
            width: user.width
            height: user.height
            Item {
                id: languageTagBox
                width: parent.width * 0.24
                height: parent.height
                anchors.left: parent.left
                Text {
                    id: languageTag
                    text: qsTr("语言:")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Item {
                id: cnBox
                width: parent.width * 0.38
                height: parent.height
                anchors.left: languageTagBox.right
                ChoseBox {
                    id: cnChose
                    width: parent.height * 0.5
                    height: width
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        setChose(0);
                    }
                }
                Text {
                    id: cnText
                    text: qsTr("中文")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.left: cnChose.right
                    anchors.leftMargin: cnChose.width * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Item {
                id: enBox
                width: parent.width * 0.38
                height: parent.height
                anchors.left: cnBox.right
                ChoseBox {
                    id: enChose
                    width: parent.height * 0.5
                    height: width
                    isChose: false
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        setChose(1);
                    }
                }
                Text {
                    id: enText
                    text: qsTr("English")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.left: enChose.right
                    anchors.leftMargin: enChose.width * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Item {
            id: sex
            width: user.width
            height: user.height
            Item {
                id: sexTagBox
                width: parent.width * 0.24
                height: parent.height
                anchors.left: parent.left
                Text {
                    id: sexTag
                    text: qsTr("性别:")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Item {
                id: manBox
                width: parent.width * 0.38
                height: parent.height
                anchors.left: sexTagBox.right
                ChoseBox {
                    id: manChose
                    width: parent.height * 0.5
                    height: width
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        setChose(2);
                    }
                }
                Text {
                    id: manText
                    text: qsTr("男")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.left: manChose.right
                    anchors.leftMargin: manChose.width * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Item {
                id: womanBox
                width: parent.width * 0.38
                height: parent.height
                anchors.left: manBox.right
                ChoseBox {
                    id: womanChose
                    width: parent.height * 0.5
                    height: width
                    isChose: false
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        setChose(3);
                    }
                }
                Text {
                    id: womanText
                    text: qsTr("女")
                    color: "white"
                    font.pointSize: textSize1
                    anchors.left: womanChose.right
                    anchors.leftMargin: womanChose.width * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }
        GrayButton {
            id: registerButton
            text: qsTr("确认注册")
            textSize: 15
            width: user.width
            height: width * 0.17
            buttonPressed: true
            onClicked: {
                console.log("register clicked");
                sendRegisterData();
                registerTagText.text = qsTr("正在注册...");
                lockAll(true);
            }
        }
        GrayButton {
            id: backButton
            text: qsTr("返 回")
            textSize: 15
            width: user.width
            height: width * 0.17
            onClicked: {
                console.log("back clicked");
                stackView.pop();
            }
        }
    }

    function sendRegisterData(){
        var data = {};
        var userInfo = {};
        var language, sex;
        if(cnChose.isChose) language = "CN";
        else language = "EN";
        if(manChose.isChose) sex = 0;
        else sex = 1;
        data.mtype = "SYN";
        data.dtype = "REGISTER";
        userInfo.name = inputName.text;
        userInfo.password = inputPassword.text;
        userInfo.language = language;
        userInfo.sex = sex;
        data.userInfo = userInfo;
        var strOut = JSON.stringify(data);
        //console.log(strOut);
        cacheManager.addData(strOut);
    }

    function setChose(value){
        if(value === 0){
            cnChose.isChose = true;
            enChose.isChose = false;
        }else if(value === 1){
            enChose.isChose = true;
            cnChose.isChose = false;
        }else if(value === 2){
            manChose.isChose = true;
            womanChose.isChose = false;
        }else if(value === 3){
            womanChose.isChose = true;
            manChose.isChose = false;
        }
    }

    function lockAll(flag){
        inputName.enabled = !flag;
        inputPassword.enabled = !flag;
        language.enabled = !flag;
        sex.enabled = !flag;
        registerButton.buttonPressed = flag;
        backButton.buttonPressed = flag;
    }

    function handleResult(result){
        if(result === true){
            registerTagText.text = qsTr("注册成功！");
            backButton.buttonPressed = false;
        }else{
            registerTagText.text = qsTr("注册失败！");
            lockAll(false);
        }
    }

    function checkInput(){
        if(inputName.length && inputPassword.length){
            registerButton.buttonPressed = false;
        }else{
            registerButton.buttonPressed = true;
        }
    }
}
