/**
 * Created by Harmath Zsolt on 2025. 03. 12..
 */

@IsTest
private class AccountTriggerTest {
	@IsTest
	static void testBehavior() {
		Account acc = new Account(Name='Test');

		insert acc;
		update acc;
		delete acc;
		undelete acc;
	}
}
