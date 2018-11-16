({
	doInIt : function(component, event, helper) {
        let rows = component.get('v.rowRecord');
        let api = component.get("v.rowAPI")
        //var row = JSON.parse(JSON.stringify(rows));
		console.log('rowRecord---------->',JSON.parse(JSON.stringify(rows))[api]);
		console.log('row API---------->',component.get("v.rowAPI"));
        component.set("v.data",JSON.parse(JSON.stringify(rows))[api]);
	}
})