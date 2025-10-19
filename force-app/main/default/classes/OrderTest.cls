/**
 * Created by User on 2025. 10. 19..
 */

@IsTest
private class OrderTest {
	@IsTest
	static void testBehavior() {
		// Create test Account
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Create test Order
		Order testOrder = new Order(AccountId = testAccount.Id, EffectiveDate = System.today(), Status = 'Draft'
			,Pricebook2Id = Test.getStandardPricebookId()
		);
		insert testOrder;

		// Test OrderService as Visualforce standard controller
		ApexPages.StandardController stdController = new ApexPages.StandardController(testOrder);
		OrderService controller = new OrderService(stdController);

		// Assertions
		System.assertEquals('pdf', controller.renderAs);
	}
}
