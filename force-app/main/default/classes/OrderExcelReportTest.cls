/**
 * Created by Harmath Zsolt on 2025. 04. 16..
 */

@IsTest
private class OrderExcelReportTest {
	@TestSetup static void testFactory() {

	}

	@IsTest
	static void testStaticNull() {
		OrderExcelReportController.queryOrder(null);
		OrderExcelReportController.createContentVersion(null);
		OrderExcelReportController.getTableData(null);
	}

	@IsTest static void testParameter() {
		PageReference pref = Page.OrderExcelReport;
		Test.setCurrentPage(pref);
		pref.getParameters().put('id', 'test');

		Order order = new Order();
		ApexPages.StandardController stdController = new ApexPages.StandardController(order);

		try {
			OrderExcelReportController instance = new OrderExcelReportController(stdController);
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
		Order queriedOrder = OrderExcelReportController.queryOrder(testOrder.Id);
		System.assertNotEquals(null, queriedOrder, 'Order should not be null');

		// Test getTableData method
		OrderExcelReportController.getTableData(testOrder.Id);
		//System.assertEquals(1, orderItems.size(), 'There should be one OrderItem');

		// Test createContentVersion method
		OrderExcelReportController.createContentVersion(testOrder.Id);
		//System.assertNotEquals(null, contentVersion, 'ContentVersion should not be null');
	}

}
