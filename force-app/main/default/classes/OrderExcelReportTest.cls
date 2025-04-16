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
}
