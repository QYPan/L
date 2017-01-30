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
            onClicked: {
                if(itemName !== qsTr("新的朋友")){
                    openPersonalDataPage();
                }
            }
            function openPersonalDataPage(){
                stackView.push(Qt.resolvedUrl("PersonalDataPage.qml"));
                var top = stackView.depth - 1;
                stackView.get(top).name = itemName;
                stackView.get(top).language = itemLanguage;
                stackView.get(top).sex = itemSex;
                stackView.get(top).isFriend = true;
            }
        }
    }

    Connections {
        target: signalManager
        onAddLinkman: {
            addLinkman(index, name, language, sex);
        }
        onSetLinkmans: {
            setLinkmans(linkmans);
        }
    }

    Component.onCompleted: {
        signalManager.getLinkmans();
    }

    function setLinkmans(data){
        var linkmans = JSON.parse(data);
        var i;
        for(i = 0; i < linkmans.length; i++){
            addLinkman(i+1, linkmans[i].name, linkmans[i].language, linkmans[i].sex);
        }
    }

    function addLinkman(index, name, language, sex){
        linkmanList.model.insert(index, {"itemName" : name,
                                  "itemLanguage" : language,
                                  "itemSex" : sex});
    }

}
