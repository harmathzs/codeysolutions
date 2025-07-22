@IsTest
private class DynamicApexTest {
	@IsTest
	static void testDescribe() {
		// Access a token for Account by accessing the sObjectType member variable
		Schema.SObjectType o1 = Account.SObjectType;
		System.debug('Account.SObjectType: '+o1);
		// DEBUG|Account.SObjectType: Account

		// Access a token for Contact by calling the getSObjectType method on Contact variable
		Contact c = new Contact();
		Schema.SObjectType o2 = c.getSObjectType();
		System.debug('Contact getSObjectType: '+o2);
		// DEBUG|Contact getSObjectType: Contact
	}
	@IsTest
	static void testPicklist() {

	}
}
