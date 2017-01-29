import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.0

Item {
    id: root

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    ListView {
        id: linkmanList
        clip: true
        anchors.fill: parent
        model: ListModel {
            ListElement {
                itemName: qsTr("新的朋友")
                itemLanguage: "C/E"
                itemSex: -1
                itemNewRequest: 0
            }
        }
        delegate: LinkmanItemDelegate {
            width: parent.width
            height: Screen.height * 0.07
            name: itemName
            language: itemLanguage
            sex: itemSex
            newRequest: itemNewRequest
        }
    }

    Connections {
        target: signalManager
        onAddLinkman: {
            addLinkman(name, language, sex);
        }
    }

    Component.onCompleted: {
        requestLinkmans();
    }

    function addLinkman(name, language, sex){
        linkmanList.model.append({"itemName" : name,
                                  "itemLanguage" : language,
                                  "itemSex" : sex});
    }

    function requestLinkmans() {
        var data = {};
        data.mtype = "SYN";
        data.dtype = "LINKMANS";
        data.clientName = qmlInterface.clientName;
        var strOut = JSON.stringify(data);
        qmlInterface.qmlSendData(strOut);
    }
}
