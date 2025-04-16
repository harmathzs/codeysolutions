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
}
