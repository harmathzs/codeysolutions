/**
 * Created by Harmath Zsolt on 2025. 02. 10.
 */

@IsTest
private class HttpCalloutTest {

	class mock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest request) {
			HttpResponse result = new HttpResponse();
			result.setStatusCode(200);
			result.setBody('{}');

			return result;
		}
	}

	@IsTest
	static void testInvocable() {
		Test.setMock(HttpCalloutMock.class, new mock());

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = 'https://localhost/';
		inp.headerKey1 = 'test';
		inp.headerValue1 = 'test';
		inp.headerKey2 = 'test';
		inp.headerValue2 = 'test';
		inp.headerKey3 = 'test';
		inp.headerValue3 = 'test';
		inp.inputBody = '{}';
		HttpCalloutController.OutputParams[] outputs = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
	}

	@IsTest
	static void testAuraMethod() {
		Test.setMock(HttpCalloutMock.class, new mock());

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = 'https://localhost/';
		inp.headerKey1 = 'test';
		inp.headerValue1 = 'test';
		inp.headerKey2 = 'test';
		inp.headerValue2 = 'test';
		inp.headerKey3 = 'test';
		inp.headerValue3 = 'test';
		inp.inputBody = '{}';
		HttpCalloutController.OutputParams[] outputs = HttpCalloutController.httpCalloutAura(new List<HttpCalloutController.InputParams>{inp});
	}

	@IsTest
	static void testVFprops() {
		Test.setMock(HttpCalloutMock.class, new mock());

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = 'https://localhost/';
		inp.headerKey1 = 'test';
		inp.headerValue1 = 'test';
		inp.headerKey2 = 'test';
		inp.headerValue2 = 'test';
		inp.headerKey3 = 'test';
		inp.headerValue3 = 'test';
		inp.inputBody = '{}';

		HttpCalloutController instance = new HttpCalloutController();
		instance.inputsVF = new List<HttpCalloutController.InputParams>{inp};
		HttpCalloutController.OutputParams[] outputs = instance.httpCalloutVF;
	}
}
