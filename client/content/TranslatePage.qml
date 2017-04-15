import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

Item {
    id: root
    property string itemName

    property int textSize1: 17
    property int textSize2: 20

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
        anchors.top: topView.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Column {
            id: buttonsColumn
            anchors.centerIn: parent
            spacing: topView.height * 0.7
            GrayButton {
                id: textTranslateButton
                text: qsTr("文本翻译")
                width: root.width * 0.65
                height: width * 0.23
                onClicked: {
                    translateButtonClicked(0, text);
                }
            }
            GrayButton {
                id: toiceTranslateButton
                text: qsTr("语音翻译")
                width: root.width * 0.65
                height: width * 0.23
                onClicked: {
                    translateButtonClicked(1, text);
                }
            }
        }
    }
    function translateButtonClicked(flag, text){
        if(flag == 0){
            stackView.push(Qt.resolvedUrl("TextTranslatePage.qml"));
        }else if(flag == 1){
            stackView.push(Qt.resolvedUrl("voiceTranslatePage.qml"));
        }
        var top = stackView.depth - 1;
        stackView.get(top).itemName = text;
    }
}
