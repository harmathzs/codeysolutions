/**
 * Created by Harmath Zsolt on 2025. 04. 15..
 */

public with sharing class OrderExcelReportController {
	public String orderId {get; set;}
	public Order order {get; set;}

	public Map<String, String> effectivedateStrByOrderid {get; set;}

	List<List<String>> excelData {get; set;}

	public OrderExcelReportController() {
		if (ApexPages.currentPage()!=null && ApexPages.currentPage().getParameters().containsKey('id'))
			orderId = ApexPages.currentPage().getParameters().get('id');
		if (String.isNotBlank(orderId))
			order = OrderExcelReportController.queryOrder(orderId);
		if (order!=null) {
			String jsonOrder = JSON.serializePretty(order);
			System.debug('OrderExcelReportController order json: ');
			System.debug(jsonOrder);

			effectivedateStrByOrderid = new Map<String, String>{
				orderId => String.valueOf(order.EffectiveDate)
			};
		}
	}

	public OrderExcelReportController(ApexPages.StandardController controller) {
		orderId = controller.getId();
		System.debug('OrderExcelReportController orderId: '+orderId);

		order = OrderExcelReportController.queryOrder(orderId);
		System.debug('OrderExcelReportController order: '+order);
		if (order!=null) {
			String jsonOrder = JSON.serializePretty(order);
			System.debug('OrderExcelReportController order json: ');
			System.debug(jsonOrder);

			effectivedateStrByOrderid = new Map<String, String>{
				orderId => String.valueOf(order.EffectiveDate)
			};
		}
	}

	@AuraEnabled
	public static Order queryOrder(String orderId) {
		Order order;

		if (String.isNotBlank(orderId)) {
			order = [
					SELECT Id, CreatedDate
						,EffectiveDate
						,Name
						,OrderNumber
						,Status
					,(SELECT Id, CreatedDate
						,Product2Id, Product2.Name
						,Quantity
						,UnitPrice
					FROM OrderItems ORDER BY CreatedDate ASC)
				FROM Order
				WHERE Id = :orderId
			];
		}

		return order;
	}

	public List<List<String>> populateExcelData(String orderId) {
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

	@AuraEnabled
	public static String getTableData(String orderId) {
		Order order = queryOrder(orderId);
		System.debug('getTableData order: '+order);

		OrderExcelReportController instance = new OrderExcelReportController();
		instance.orderId = orderId;
		List<List<String>> excelData = instance.populateExcelData(orderId);

		System.debug('getTableData excelData: '+excelData);

		return EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(excelData)));
	}

	@AuraEnabled
	public static String createContentVersion(String orderId) {
		try {
			String orderNumber = orderId;
			if (String.isNotBlank(orderId)) {
				Order[] orders = [SELECT Id, Name, OrderNumber FROM Order WHERE Id =:orderId];
				if (orders!=null && !orders.isEmpty()) {
					orderNumber = orders[0].OrderNumber;
				}
			}

			// Get the page content as blob
			PageReference pageRef = Page.OrderExcelReport;
			pageRef.getParameters().put('id', orderId);
			Blob excelBlob;
			if (!Test.isRunningTest())
				excelBlob = pageRef.getContent();
			else
				excelBlob = Blob.valueOf('Test');

			// Create ContentVersion
			ContentVersion cv = new ContentVersion();
			cv.Title = 'OrderExcelReport - ' + orderNumber + ' - ' + String.valueOf(System.now());
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
