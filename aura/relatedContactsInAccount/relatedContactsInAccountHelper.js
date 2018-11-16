({
	getContacts : function(component,event) {
		 var accountId = component.get("v.recordId");
		 var actionToGetContacts = component.get("c.getRelatedContacts");
		 actionToGetContacts.setParams({
		 		accId : accountId
		 });
		 actionToGetContacts.setCallback(this,function(response){
		 	console.log('state@@@@@@@@@',response.getState());
		 	if(response.getState() == 'SUCCESS')
		 	{
			 		component.set("v.contacts",response.getReturnValue());
		 	}
		 });
		 $A.enqueueAction(actionToGetContacts);
	},

	openEmailComponent : function(component,event){
		var dockedComposer = component.find('dockedComposer');
		$A.util.addClass(dockedComposer,'slds-show');
		$A.util.removeClass(dockedComposer,'slds-hide');
	},

	shiftDiv: function(component, event,lWidth) {
        var changeposition = component.get("v.intervalId");
        var floatElement = document.getElementById('tofloat');	  
        if(changeposition < lWidth){
            floatElement.style.left = changeposition+'px';
            changeposition = changeposition + 5;
            component.set("v.intervalId",changeposition);
        }
        //reset the left to 0
        else{
            component.set("v.intervalId",0);
            floatElement.style.left = "0px";
            changeposition = component.get("v.intervalId");//resetting so as to hit the if block again
        }
    },

    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        console.log('selected list-------->',component.get("v.selectedConNames"));
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : component.get("v.selectedConNames")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log('state@@@@@@@@@@@@@',state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                component.set("v.listOfSearchRecords", storeResponse); 
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },

    sendHelper: function(component, getEmail, getSubject, getbody) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        // set the 3 params to sendMailMethod method   
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mbody': getbody
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                component.set("v.mailStatus", true);
                var toastEvent = $A.get("e.force:showToast");
		        toastEvent.setParams({
		            title : 'SuccesFull!!',
		            message: 'Email Sent Successfully!!',
		            type: 'success'
		        });
		        toastEvent.fire();
                var dockedComposer = component.find('dockedComposer');
		 		$A.util.removeClass(dockedComposer,'slds-show');
		 		$A.util.addClass(dockedComposer,'slds-hide');
            }
 
        });
        $A.enqueueAction(action);
    },
})