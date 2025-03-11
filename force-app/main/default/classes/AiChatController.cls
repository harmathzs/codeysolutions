/**
 * Created by Harmath Zsolt on 2025. 02. 10.
 */

public with sharing class AiChatController {
	@AuraEnabled
	public static String calloutToGroq(String requestBodyJSON) {
		String groqApikey = '';

		AI_Setting__mdt[] aiSettings = [SELECT Id, AI_Provider__c, API_Key__c FROM AI_Setting__mdt];
		for (AI_Setting__mdt aiSetting: aiSettings) {
			if (aiSetting.AI_Provider__c == 'Groq') {
				groqApikey = aiSetting.API_Key__c;
			}
		}

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'POST';
		inp.endpoint = 'https://api.groq.com/openai/v1/chat/completions';
		inp.headerKey1 = 'Content-Type';
		inp.headerValue1 = 'application/json';
		inp.headerKey2 = 'Authorization';
		inp.headerValue2 = 'Bearer '+groqApikey;
		inp.inputBody = requestBodyJSON;
		HttpCalloutController.OutputParams[] results = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('calloutToGroq results: '+results);
		if (results==null || results.isEmpty()) return null;
		return JSON.serializePretty(results[0]);
	}
}
