/**
 * Created by Harmath Zsolt on 2025. 04. 15..
 */

public with sharing class OrderExcelReportController {
	public String orderId {get; set;}
	public Order order {get; set;}

	public OrderExcelReportController(ApexPages.StandardController controller) {
		orderId = controller.getId();
		System.debug('OrderExcelReportController orderId: '+orderId);

		order = OrderExcelReportController.queryOrder(orderId);
		System.debug('OrderExcelReportController order: '+order);
		if (order!=null) {
			String jsonOrder = JSON.serializePretty(order);
			System.debug('OrderExcelReportController order json: ');
			System.debug(jsonOrder);
		}
	}

	@AuraEnabled
	public static Order queryOrder(String orderId) {
		Order order;

		if (String.isNotBlank(orderId)) {
			order = [
				SELECT Id, CreatedDate
					,Name
					,(SELECT Id, CreatedDate
					,EffectiveDate
					,(SELECT Id, CreatedDate
					,Product2Id, Product2.Name
					,Quantity
				FROM OrderItems ORDER BY CreatedDate ASC)
				FROM Orders)
				FROM Order
				WHERE Id = :orderId
			];
		}

		return order;
	}

	@AuraEnabled
	public static String getTableData(String orderId) {
		Order order = queryOrder(orderId);

		List<List<String>> excelData = new List<List<String>>();
		excelData.add(new List<String>{
			'Order Name',
			'Order Start Date',
			'Product Name'
		});

		if (order!=null && order.OrderItems!=null && !order.OrderItems.isEmpty())
			for (OrderItem orderItem: order.OrderItems) {
				excelData.add(new List<String>{
					order.Name,
					String.valueOf(order.EffectiveDate),
					orderItem.Product2.Name
				});
			}

		return EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(excelData)));
	}

	@AuraEnabled
	public static String createContentVersion(String orderId) {
		try {
			String orderName = orderId;
			if (String.isNotBlank(orderId)) {
				Order[] orders = [SELECT Id, Name FROM Order WHERE Id =:orderId];
				if (orders!=null && !orders.isEmpty()) {
					orderName = orders[0].Name;
				}
			}

			// Get the page content as blob
			PageReference pageRef; // TODO = Page.AccountOrderReport;
			pageRef.getParameters().put('id', orderId);
			Blob excelBlob;
			if (!Test.isRunningTest())
				excelBlob = pageRef.getContent();
			else
				excelBlob = Blob.valueOf('Test');

			// Create ContentVersion
			ContentVersion cv = new ContentVersion();
			cv.Title = 'OrderExcelReport - ' + orderName + ' - ' + String.valueOf(System.now());
			cv.PathOnClient = cv.Title + '.xlsx';
			cv.VersionData = excelBlob;
			cv.IsMajorVersion = true;
			insert cv;

			// Get ContentDocumentId
			Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;

			// Create ContentDocumentLink
			ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = conDocId;
			cdl.LinkedEntityId = orderId;
			cdl.ShareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
			cdl.Visibility = 'AllUsers';
			insert cdl;
			//return 'Success';
			//return cdl.Id;
			return conDocId;
		} catch (Exception e) {
			throw new AuraHandledException('Error creating file: ' + e.getMessage());
		}
	}

}
