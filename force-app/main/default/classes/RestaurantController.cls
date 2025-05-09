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
		System.debug('takeOrderFromBasket basketJson: '+basketJson);

		Account account = [SELECT Id, Name FROM Account WHERE Name LIKE '%Codey Solutions%' LIMIT 1];
		Contract contract = [SELECT Id, ContractNumber FROM Contract WHERE ContractNumber LIKE '%0100%' LIMIT 1];
		Pricebook2 pb = [SELECT Id, Name
				,(SELECT Id, UnitPrice, Product2Id FROM PricebookEntries WHERE UnitPrice>0)
			FROM Pricebook2 WHERE Name LIKE '%Restaurant Price Book 2025%' LIMIT 1];

		Map<String, PricebookEntry> pbesByProductids = new Map<String, PricebookEntry>();
		for (PricebookEntry pbe: pb.PricebookEntries) {
			pbesByProductids.put(pbe.Product2Id, pbe);
		}

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
		System.debug('takeOrderFromBasket inserted order: '+order);

		// Parse basketJson and populate Order Products
		OrderItem[] orderProducts = new List<OrderItem>();
		Object[] basketList = (List<Object>)JSON.deserializeUntyped(basketJson);
		System.debug('takeOrderFromBasket basketList: '+basketList);
		for (Object basketRowMapObj: basketList) {
			System.debug('takeOrderFromBasket basketRowMapObj: '+basketRowMapObj);
			Map<String, Object> basketRowMap = (Map<String, Object>)basketRowMapObj;
			System.debug('takeOrderFromBasket basketRowMap: '+basketRowMap);

			Id productId = String.valueOf(basketRowMap.get('Id'));
			OrderItem orderProduct = new OrderItem(
				OrderId = order.Id,
				Product2Id = productId,
				PricebookEntryId = pbesByProductids.get(productId).Id,
				Quantity = Integer.valueOf(basketRowMap.get('orderedQuantity')),
				UnitPrice = pbesByProductids.get(productId).UnitPrice,
				ListPrice = pbesByProductids.get(productId).UnitPrice
			);
			System.debug('takeOrderFromBasket orderProduct: '+orderProduct);
			orderProducts.add(orderProduct);
		}
		// Insert Order Products
		insert orderProducts;
		System.debug('takeOrderFromBasket orderProducts: '+orderProducts);

		order.Status = 'Ordered';
		update order;
		System.debug('takeOrderFromBasket updated order: '+order);

		Id orderId = order.Id;
		System.debug('takeOrderFromBasket orderId: '+orderId);

		order = [SELECT Id, CreatedDate, OrderNumber
			,AccountId, Account.Name
			,ContractId, Contract.ContractNumber
			,EffectiveDate
			,Pricebook2Id
			,Pricebook2.Name
			,Table_Number__c
			,Status
			,RecordTypeId
			,RecordType.Name
			,TotalAmount
			,(SELECT Id, CreatedDate
				,Product2Id, Product2.Name
				,PricebookEntryId
				,PricebookEntry.UnitPrice
				,Quantity
				,UnitPrice
				,ListPrice
			FROM OrderItems)
		FROM Order
		WHERE Id = :orderId
		];
		System.debug('takeOrderFromBasket order: '+order);

		return order;
	}
}
