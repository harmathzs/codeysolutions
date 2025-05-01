/**
 * Created by Harmath Zsolt on 2025. 05. 01..
 */

@IsTest
private class OrdersReportOnAccountTest {
	@IsTest
	static void testStaticNull() {
		OrdersReportOnAccountController.queryAccount(null);
		OrdersReportOnAccountController.createContentVersion(null);
		OrdersReportOnAccountController.getTableData(null);
	}

	@IsTest static void testParameter() {
		PageReference pref = Page.OrdersReportOnAccount;
		Test.setCurrentPage(pref);
		pref.getParameters().put('id', 'test');

		Account acc = new Account(Name='Test Account');
		insert acc;
		ApexPages.StandardController stdController = new ApexPages.StandardController(acc);

		try {
			OrdersReportOnAccountController instance = new OrdersReportOnAccountController(stdController);
		} catch (Exception e) {
			System.debug(e.getMessage());
		}
	}

	@IsTest static void testWithOrderData() {
		// Create test Account
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;

		// Create test Order
		Order testOrder = new Order(AccountId = testAccount.Id, EffectiveDate = System.today(), Status = 'Draft'
			,Pricebook2Id = Test.getStandardPricebookId()
		);
		insert testOrder;

		// Create test Product
		Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
		insert testProduct;

		// Create test PricebookEntry
		PricebookEntry testPricebookEntry = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = testProduct.Id,
			UnitPrice = 100.00,
			IsActive = true
		);
		insert testPricebookEntry;

		// Create test OrderItem
		OrderItem testOrderItem = new OrderItem(
			OrderId = testOrder.Id,
			PricebookEntryId = testPricebookEntry.Id,
			Quantity = 1,
			UnitPrice = 100.00
		);
		insert testOrderItem;

		// Test queryOrder method
		Account queriedAccount = OrdersReportOnAccountController.queryAccount(testAccount.Id);

		// Test getTableData method
		OrdersReportOnAccountController.getTableData(testAccount.Id);

		// Test createContentVersion method
		OrdersReportOnAccountController.createContentVersion(testAccount.Id);
	}
}
