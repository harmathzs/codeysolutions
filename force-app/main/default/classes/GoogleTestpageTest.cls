/**
 * Created by Harmath Zsolt on 2025. 02. 20.
 */

@IsTest
private class GoogleTestpageTest {

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

		GoogleTestpageController controller = new GoogleTestpageController();
		controller.handleCallback();
		controller.forceConsent();
		controller.authorizationCode = 'TEST';
		controller.newAccessTokenNow();
		controller.refreshAccessToken();
		controller.getUserinfo();
		controller.getAccounts();
		controller.getCalendars();
		controller.getDriveFilesList();
		controller.getLastEmails();
	}

	@IsTest static void testProperties() {
		GoogleTestpageController controller = new GoogleTestpageController();
		String accessTokenRequestString = controller.accessTokenRequestString;
		String accessTokenResponseBodyJson = controller.accessTokenResponseBodyJson;
		String refreshTokenRequestString = controller.refreshTokenRequestString;
		String refreshTokenResponseBodyJson = controller.refreshTokenResponseBodyJson;
		Integer expiresIn = controller.expiresIn;
		Datetime tokenExpirationTime = controller.tokenExpirationTime;
		String getLocationsRequestString = controller.getLocationsRequestString;
		String getLocationsResponseBodyJson = controller.getLocationsResponseBodyJson;
		String getReviewsRequestString = controller.getReviewsRequestString;
		String getReviewsResponseBodyJson = controller.getReviewsResponseBodyJson;
		String putReplyRequestString = controller.putReplyRequestString;
		String putReplyResponseBodyJson = controller.putReplyResponseBodyJson;
		String getOauthRequestString = controller.getOauthRequestString;
		String getOauthResponseBodyJson = controller.getOauthResponseBodyJson;
	}
}
