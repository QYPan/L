import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "content"

ApplicationWindow {
    objectName: "rootObject"
    visible: true
    width: 900
    height: 690
    title: qsTr("L")

    LoginPage {
        id: loginpage
        anchors.fill: parent
        onLoginSuccessed: {
            visible = false;
            stackView.push(Qt.resolvedUrl("content/MainTab.qml"));
        }
    }

    StackView {
        id: stackView // 实现翻页
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        /*
        Keys.onReleased: if (event.key === Qt.Key_Back) {
                             //stackView.pop();
                             if(stackView.depth)
                                 event.accepted = true;
                         }
                         */
    }

    function tryToLoadClient(){
    }
}
