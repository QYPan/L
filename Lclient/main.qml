import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "content"

ApplicationWindow {
    objectName: "rootObject"
    visible: true
    width: 406
    height: 650
    title: qsTr("L")
    id: root

    Loader {
        id: loadLoginPage
        anchors.fill: parent
        source: "/content/LoginPage.qml"
    }

    Connections {
        target: loadLoginPage.item
        onLoginSuccessed: {
            loadLoginPage.source = "";
            stackView.push(Qt.resolvedUrl("/content/MainTab.qml"));
        }
    }

    StackView {
        id: stackView // 实现翻页
        anchors.fill: parent
        focus: true
    }

}
