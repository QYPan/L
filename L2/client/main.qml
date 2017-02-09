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
        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                if(stackView.depth > 1){
                    var top = stackView.depth - 1;
                    var topPage = stackView.get(top);
                    if(topPage.pageName === "talkPage"){
                        signalManager.stackPop();
                    }else{
                        stackView.pop();
                    }
                    event.accepted = true;
                }
            }
        }
    }

    Component.onCompleted: {
        stackView.push(Qt.resolvedUrl("/content/InitPage.qml"));
    }
}
