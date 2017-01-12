var requestPage = null;
var dealRequestComponent = null;

function createDealRequestPage(){
    if(dealRequestComponent == null)
        dealRequestComponent = Qt.createComponent("DealRequestPage.qml");
    if(dealRequestComponent.status === Component.Ready){
        var dynamicObject = dealRequestComponent.createObject();
        if(dynamicObject === null){
            console.log("error creating talkPage");
            console.log(component.errorString());
            return false;
        }
        //dynamicObject.isLoaded = true;
        requestPage = dynamicObject;
        return requestPage;
    }
}

function openDealRequestPage(){
    if(requestPage != null){
        return requestPage;
    }else{
        return createDealRequestPage();
    }
}
