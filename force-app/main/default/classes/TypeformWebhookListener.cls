/**
 * Created by Harmath Zsolt on 2025. 04. 16..
 */

@RestResource(urlMapping='/typeformwebhook')
global with sharing class TypeformWebhookListener {
	@HttpPost
	global static void handleWebhook() {
		RestRequest req = RestContext.request;
		System.debug('TypeformWebhookListener handleWebhook req: '+req);
		if (req!=null) {
			String requestBody = req.requestBody.toString();
			System.debug('TypeformWebhookListener handleWebhook requestBody: '+requestBody);
		}
		RestResponse res = RestContext.response;
		res.responseBody = Blob.valueOf('{"success": true}');
		res.statusCode = 200;
	}
}


