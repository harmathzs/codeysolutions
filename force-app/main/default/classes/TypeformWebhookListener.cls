/**
 * Created by Harmath Zsolt on 2025. 04. 16..
 */

@RestResource(UrlMapping='/typeformwebhook')
global with sharing class TypeformWebhookListener {
	@HttpPost
	global static void handleWebhook() {
		RestRequest req = RestContext.request;
		String requestBody;
		if (req!=null) requestBody = req.requestBody.toString();
		// TODO - process Typeform payload, insert new incoming lead
		System.debug('handleWebhook requestBody: '+requestBody);
	}
}

