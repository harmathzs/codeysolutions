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
		Pricebook2 pb = [SELECT Id, Name
				,(SELECT Id, UnitPrice FROM PricebookEntries WHERE UnitPrice>0)
			FROM Pricebook2 WHERE Name LIKE '%Restaurant Price Book 2025%' LIMIT 1];
		PricebookEntry pbe = pb.PricebookEntries[0];

		Order order = new Order(
			AccountId = account.Id,
			ContractId = contract.Id,
			EffectiveDate = Date.today(),
			Pricebook2Id = pb.Id,
			Table_Number__c = '1',
			Status = 'Draft',
			RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Food').getRecordTypeId()
		);
		insert order;

		// Parse basketJson and populate Order Products
		OrderItem[] orderProducts = new List<OrderItem>();
		Object[] basketList = (List<Object>)JSON.deserializeUntyped(basketJson);
		for (Object basketRowMapObj: basketList) {
			Map<String, Object> basketRowMap = (Map<String, Object>)basketRowMapObj;
			OrderItem orderProduct = new OrderItem(
				OrderId = order.Id,
				Product2Id = String.valueOf(basketRowMap.get('Id')),
				PricebookEntryId = pbe.Id,
				Quantity = Integer.valueOf(basketRowMap.get('orderedQuantity')),
				UnitPrice = Double.valueOf(basketRowMap.get('unitPrice')),
				ListPrice = Double.valueOf(basketRowMap.get('unitPrice'))
			);
			orderProducts.add(orderProduct);
		}
		// Insert Order Products
		insert orderProducts;

		order.Status = 'Ordered';
		update order;

		return order;
	}
}
