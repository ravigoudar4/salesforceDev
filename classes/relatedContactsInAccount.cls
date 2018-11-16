public class relatedContactsInAccount {
	@AuraEnabled
	public static List<Contact> getRelatedContacts(Id accId)
	{
		List<Contact> lstContacts = new List<Contact>();
		lstContacts = [SELECT Id,Name,Email 
							FROM Contact
							WHERE AccountId=:accId];
		return lstContacts;
 	}

 	@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<String> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
 		
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select id, Name,Email from ' +ObjectName + ' where Name LIKE: searchKey AND Name NOT IN : ExcludeitemsList order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled 
    public static void sendMailMethod(String[] mMail ,String mSubject ,String mbody){
    
     List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
  
     // Step 1: Create a new Email
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    // Step 2: Set list of people who should get the email
       //List<String> sendTo = new List<String>();
       //sendTo.add(mMail);
       mail.setToAddresses(mMail);
    
    // Step 3: Set who the email is sent from
       mail.setReplyTo('ravigoudar9611@gmail.com'); // change it with your mail address.
       mail.setSenderDisplayName('Ravi9611 sending mail to Ravi4'); 
    
    // Step 4. Set email contents - you can use variables!
      mail.setSubject(mSubject);
      mail.setHtmlBody(mbody);
    System.debug('mail##############'+mail);
    // Step 5. Add your email to the master list
      mails.add(mail);
    
  // Step 6: Send all emails in the master list
     Messaging.sendEmail(mails);
   } 
}