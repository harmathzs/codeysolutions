/**
 * Created by User on 2025. 06. 19..
 */

@IsTest
private class LeadConversionTest {
	@TestSetup
	static void testFactory() {
		Lead lead = new Lead(
			FirstName = 'Test',
			LastName = 'Joe',
			Company = 'Test Ltd',
			Email = 'test@joe.com'
		);
		insert lead;
	}

	@IsTest
	static void testBehavior() {
		Lead lead = [SELECT Id, Name, Email FROM Lead WHERE Email = 'test@joe.com'];
		Map<String, Object> conversionResults = LeadConversionService.customConvertLead(lead);
		System.debug('conversionResults: '+conversionResults);
	}
}
