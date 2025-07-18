/**
 * Created by User on 2025. 07. 18..
 */

public with sharing class BibleController {
	@AuraEnabled
	public static BibleComSettings__c getBibleComCustomSettings() {
		BibleComSettings__c result = BibleComSettings__c.getOrgDefaults();
		System.debug('BibleController.getBibleComCustomSettings() result: '+result);
		return result;
	}
}
