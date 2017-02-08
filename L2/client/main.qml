import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import "content"

ApplicationWindow {
    id: root
    visible: true
    width: 360
    height: 670
    title: qsTr("L")

    StackView {
        id: stackView // 实现翻页
        anchors.fill: parent
        focus: true
    }

    Component.onCompleted: {
        stackView.push(Qt.resolvedUrl("/content/InitPage.qml"));
    }
}
