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
		if (ApexPages.currentPage().getParameters().containsKey('ids')) {
			String idsCommaJoinedJson = ApexPages.currentPage().getParameters().get('ids');
			System.debug('idsCommaJoinedJson: '+idsCommaJoinedJson); // "01tgL000000MJyTQAW,01tgL000000MH6LQAW,"
			String idsCommaJoined = JSON.deserializeUntyped(idsCommaJoinedJson).toString();
			System.debug('idsCommaJoined: '+idsCommaJoined); // 01tgL000000MJyTQAW,01tgL000000MC6rQAG,
			FoodsController.storeIds(idsCommaJoined.split(','));
			System.debug('ids: '+FoodsController.ids);
			if (FoodsController.ids != null && !FoodsController.ids.isEmpty()) {
				foods = [
					SELECT Id, Name, Description
					FROM Product2
					WHERE Id IN :FoodsController.ids
				];
			}
			System.debug('foods: '+foods);
		}
	}

	public PageReference finishClick() {
		PageReference pageRef = new PageReference('/01t/o');
		pageRef.setRedirect(true);
		return pageRef;
	}
}
