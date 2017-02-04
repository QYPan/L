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

function appendMessage(userInfo, msg){
    var page = openTalkPage(userInfo);
    if(page !== undefined){
        page.appendMsg(userInfo, msg, false);
    }
}

function findTalkPage(name){
    var i;
    for(i = 0; i < msgPages.length; i++){
        if(msgPages[i].clientName === name)
            return msgPages[i];
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
