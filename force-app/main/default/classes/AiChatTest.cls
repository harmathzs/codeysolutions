/**
 * Created by Harmath Zsolt on 2025. 02. 10.
 */

@IsTest
private class AiChatTest {
	class mock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest request) {
			HttpResponse result = new HttpResponse();
			result.setStatusCode(200);
			result.setBody('{}');

			return result;
		}
	}

	@IsTest
	static void testBehavior() {
		Test.setMock(HttpCalloutMock.class, new mock());

		String result = AiChatController.calloutToGroq('{}');
	}
}
