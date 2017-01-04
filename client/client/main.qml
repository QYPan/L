import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import "content"

ApplicationWindow {
    objectName: "rootObject"
    visible: true
    width: 500
    height: 690
    title: qsTr("L")

    LoginPage {
        id: loginpage
    }
}
