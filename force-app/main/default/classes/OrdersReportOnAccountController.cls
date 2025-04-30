/**
 * Created by Harmath Zsolt on 2025. 04. 30..
 */

public with sharing class OrdersReportOnAccountController {
	public String accountId {get; set;}
	public Account acc {get; set;}

	public List<List<String>> excelData {get; set;}

	public OrdersReportOnAccountController() {
		if (ApexPages.currentPage()!=null && ApexPages.currentPage().getParameters().containsKey('id'))
			accountId = ApexPages.currentPage().getParameters().get('id');
		if (String.isNotBlank(accountId))
			acc = OrdersReportOnAccountController.queryAccount(accountId);
		if (acc!=null) {
			excelData = populateExcelData(accountId);
		}
	}

	public OrdersReportOnAccountController(ApexPages.StandardController controller) {
		accountId = controller.getId();

		acc = OrdersReportOnAccountController.queryAccount(accountId);
		if (acc!=null) {
			excelData = populateExcelData(accountId);
		}
	}

	@AuraEnabled
	public static Account queryAccount(String accountId) {
		Account acc;

		if (String.isNotBlank(accountId)) {
			acc = [
				SELECT Id
					,Name
					,Description
					,(SELECT Id
						,OrderNumber
						,EffectiveDate
						,ActivatedDate
						,EndDate
						,TotalAmount
						,Description
						,RecordTypeId
						,RecordType.Name
						,RecordType.DeveloperName
						,Pricebook2Id
						,Pricebook2.Name
						,(SELECT Id
							,Product2Id
							,Product2.Name
							,Product2.Description
							,Product2.RecordTypeId
							,Product2.RecordType.Name
							,Product2.RecordType.DeveloperName
							,Description
							,Quantity
							,UnitPrice
							,ListPrice
							,TotalPrice
							,PricebookEntryId
							,PricebookEntry.UnitPrice
							,PricebookEntry.Pricebook2Id
							,PricebookEntry.Pricebook2.Name
						FROM OrderItems)
					FROM Orders)
				FROM Account
			];
		}

		return acc;
	}

	public List<List<String>> populateExcelData(String orderId) {
		Order order = OrderExcelReportController.queryOrder(orderId);

		excelData = new List<List<String>>();
		excelData.add(new List<String>{
			'Order Number',
			'Status',
			'Order Start Date',
			'Product Name',
			'Quantity',
			'Unit Price'
		});

		if (order!=null && order.OrderItems!=null && !order.OrderItems.isEmpty())
			for (OrderItem orderItem: order.OrderItems) {
				excelData.add(new List<String>{
					order.OrderNumber,
					order.Status,
					String.valueOf(order.EffectiveDate),
					orderItem.Product2.Name,
					String.valueOf(orderItem.Quantity),
					String.valueOf(orderItem.UnitPrice)
				});
			}
		return excelData;
	}

//	@AuraEnabled
//	public static String getTableData(String orderId) {
//		Order order = queryOrder(orderId);
//		System.debug('getTableData order: '+order);
//
//		OrderExcelReportController instance = new OrderExcelReportController();
//		instance.orderId = orderId;
//		List<List<String>> excelData = instance.populateExcelData(orderId);
//
//		System.debug('getTableData excelData: '+excelData);
//
//		return EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(excelData)));
//	}
//
//	@AuraEnabled
//	public static String createContentVersion(String orderId) {
//		try {
//			String orderNumber = orderId;
//			if (String.isNotBlank(orderId)) {
//				Order[] orders = [SELECT Id, Name, OrderNumber FROM Order WHERE Id =:orderId];
//				if (orders!=null && !orders.isEmpty()) {
//					orderNumber = orders[0].OrderNumber;
//				}
//			}
//
//			// Get the page content as blob
//			PageReference pageRef = Page.OrderExcelReport;
//			pageRef.getParameters().put('id', orderId);
//			Blob excelBlob;
//			if (!Test.isRunningTest())
//				excelBlob = pageRef.getContent();
//			else
//				excelBlob = Blob.valueOf('Test');
//
//			// Create ContentVersion
//			ContentVersion cv = new ContentVersion();
//			cv.Title = 'OrderExcelReport - ' + orderNumber + ' - ' + String.valueOf(System.now());
//			cv.PathOnClient = cv.Title + '.xlsx';
//			cv.VersionData = excelBlob;
//			cv.IsMajorVersion = true;
//			insert cv;
//
//			// Get ContentDocumentId
//			Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
//
//			// Create ContentDocumentLink
//			ContentDocumentLink cdl = new ContentDocumentLink();
//			cdl.ContentDocumentId = conDocId;
//			cdl.LinkedEntityId = orderId;
//			cdl.ShareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
//			cdl.Visibility = 'AllUsers';
//			if (!Test.isRunningTest())
//				insert cdl;
//			//return 'Success';
//			//return cdl.Id;
//			return conDocId;
//		} catch (Exception e) {
//			throw new AuraHandledException('Error creating file: ' + e.getMessage());
//		}
//	}

}
