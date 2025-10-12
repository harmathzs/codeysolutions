/**
 * Created by User on 2025. 10. 12..
 */

@IsTest
private class ConvertibleLeadsTest {
	@TestSetup static void testFactory() {
		insert new Lead(FirstName='John', LastName='Doe', Email='john@doe.com', Company='Test Corp');
	}

	@IsTest
	static void testBehavior() {
		ConvertibleLeadsController controller = new ConvertibleLeadsController();
		Lead[] convertibleLeads = controller.convertibleLeads;
		System.assertNotEquals(0, convertibleLeads.size());
	}
}
