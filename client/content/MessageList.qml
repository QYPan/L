import QtQuick 2.4
import QtQuick.Controls 1.3
import ClientMap 1.0
import FileOperator 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    ListView {
        id: messageListView
        clip: true
        anchors.fill: parent
        model: ListModel {}
        delegate: MsgDelegate {
            id: client
            text: title
            numberText: numberValue
            onClicked:{}
        }
    }

    Connections {
        id: receiveError
        target: qmlInterface
        onDisplayError: {
            messageListView.model.append({"title" : message, "numbervalue" : "0"})
        }
    }

    Component.onCompleted: { // 从本地加载消息列表
    }
}
