@isTest
private class genericRecordsDetailControllerTest
{
	@TestSetup
	static void setUp()
	{
		Contact objContact = new Contact(LastName='Ravi');
		insert objContact;
	}

	@isTest
	private static void testGetRecordsDetail()
	{
		genericRecordsDetailController.getRecordsDetail('Contact','contact_field',10);
	}
}