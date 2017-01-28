import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Button {
    text: "Press me"
    property int textSize: choseTextSize.sizeC
    property bool buttonPressed: false
    enabled: !buttonPressed
    style: ButtonStyle {
        panel: Item {
            implicitHeight: control.height
            implicitWidth: control.width
            Image {
                anchors.fill: parent
                source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
                Text {
                    id: buttonText
                    text: control.text
                    anchors.centerIn: parent
                    color: (control.pressed || buttonPressed) ? "darywhite" : "white"
                    font.pointSize: textSize
                    renderType: Text.NativeRendering
                }
            }
        }
    }
}
