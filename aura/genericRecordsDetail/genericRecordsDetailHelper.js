({
	loadData : function(component,event,helper) {
		let action;
		action = component.get("c.getRecordsDetail");
		action.setParams({
			"objName" : component.get("v.object"),
			"fieldsetName" : component.get("v.fieldSetName"),
			"noOfRecordsPerPage" : component.get("v.prev")
		});
		action.setCallback(this,function(response){
			if(response.getState() == "SUCCESS")
			{
				let retValue = response.getReturnValue();
				this.createHeader(component,retValue['lstFields']);
				this.createRowData(component,retValue['lstRecords'],retValue['lstFields']);
				console.log('records------>',retValue['lstRecords']);
			}
		});
		$A.enqueueAction(action);
	},

	createHeader : function(component,lstFields)
	{
		let headerData = lstFields.map(field =>{
			var obj = {};
			obj['label'] = field['fieldLabel']
			obj['fieldPath'] = field['fieldAPI']
			return obj;
		})
		component.set("v.headerData",headerData);
	},

	createRowData : function(component,lstRecords,lstFields)
	{
		let fieldPath = lstFields.map(field => {
			return field['fieldAPI'];
		});
		console.log('fieldPath------->',fieldPath);
		component.set("v.fieldPath",fieldPath);
		component.set("v.rowData",lstRecords);
	}


})