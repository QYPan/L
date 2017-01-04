import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

TextField {
    anchors.margins: 20
    textColor: "white"
    font.pixelSize: 80
    style: TextFieldStyle {
        textColor: control.textColor
        background: Item {
            implicitHeight: control.height
            implicitWidth: control.width
            BorderImage {
                source: "../images/textinput.png"
                border.left: 8
                border.right: 8
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
}
