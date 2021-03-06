var request;
var guserInfo;
var gmsg;
var component = null;
var msgPages = new Array;

function openTalkPage(userInfo){
    var page = findTalkPage(userInfo.name);
    if(page === undefined){
        return createTalkPage(userInfo);
    }else{
        return page;
    }
}

function appendVoice(userInfo, voicePath, tvoicePath){
    var userInfoStr = JSON.stringify(userInfo);
    signalManager.receiveMessage(userInfoStr, qsTr("[语音消息]"));
    var page = openTalkPage(userInfo);
    if(page !== undefined){
        var msg = qsTr("语音消息");
        var tmsg = qsTr("语音消息");
        page.appendVoice(userInfo, msg, tmsg, false, false, voicePath, tvoicePath);
    }
}

function appendMessage(userInfo, msg, tmsg){
    var userInfoStr = JSON.stringify(userInfo);
    signalManager.receiveMessage(userInfoStr, tmsg);
    var page = openTalkPage(userInfo);
    if(page !== undefined){
        page.appendMsg(userInfo, msg, tmsg, false, false);
    }
}

function removePage(name){
    var i;
    for(i = 0; i < msgPages.length; i++){
        if(msgPages[i].clientName === name){
            break;
        }
    }
    if(i < msgPages.length && msgPages[i] !== undefined){
        msgPages[i].destroy();
        msgPages.splice(i, 1);
    }
    //console.log("pages lenght: " + msgPages.length);
}

function findTalkPage(name){
    var i;
    for(i = 0; i < msgPages.length; i++){
        if(msgPages[i].clientName === name)
            return msgPages[i];
    }
}

function setError(name){
    var page = findTalkPage(name);
    if(page !== undefined){
        var index = page.findFirstBusyIndex();
        if(index !== -1){
            page.killBusy(index);
            page.setError(index);
        }
    }
}

function killBusy(name){
    var page = findTalkPage(name);
    if(page !== undefined){
        var index = page.findFirstBusyIndex();
        if(index !== -1){
            page.killBusy(index);
        }
    }
}

function createTalkPage(userInfo){
    if(component == null)
        component = Qt.createComponent("TalkPage.qml");
    if(component.status === Component.Ready){
        var dynamicObject = component.createObject();
        if(dynamicObject === null){
            console.log("error creating talkPage");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.clientName = userInfo.name;
        dynamicObject.language = userInfo.language;
        dynamicObject.sex = userInfo.sex;
        msgPages.push(dynamicObject);
        return msgPages[msgPages.length-1];
    }else{
        console.log("error ready talkPage");
        console.log(component.errorString());
        return false;
    }
}
