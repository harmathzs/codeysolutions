@IsTest
private class ContinuationDemoTest {
	@IsTest
	static void testAction() {
		ContinuationDemoController controller = new ContinuationDemoController();
		controller.myAction();
	}

	@IsTest
	static void testCallback() {
		ContinuationDemoController controller = new ContinuationDemoController();
		controller.myCallbackMethod();
	}
}
