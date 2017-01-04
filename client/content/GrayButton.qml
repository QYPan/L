import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Button {
    text: "Press me"
    property int textSize: 50
    property bool buttonPressed: false
    //property alias buttonTextColor: buttonText.color
    style: ButtonStyle {
        panel: Item {
            implicitHeight: control.height
            implicitWidth: control.width
            Image {
                anchors.fill: parent
                //antialiasing: true
                //anchors.margins: control.pressed ? -4 : 0
                source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
                Text {
                    id: buttonText
                    text: control.text
                    anchors.centerIn: parent
                    color: (control.pressed || buttonPressed) ? "darywhite" : "white"
                    font.pixelSize: textSize
                    renderType: Text.NativeRendering
                }
            }
        }
    }
}
