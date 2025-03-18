/**
 * Created by Harmath Zsolt on 2025. 03. 17..
 */

public with sharing class RestaurantController {
	@AuraEnabled
	public static CodeysRestaurantMenus__c getCodeysRestaurantMenus() {
		return CodeysRestaurantMenus__c.getInstance();
	}

	@AuraEnabled
	public static Map<Id, Product2> getAllFoods() {
		return new Map<Id, Product2>([
			SELECT Id
				,Name
				,Family
				,Rich_Image__c
			FROM Product2
			WHERE Family = 'Food'
		]);
	}
}
