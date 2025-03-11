/**
 * Created by Harmath Zsolt on 2025. 02. 10.
 */

global with sharing class HttpCalloutController {
	global class InputParams {
		@InvocableVariable
		public String method;
		@InvocableVariable
		public String endpoint;
		@InvocableVariable
		public String headerKey1;
		@InvocableVariable
		public String headerValue1;
		@InvocableVariable
		public String headerKey2;
		@InvocableVariable
		public String headerValue2;
		@InvocableVariable
		public String headerKey3;
		@InvocableVariable
		public String headerValue3;
		@InvocableVariable
		public String inputBody;
	}
	global class OutputParams {
		@InvocableVariable
		public String responseBody;
		@InvocableVariable
		public Integer statusCode;
		@InvocableVariable
		public String statusText;
		@InvocableVariable
		public String errorMessage;
	}

	@InvocableMethod
	public static List<OutputParams> httpCallout(List<InputParams> inputs) {
		if (inputs==null || inputs.isEmpty()) return null;

		HttpRequest req = new HttpRequest();
		req.setMethod(inputs[0].method);
		req.setEndpoint(inputs[0].endpoint);

		if (String.isNotBlank(inputs[0].headerKey1)) {
			req.setHeader(inputs[0].headerKey1, inputs[0].headerValue1);
		}
		if (String.isNotBlank(inputs[0].headerKey2)) {
			req.setHeader(inputs[0].headerKey2, inputs[0].headerValue2);
		}
		if (String.isNotBlank(inputs[0].headerKey3)) {
			req.setHeader(inputs[0].headerKey3, inputs[0].headerValue3);
		}

		if (String.isNotBlank(inputs[0].inputBody)) {
			req.setBody(inputs[0].inputBody);
		}



		OutputParams result = new OutputParams();

		Http http = new Http();
		HttpResponse res;

		try {
			res = http.send(req);

			result.responseBody = res.getBody();
			result.statusCode = res.getStatusCode();
			result.statusText = res.getStatus();
		} catch (Exception err) {
			result.errorMessage = err.getMessage();
		}

		return new List<OutputParams>{result};
	}
}
