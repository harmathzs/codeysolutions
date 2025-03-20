/**
 * Created by Harmath Zsolt on 2025. 03. 18..
 */

@IsTest
private class RestaurantTest {
	@IsTest
	static void testgetCodeysRestaurantMenus() {
		RestaurantController.getCodeysRestaurantMenus();
	}

	@IsTest static void testgetAllFoods() {
		RestaurantController.getAllFoods();
	}

	@IsTest static void testtakeOrderFromBasket() {
		Account acc = new Account(Name='Codey Solutions');
		insert acc;

		Contract contract = new Contract(
			AccountId = acc.Id
		);
		insert contract;

		Pricebook2 pb = new Pricebook2(
			Name = 'Restaurant Price Book 2025'
		);
		insert pb;

		Product2 product = new Product2(
			Name = 'Test'
		);
		insert product;

		PricebookEntry pbe = new PricebookEntry(
			Pricebook2Id = pb.Id,
			Product2Id = product.Id,
			UnitPrice = 1,
			UseStandardPrice=true
		);
		insert pbe;

		String basketJson = '[{"Id":"01tgL000000MC6rQAG","Name":"Vegan lasagna","Family":"Food","Rich_Image__c":"<p><img src=\\"https://codeysolutions-dev-ed.develop.file.force.com/servlet/rtaImage?eid=01tgL000000MC6r&amp;feoid=00NgL00000LZIUD&amp;refid=0EMgL0000000SxB\\" alt=\\"vegan-lasagna-01.png\\"></img></p>","PricebookEntries":[{"Product2Id":"01tgL000000MC6rQAG","Id":"01ugL0000006mefQAA","Pricebook2Id":"01sgL0000007iacQAA","UnitPrice":8.99,"Pricebook2":{"Name":"Standard Price Book","Id":"01sgL0000007iacQAA"}},{"Product2Id":"01tgL000000MC6rQAG","Id":"01ugL0000006mgHQAQ","Pricebook2Id":"01sgL000000M04bQAC","UnitPrice":8.99,"Pricebook2":{"Name":"Codey\'s Restaurant Price Book 2025","Id":"01sgL000000M04bQAC"}}],"orderedQuantity":1}]';
		RestaurantController.takeOrderFromBasket(basketJson);
	}
}
