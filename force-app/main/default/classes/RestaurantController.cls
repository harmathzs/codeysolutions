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

				,(SELECT Id
					,Pricebook2Id
					,Pricebook2.Name
					,UnitPrice
				FROM PricebookEntries)

			FROM Product2
			WHERE Family = 'Food'
		]);
	}

	@AuraEnabled
	public static Order takeOrderFromBasket(String basketJson) {
		Account account = [SELECT Id, Name FROM Account WHERE Name LIKE '%Codey Solutions%' LIMIT 1];
		Contract contract = [SELECT Id, ContractNumber FROM Contract WHERE ContractNumber LIKE '%0100%' LIMIT 1];
		Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name LIKE '%Restaurant Price Book 2025%' LIMIT 1];

		Order order = new Order(
			AccountId = account.Id,
			ContractId = contract.Id,
			EffectiveDate = Date.today(),
			Pricebook2Id = pb.Id,
			Table_Number__c = '1',
			Status = 'Ordered',
			RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Food').getRecordTypeId()
		);
		// TODO - fill order data from basketJson
		insert order;
		return order;
	}
}
