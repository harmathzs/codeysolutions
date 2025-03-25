/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

@IsTest
private class AccountFlowLauncherTest {
	@TestSetup static void testFactory() {
		Account acc1 = new Account(Name='Test');
		Account[] accounts = new List<Account>{acc1};
		insert accounts;
	}

	@IsTest
	static void testBehavior() {
		SchedulableContext context = null;
		AccountFlowLauncherBatch schedulable = new AccountFlowLauncherBatch();
		Test.startTest();
		schedulable.execute(context);
		Test.stopTest();
	}
}
