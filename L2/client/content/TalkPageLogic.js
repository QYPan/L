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

function sendRequest(msg){
    request = new XMLHttpRequest();
    var str = "http://fanyi.youdao.com/openapi.do?keyfrom=english-2-chinese&key=1263917877&type=data&doctype=json&version=1.1&q=";
    request.onreadystatechange = handleStateChanged;
    request.open("GET", str+msg)
    request.send();
}

function handleStateChanged(){
    if(request.readyState === 4 && request.status === 200){
        var ans = request.responseText;
        var tmsg = JSON.parse(ans).translation[0];
        console.log("translate: " + tmsg);
        appendMessage(guserInfo, gmsg, tmsg);
    }
}

function handleMessage(userInfo, msg){
    guserInfo = userInfo;
    gmsg = msg;
    if(userInfo.language !== qmlInterface.clientLanguage){
        sendRequest(msg);
    }else{
        appendMessage(guserInfo, msg, msg);
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
    var page = findTalkPage(name);
    if(page !== undefined){
        page.destroy();
        page = null;
    }
    console.log("pages lenght: " + msgPages.length);
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
