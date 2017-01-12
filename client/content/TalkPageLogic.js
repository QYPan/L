var component = null;

var pages = new Array;


function appendTalkMessage(name, language, message){
    console.log("in appendTalkMessage");
    var page = openTalkPage(name, language);
    page.addMessageFromFriend(message);
}

function openTalkPage(name, language) {
    var page = findTalkPage(name);
    if(page === undefined){
        console.log(name + " not exists");
        return createTalkPage(name, language);
    }else{
        console.log(name + " has exists");
        return page;
    }
}

function findTalkPage(name){
    var i;
    console.log("pages count: " + pages.length);
    for(i = 0; i < pages.length; i++){
        console.log("cout: " + pages[i].clientName);
        if(pages[i].clientName === name)
            return pages[i];
    }
}

function createTalkPage(name, language){
    if(component == null)
        component = Qt.createComponent("TalkPage.qml");
    if(component.status === Component.Ready){
        var dynamicObject = component.createObject();
        if(dynamicObject === null){
            console.log("error creating talkPage");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.clientName = name;
        dynamicObject.titleName = name + " | " + language;
        pages.push(dynamicObject);
        return pages[pages.length-1];
    }
}
