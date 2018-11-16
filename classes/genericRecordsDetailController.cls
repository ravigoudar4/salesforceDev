public class genericRecordsDetailController {
	public class finalWrapper{
		@AuraEnabled public List<SObject> lstRecords {get;set;}
		@AuraEnabled public List<fieldsWrapper> lstFields {get;set;}
		public finalWrapper(List<SObject> lstRecord, List<fieldsWrapper> lstFieldsWrapper){
			this.lstRecords = lstRecord;
			this.lstFields = lstFieldsWrapper;
		}
	}

	public class fieldsWrapper {
		@AuraEnabled public String fieldAPI   {get;set;}
		@AuraEnabled public String fieldLabel {get;set;}
		@AuraEnabled public String fieldType  {get;set;}
		public fieldsWrapper(String strFieldPath,String strFieldLabel,String strFieldType){
			this.fieldAPI = strFieldPath;
			this.fieldLabel = strFieldLabel;
			this.fieldType = strFieldType;
		}
	}

	@AuraEnabled
	public static finalWrapper getRecordsDetail(String objName,String fieldsetName,Integer noOfRecordsPerPage)
	{
		Set<String> setFieldsToQuery = new Set<String>();
		List<fieldsWrapper> lstFieldsWrapper = new List<fieldsWrapper>();
		//noOfRecordsPerPage to be developed in js
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

	    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

		for(Schema.FieldSetMember objFieldSetMember : fieldSetObj.getFields())
		{
			if(String.valueOf(objFieldSetMember.getType()) == 'REFERENCE')
			{
				if(objFieldSetMember.getFieldPath().toLowerCase().endsWith('__c'))
					setFieldsToQuery.add(objFieldSetMember.getFieldPath().toLowerCase().replace('__c','__r.Name'));
				else
					setFieldsToQuery.add(objFieldSetMember.getFieldPath().toLowerCase().replace('id','.Name'));
			}
			setFieldsToQuery.add(objFieldSetMember.getFieldPath().toLowerCase());
			
			lstFieldsWrapper.add(new fieldsWrapper(objFieldSetMember.getFieldPath(),objFieldSetMember.getLabel(),String.valueOf(objFieldSetMember.getType())));
		}

		String strQuery = 'SELECT id';
		for(String strFieldPath : setFieldsToQuery)
		{
			strQuery += ','+ strFieldPath;
		}
		strQuery += ' FROM '+objName;
		List<SObject> lstRecords = Database.query(strQuery);
		System.debug('strQuery $$$$$----->'+strQuery);
		return new finalWrapper(lstRecords,lstFieldsWrapper);
	}   
}