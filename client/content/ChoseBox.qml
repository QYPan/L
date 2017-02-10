import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    border.color: "#3399ff"
    border.width: 2
    property bool isChose: true
    signal clicked()
    Rectangle {
        id: smallChose
        width: parent.width * 0.5
        height: parent.height * 0.5
        visible: isChose
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            //smallChose.visible = true;
            root.clicked();
        }
    }
}
