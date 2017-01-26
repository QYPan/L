import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Item {
    id: root
    width: buttonText.width
    height: buttonText.height

    property int textSize: 15
    property string text
    signal clicked()

    Text {
        id: buttonText
        text: root.text
        font.pointSize: textSize
        color: mouse.pressed ? "white" : "#3399ff"
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            root.clicked();
        }
    }
}

/*
Button {
    text: "Press me"
    width: buttonText.width
    height: buttonText.height
    property int textSize: 15
    property bool buttonPressed: false
    enabled: !buttonPressed
    style: ButtonStyle {
        panel: Item {
            implicitHeight: control.height
            implicitWidth: control.width
            Text {
                id: buttonText
                text: control.text
                anchors.centerIn: parent
                color: (control.pressed || buttonPressed) ? "white" : "#3399ff"
                font.pointSize: textSize
                renderType: Text.NativeRendering
            }
        }
    }
}
*/
