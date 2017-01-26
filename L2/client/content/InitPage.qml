import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: root
    color: "black"

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
                font.pointSize: 20
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
                font.pointSize: 20
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
        textSize: 15
        width: uandp.width
        height: width * 0.17
        buttonPressed: true
        anchors.top: uandp.bottom
        anchors.topMargin: height * 0.7
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            console.log("login clicked");
        }
    }

    WordButton {
        id: registerButton
        text: qsTr("新用户注册")
        textSize: 13
        anchors.right: parent.right
        anchors.rightMargin: loginButton.height * 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: loginButton.height * 0.3
        onClicked: {
            stackView.push(Qt.resolvedUrl("RegisterPage.qml"));
        }
    }

    Connections {
        target: qmlInterface
        onQmlReadData: {
            var newData = JSON.parse(data);
            if(newData.mtype === "ACK"){
                if(newData.dtype === "REGISTER"){
                    var top = stackView.depth - 1;
                    if(stackView.get(top).pageName === "registerPage"){
                        stackView.get(top).handleResult(newData.result);
                    }
                }
            }
        }
    }

    function checkInput(){
        if(inputName.length && inputPassword.length){
            loginButton.buttonPressed = false;
        }else{
            loginButton.buttonPressed = true;
        }
    }
}
