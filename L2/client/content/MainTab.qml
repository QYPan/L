import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QmlInterface 1.0

Rectangle {
    id: root
    color: "#212126"
    property int textSize1: choseTextSize.sizeC
    property int textSize2: choseTextSize.sizeD
    property int textSize3: choseTextSize.sizeG

    BorderImage {
        id: topView
        border.bottom: 8
        source: "../images/toolbar.png"
        width: parent.width
        height: Screen.height * 0.07

        Text {
            id: title
            text: qsTr("L");
            font.pointSize: textSize3
            x: topView.height * 0.3
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }

        Rectangle {
            id: addOption
            width: parent.height * 0.6
            height: width
            anchors.right: parent.right
            anchors.rightMargin: topView.height * 0.3
            anchors.verticalCenter: parent.verticalCenter
            color: addMouse.pressed ? "#222" : "transparent"
            Image {
                id: addImage
                width: parent.width
                height: parent.height
                source: "../images/add.png"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: addMouse
                anchors.fill: parent
                onClicked: {
                    if(addButton.visible){
                        addButton.visible = false;
                    }else{
                        addButton.visible = true;
                        fillScreenMouse.enabled = true;
                    }
                }
            }
        }
    }

    Rectangle {
        id: addButton
        width: parent.width * 0.5;
        height: topView.height
        anchors.top: topView.bottom
        anchors.topMargin: topView.height * 0.15
        anchors.right: parent.right
        anchors.rightMargin: topView.height * 0.15
        visible: false;
        color: "#212126"
        z: 30
        GrayButton {
            anchors.fill: parent
            text: qsTr("添加朋友")
            textSize: textSize2
            onClicked: {
                addButton.visible = false;
                fillScreenMouse.enabled = false;
                //stackView.push(Qt.resolvedUrl("SearchClientPage.qml"));
            }
        }
    }

    MouseArea {
        id: fillScreenMouse
        anchors.fill: parent
        enabled: false
        z: 25
        onClicked: {
            addButton.visible = false;
            enabled = false;
        }
    }

    TabView {
        id: tabView
        anchors.top: topView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        style: touchStyle
        tabPosition: Qt.BottomToolBarArea
        Tab {
            id: messageTab
            title: qsTr("消息")
        }
        Tab {
            id: linkmanTab
            title: qsTr("联系人")
            source: "LinkmanList.qml"
        }
        Tab {
            id: systemTab
            title: qsTr("系统")
        }
    }

    Component {
        id: touchStyle
        TabViewStyle {
            tabsAlignment: Qt.AlignVCenter
            tabOverlap: 0
            frame: Item {}
            tab: Item {
                implicitWidth: control.width/control.count
                implicitHeight: Screen.height * 0.07
                BorderImage {
                    anchors.fill: parent
                    border.bottom: 8
                    border.top: 8
                    source: styleData.selected ? "../images/tabs_standard.png":"../images/tabs_standard.png"
                    Text {
                        anchors.centerIn: parent
                        color: styleData.selected ? "#3399ff" : "white"
                        text: styleData.title
                        font.pointSize: textSize1
                    }
                    Rectangle {
                        visible: index > 0
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        width:1
                        color: "#3a3a3a"
                    }
                }
            }
        }
    }

    Connections { // 所有消息入口
        target: qmlInterface
        onQmlReadData: {
            dealResult(data);
        }
    }

    function dealResult(data){
        var newData = JSON.parse(data);
        if(newData.mtype === "ACK"){
            if(newData.dtype === "LINKMANS"){
                handleLinkmans(newData.linkmans);
            }
        }
    }

    function handleLinkmans(linkmans){
        var i;
        for(i = 0; i < linkmans.length; i++){
            signalManager.addLinkman(linkmans[i].name, linkmans[i].language, linkmans[i].sex);
            //console.log(linkmans[i].name+" "+linkmans[i].language+" "+linkmans[i].sex);
        }
    }
}
