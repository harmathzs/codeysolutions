/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

@IsTest
private class FoodsTest {
	@TestSetup static void testFactory() {
		Product2 prod = new Product2(
			Name = 'Test',
			Description = 'Test'
		);
		insert prod;
	}

	@IsTest
	static void testBehavior() {
		Product2 prod = [
			SELECT Id, Name, Description
			FROM Product2
			WHERE Name = 'Test'
			LIMIT 1
		];
		String[] ids = new List<String>{prod.Id};
		//FoodsController.ids = ids;
		FoodsController.storeIds(ids);
		String joinedIds = String.join(ids, ',');

		PageReference foodPage = Page.Foods;
		foodPage.getParameters().put('ids', joinedIds);
		Test.setCurrentPage(foodPage);

		FoodsController controller = new FoodsController();
		controller.finishClick();
	}
}
