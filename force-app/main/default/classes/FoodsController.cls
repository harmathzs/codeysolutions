/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

public with sharing class FoodsController {
	public static String[] ids;
	public Product2[] foods {get; set;}

	@AuraEnabled
	public static String[] storeIds(String[] ids) {
		FoodsController.ids = ids;
		return FoodsController.ids;
	}

	public FoodsController() {
		if (FoodsController.ids != null && !FoodsController.ids.isEmpty()) {
			foods = [
				SELECT Id, Name, Description
				FROM Product2
				WHERE Id IN :FoodsController.ids
			];
		}
	}

	public PageReference finishClick() {
		return null;
	}
}
