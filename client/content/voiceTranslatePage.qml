import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

Item {
    id: root
    property string pageName: "voiceTranslatePage"
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
    }
}
