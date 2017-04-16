import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

Item {
    id: root
    property string pageName: "textTranslatePage"
    property string itemName

    property int textSize1: 17
    property int textSize2: 20
    property int textSize3: 15
    property int textSize4: 13

    Rectangle {
        color: "#212126"
        anchors.fill: parent
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
        id: allBlock
        anchors.top: topView.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            id: originBackground
            color: "transparent"
            anchors.left: parent.left
            anchors.leftMargin: topView.height * 0.2
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.2
            anchors.top: parent.top
            anchors.topMargin: topView.height * 0.2
            height: allBlock.height * 0.25
            border.width: 3
            border.color: "#3399ff"
            TextArea {
                id: textEdit
                anchors.fill: parent
                anchors.margins: 3
                font.pointSize: textSize1
                focus: true
                wrapMode: TextEdit.Wrap
                style: TextAreaStyle {
                    backgroundColor: "#212126"
                    textColor: "white"
                    selectionColor: "steelblue"
                    selectedTextColor: "#eee"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textEdit.focus = true;
                        holdPress.visible = false;
                    }
                    onPressAndHold: {
                        holdPress.y = mouseY;
                        holdPress.visible = true;
                    }
                }
            }
        }
        Rectangle {
            id: holdPress
            width: parent.width * 0.5
            height: topView.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            visible: false
            GrayButton {
                id: selectAllButton
                width: parent.width / 3
                height: parent.height
                text: qsTr("全选");
                textSize: textSize4;
                anchors.left: parent.left
                onClicked: {
                    holdPressClicked(0);
                }
            }
            GrayButton {
                id: copyButton
                width: parent.width / 3
                height: parent.height
                text: qsTr("复制");
                textSize: textSize4;
                anchors.left: selectAllButton.right
                onClicked: {
                    holdPressClicked(1);
                }
            }
            GrayButton {
                id: pasteButton
                width: parent.width / 3
                height: parent.height
                text: qsTr("粘贴");
                textSize: textSize4;
                anchors.left: copyButton.right
                onClicked: {
                    holdPressClicked(2);
                }
            }
        }
        GrayButton {
            id: translateButton
            anchors.top: originBackground.bottom
            anchors.topMargin: topView.height * 0.2
            anchors.left: originBackground.left
            width: originBackground.width * 0.3
            height: topView.height * 0.7
            textSize: textSize3
            text: qsTr("翻译")
            property string perText: ""
            onClicked: {
                if(textEdit.text != "" && textEdit.text != perText){
                    goTranslate(textEdit.text);
                    perText = textEdit.text;
                }
            }
        }
        Image {
            id: busyState
            width: translateButton.height * 0.5
            height: width
            source: "../images/busy.png"
            fillMode: Image.PreserveAspectFit
            visible: false
            anchors.verticalCenter: translateButton.verticalCenter
            anchors.left: translateButton.right
            anchors.leftMargin: topView.height * 0.2
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
        Rectangle {
            id: translateBackground
            color: "transparent"
            anchors.left: parent.left
            anchors.leftMargin: topView.height * 0.2
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.2
            anchors.top: translateButton.bottom
            anchors.topMargin: topView.height * 0.2
            height: allBlock.height * 0.25
            border.width: 3
            border.color: "#c0c0c0"
            TextArea {
                id: translateText
                anchors.fill: parent
                anchors.margins: 3
                font.pointSize: textSize1
                focus: true
                wrapMode: TextEdit.Wrap
                readOnly: true
                text: ""
                style: TextAreaStyle {
                    backgroundColor: "#212126"
                    textColor: "#c0c0c0"
                    selectionColor: "steelblue"
                    selectedTextColor: "#eee"
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
        text: qsTr("有道词典")
        color: "#c0c0c0"
        font.pointSize: textSize3
    }

    function holdPressClicked(flag){
        if(flag == 0){
            textEdit.selectAll();
        }else if(flag == 1){
            textEdit.copy();
            holdPress.visible = false;
        }else if(flag == 2){
            textEdit.paste();
            holdPress.visible = false;
        }
    }

    function goTranslate(text){
        isBusyTranslate(true);
        var udata = {};
        var userInfo = {};
        userInfo.name = qmlInterface.clientName;
        userInfo.language = qmlInterface.clientLanguage;
        userInfo.sex = qmlInterface.sex;
        udata.userInfo = userInfo;
        udata.msg = text;
        var udataStr = JSON.stringify(udata);
        cacheManager.addTranslateData(udataStr);
    }

    function setTranslateText(text){
        isBusyTranslate(false);
        translateText.text = text;
    }

    function isBusyTranslate(flag){
        if(flag){
            translateButton.buttonPressed = true;
            busyState.visible = true;
        }else{
            translateButton.buttonPressed = false;
            busyState.visible = false;
        }
    }
}
