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
                itemLanguage: "C|E"
                itemSex: -1
                itemNewRequest: 0
            }
        }
        delegate: LinkmanItemDelegate {
            width: parent.width
            height: Screen.height * 0.08
            name: itemName
            language: itemLanguage
            sex: itemSex
            newRequest: itemNewRequest
            onClicked: {
                if(itemName === qsTr("新的朋友")){
                    openHandleVerifyPage();
                }else{
                    openPersonalDataPage();
                }
            }

            function openHandleVerifyPage(){
                itemNewRequest = 0;
                signalManager.openHandleVerifyPage();
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
            var userInfo = JSON.parse(userInfoStr);
            addLinkman(index, userInfo);
        }
        onSetRequestNumber: {
            setRequestNumber(number);
        }
        onRemoveLinkman: {
            removeLinkman(index);
        }
    }

    Component.onCompleted: {
        setLinkmans(cacheManager.getLinkmans());
        signalManager.getRequestNumber();
    }

    function setLinkmans(data){
        var linkmans = JSON.parse(data);
        var i;
        for(i = 0; i < linkmans.length; i++){
            addLinkman(i+1, linkmans[i]);
        }
    }

    function addLinkman(index, userInfo){
        linkmanList.model.insert(index, {"itemName" : userInfo.name,
                                  "itemLanguage" : userInfo.language,
                                  "itemSex" : userInfo.sex});
    }

    function removeLinkman(index){
        linkmanList.model.remove(index);
    }

    function setRequestNumber(number){
        if(number){
            linkmanList.model.setProperty(0, "itemNewRequest", number);
        }
    }
}
