var verifyPage = null;
var handleVerifyComponent = null;

function createDealVerifyPage(){
    if(handleVerifyComponent == null)
        handleVerifyComponent = Qt.createComponent("HandleVerifyPage.qml");
    if(handleVerifyComponent.status === Component.Ready){
        var dynamicObject = handleVerifyComponent.createObject();
        if(dynamicObject === null){
            console.log("error creating HandleVerifyPage");
            console.log(handleVerifyComponent.errorString());
            handleVerifyComponent = null;
            return null;
        }
        verifyPage = dynamicObject;
        return verifyPage;
    }else{
        console.log("error ready HandleVerifyPage");
        console.log(handleVerifyComponent.errorString());
        handleVerifyComponent = null;
        return null;
    }
}

function initVerifyPage(){
    if(verifyPage == null){
        createDealVerifyPage();
    }
}

function openHandleVerifyPage(){
    verifyPage.newRequests = 0;
    if(verifyPage != null){
        return verifyPage;
    }else{
        return createDealVerifyPage();
    }
}

function addVerifyItem(userInfo, msg){
    verifyPage.addVerifyItem(userInfo.name, userInfo.language, userInfo.sex, msg);
}

function getNewRequestsCount(){
    return verifyPage.newRequests;
}
