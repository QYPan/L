import QtQuick 2.4
import QtQuick.Controls 1.3
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

    TextEdit {
        id: aboutText
        anchors.top: topView.bottom
        anchors.topMargin: topView.height / 5
        anchors.left: parent.left
        anchors.leftMargin: topView.height / 5
        anchors.right: parent.right
        anchors.rightMargin: topView.height / 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: topView.height / 5
        wrapMode: TextEdit.WrapAnywhere
        color: "#c0c0c0"
        font.pointSize: textSize1
        readOnly: true
        text:
            "功能：\n" +
            "- 支持私聊\n" +
            "- 支持发送文本消息\n" +
            "- 支持消息缓存\n" +
            "- 支持消息提醒\n" +
            "- 支持离线消息推送\n" +
            "- 支持断线后自动重连\n" +
            "- 支持中英互译\n\n" +
            "注意：\n" +
            "- 当且仅当双方语言不同才进行翻译，长按消息可获取原文，再次长按消息或长按原文则隐藏原文；需要联网\n" +
            "- 若译文跟原文相同，则翻译失败\n" +
            "- 消息发送与接收接口，消息推送，以及其他一些细节尚未完善，可能会造成服务器或客户端崩溃\n" +
            "- 退出应用后聊天记录会清除\n"
    }
}
