import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

Item {
    id: root
    property string pageName: "voiceTranslatePage"
    property string itemName
    property string translateVoicePath: ""
    property string translateLanguage: "EN"
    property real recordLimitTime: 15.0
    property bool ifRecordOk: true

    signal startRecord()
    signal stopRecord()

    property int textSize1: 17
    property int textSize2: 20
    property int textSize3: 15
    property int textSize4: 13

    Rectangle {
        color: "#212126"
        anchors.fill: parent
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

    TopBar {
        id: topView
        width: parent.width
        height: Screen.height * 0.07
        title: itemName
        titleSize: textSize2
        onBacked: {
            stackView.pop();
        }
    }

    Item {
        anchors.top: topView.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Loader {
            id: recordBarLoader
            z: 20
            width: parent.width * 0.4
            height: width * 1.7
            anchors.bottom: speechButton.top
            anchors.bottomMargin: topView.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: undefined
        }
        Image {
            id: busyState
            width: voiceTranslateLogo.height * 0.3
            height: width
            source: "../images/busy.png"
            fillMode: Image.PreserveAspectFit
            visible: false
            anchors.centerIn: voiceTranslateLogo
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
        Image {
            id: voiceTranslateLogo
            source: "../images/round_default.png"
            fillMode: Image.PreserveAspectFit
            width: topView.height * 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: topView.height * 3.5
            visible: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    recordManager.playRecord(root.translateVoicePath);
                }
                onPressed: {
                    voiceTranslateLogo.source = "../images/round_clicked.png";
                }
                onReleased: {
                    voiceTranslateLogo.source = "../images/round_default.png";
                }
            }
        }
        GrayButton {
            id: speechButton
            anchors.top: voiceTranslateLogo.bottom
            anchors.topMargin: topView.height * 2
            anchors.horizontalCenter: parent.horizontalCenter
            width: topView.width * 0.3
            height: topView.height * 0.8
            textSize: textSize3
            text: qsTr("按住说话")
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
        GrayButton {
            id: languageTurnButton
            anchors.top: speechButton.bottom
            anchors.topMargin: topView.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            width: topView.width * 0.3
            height: topView.height * 0.8
            textSize: textSize3
            text: qsTr("英 -> 中")
            property bool flag: true
            onClicked: {
                if(flag == true){
                    text = qsTr("中 -> 英");
                    root.translateLanguage = "CN"
                    flag = false;
                }else{
                    text = qsTr("英 -> 中");
                    root.translateLanguage = "EN"
                    flag = true;
                }
            }
        }
    }

    Text {
        id: flagAPI
        anchors.bottom: parent.bottom
        anchors.bottomMargin: topView.height * 0.2
        anchors.left: parent.left
        anchors.leftMargin: topView.height * 0.2
        text: qsTr("百度语音 & 有道词典")
        color: "#c0c0c0"
        font.pointSize: textSize3
    }

    Connections {
        target: recordManager
        onRecordError: {
            ifRecordOk = false;
            console.log("录音出错");
        }
        onRecordTimeout: {
            console.log("达到录音时长限制");
            speechButton.buttonPressed = true;
            speechButton.buttonPressed = false;
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
            recordManager.startRecord();
            isRecordOk = true;
            voiceTranslateLogo.visible = false;
            languageTurnButton.buttonPressed = true;
            recordBarLoader.sourceComponent = recordBarComponent;
        }
    }

    function hideRecordBar(){
        var isRecordOk = recordManager.recordReady();
        if(isRecordOk){
            var voicePath = recordManager.stopRecord();
            recordBarLoader.sourceComponent = undefined;
            speechButtonRelease(voicePath);
        }
    }

    function speechButtonRelease(voicePath){
        isBusyTranslate(true);
        var uVoicePath = {};
        var userInfo = {};
        userInfo.name = qmlInterface.clientName;
        userInfo.language = root.translateLanguage;
        userInfo.sex = qmlInterface.sex;
        uVoicePath.userInfo = userInfo;
        uVoicePath.voicePath = voicePath;
        var udataStr = JSON.stringify(uVoicePath);
        voiceMsgManager.addTranslateVoiceData(udataStr);
    }

    function setTranslateVoice(voicePath){
        isBusyTranslate(false);
        voiceTranslateLogo.visible = true;
        root.translateVoicePath = voicePath;
    }

    function isBusyTranslate(flag){
        if(flag){
            speechButton.buttonPressed = true;
            languageTurnButton.buttonPressed = true;
            busyState.visible = true;
        }else{
            speechButton.buttonPressed = false;
            languageTurnButton.buttonPressed = false;
            busyState.visible = false;
        }
    }
}
