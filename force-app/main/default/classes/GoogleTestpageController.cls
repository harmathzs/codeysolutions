/**
 * Created by Harmath Zsolt on 2025. 02. 11.
 */

public with sharing class GoogleTestpageController {
	public String authorizationCode {get; set;}

	private String privateGoogleUsername;
	public String googleUsername {
		get {
			if (String.isBlank(privateGoogleUsername)) {
				privateGoogleUsername = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Username__c;
				return privateGoogleUsername;
			} else return privateGoogleUsername;
		}
		set {
			if (String.isBlank(value)) {
				privateGoogleUsername = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Username__c;
			} else privateGoogleUsername = value;
		}
	}

	private String privateGooglePassword;
	public String googlePassword {
		get {
			if (String.isBlank(privateGooglePassword)) {
				privateGooglePassword = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Password__c;
				return privateGooglePassword;
			} else return privateGooglePassword;
		}
		set {
			if (String.isBlank(value)) {
				privateGooglePassword = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Password__c;
			} else privateGooglePassword = value;
		}
	}

	private String privateClientId;
	public String CLIENT_ID {
		get {
			if (String.isBlank(privateClientId)) {
				privateClientId = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Client_Id__c;
				return privateClientId;
			} else return privateClientId;
		}
		set {
			if (String.isBlank(value)) {
				privateClientId = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Client_Id__c;
			} else privateClientId = value;
		}
	}

	private String privateClientSecret;
	public String CLIENT_SECRET {
		get {
			if (String.isBlank(privateClientSecret)) {
				privateClientSecret = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Client_Secret__c;
				return privateClientSecret;
			} else return privateClientSecret;
		}
		set {
			if (String.isBlank(value)) {
				privateClientSecret = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Client_Secret__c;
			} else privateClientSecret = value;
		}
	}

	private String privateScope;
	public String scope {
		get {
			if (String.isBlank(privateScope)) {
				privateScope = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Scope__c;
				return privateScope;
			} else return privateScope;
		}
		set {
			if (String.isBlank(value)) {
				privateScope = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Scope__c;
			} else privateScope = value;
		}
	}

	private String privateRedirectUri;
	public String REDIRECT_URI {
		get {
			if (String.isBlank(privateRedirectUri)) {
				privateRedirectUri = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Redirect_URI__c;
				return privateRedirectUri;
			} else return privateRedirectUri;
		}
		set {
			if (String.isBlank(value)) {
				privateRedirectUri = [SELECT Id, Username__c, Password__c, Client_Id__c, Client_Secret__c, Scope__c, Redirect_URI__c FROM Google_Credential__mdt LIMIT 1].Redirect_URI__c;
			} else privateRedirectUri = value;
		}
	}


	public String accessToken {get; set;}
	public String refreshToken {get; set;}

	public String accessTokenRequestString {get; set;}
	public String accessTokenResponseBodyJson {get; set;}

	public String refreshTokenRequestString {get; set;}
	public String refreshTokenResponseBodyJson {get; set;}

	public Integer expiresIn {get; set;}
	public Datetime tokenExpirationTime {get; set;}

	public String getUserinfoRequestString {get; set;}
	public String getUserinfoResponseBodyJson {get; set;}

	public String getAccountsRequestString {get; set;}
	public String getAccountsResponseBodyJson {get; set;}

	public String getLocationsRequestString {get; set;}
	public String getLocationsResponseBodyJson {get; set;}

	public String getReviewsRequestString {get; set;}
	public String getReviewsResponseBodyJson {get; set;}

	public String putReplyRequestString {get; set;}
	public String putReplyResponseBodyJson {get; set;}

	public String getOauthRequestString {get; set;}
	public String getOauthResponseBodyJson {get; set;}

	public String getConsentRequestString {get; set;}
	public String getConsentResponseBodyJson {get; set;}

	public String getCalendarsRequestString {get; set;}
	public String getCalendarsResponseBodyJson {get; set;}

	public String getDriveFilesListRequestString {get; set;}
	public String getDriveFilesListResponseBodyJson {get; set;}

	public String getLastEmailsRequestString {get; set;}
	public String getLastEmailsResponseBodyJson {get; set;}

	public String accountidForGetLocations {get; set;}
	public String locationidForGetReviews {get; set;}
	public String reviewidForPutReply {get; set;}
	public String commentForPutReply {get; set;}

	public class CalendarItem {
		public String id {get; set;}
		public String summary {get; set;}
		public String description {get; set;}
		public String timeZone {get; set;}
	}
	public CalendarItem[] calendarItems {get; set;}

	public PageReference handleCallback() {
		System.debug('handleCallback start');
		Map<String, String> params = ApexPages.currentPage().getParameters();
		for(String key : params.keySet()) {
			System.debug('Parameter: ' + key + ' = ' + params.get(key));
		}

		if (params.containsKey('code')) {
			authorizationCode = params.get('code');
			System.debug('authorizationCode: ' + authorizationCode);

			// Callback calls for exchanging auth.code to access token:
			newAccessTokenNow();

		} else if (params.containsKey('error')) {
			String errorMessage = 'Error: ' + params.get('error');
			System.debug('Error: ' + errorMessage);
		}
		return null;
	}

	public PageReference forceConsent() {
		System.debug('Google Username: '+googleUsername);
		System.debug('Google Password: '+googlePassword);
		System.debug('Google CLIENT_ID: '+CLIENT_ID);
		System.debug('Google CLIENT_SECRET: '+CLIENT_SECRET);

		String baseUrl = 'https://accounts.google.com/o/oauth2/v2/auth';

		String method = 'GET';
		String authUrl = baseUrl +
			'?client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8') +
			'&redirect_uri=' + EncodingUtil.urlEncode(REDIRECT_URI, 'UTF-8') +
			'&response_type=code' +
			'&scope=' + EncodingUtil.urlEncode(SCOPE, 'UTF-8') +
			'&access_type=offline' +
			'&prompt=consent' + // Force consent
			'&state=' + EncodingUtil.urlEncode(SCOPE, 'UTF-8');

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = authUrl;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});

		getConsentRequestString = method + ' ' + authUrl;
		System.debug('getConsentRequestString: '+getConsentRequestString);
		getConsentResponseBodyJson = returns[0].responseBody;
		System.debug('getConsentResponseBodyJson: '+getConsentResponseBodyJson);

		return new PageReference(authUrl);
	}

	public PageReference newAccessTokenNow() {
		String body = 'code=' + EncodingUtil.urlEncode(authorizationCode, 'UTF-8')
			+ '&client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8')
			+ '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8')
			+ '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECT_URI, 'UTF-8')
			+ '&grant_type=authorization_code';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'POST';
		inp.endpoint = 'https://oauth2.googleapis.com/token';
		inp.headerKey1 = 'Content-Type';
		inp.headerValue1 = 'application/x-www-form-urlencoded';
		inp.inputBody = body;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('newAccessTokenNow returns: '+returns);

		Map<String, Object> tokenResponse = (Map<String, Object>) JSON.deserializeUntyped(returns[0].responseBody);
		System.debug('newAccessTokenNow tokenResponse keySet: ' + tokenResponse.keySet());
		accessToken = (String) tokenResponse.get('access_token');
		refreshToken = (String) tokenResponse.get('refresh_token');

		return null;
	}

	public PageReference refreshAccessToken() {
		String body;
		if (String.isBlank(refreshToken)) {
			body = 'client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8')
				+ '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8')

				+ '&grant_type=refresh_token';
		} else {
			body = 'client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8')
				+ '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8')
				+ '&refresh_token=' + EncodingUtil.urlEncode(refreshToken, 'UTF-8')
				+ '&grant_type=refresh_token';
		}


		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'POST';
		inp.endpoint = 'https://oauth2.googleapis.com/token';
		inp.headerKey1 = 'Content-Type';
		inp.headerValue1 = 'application/x-www-form-urlencoded';
		inp.inputBody = body;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('refreshAccessToken returns: '+returns);

		Map<String, Object> tokenResponse = (Map<String, Object>) JSON.deserializeUntyped(returns[0].responseBody);
		System.debug('refreshAccessToken tokenResponse keySet: ' + tokenResponse.keySet());
		if (tokenResponse.containsKey('access_token')) {
			String newAccessToken = (String) tokenResponse.get('access_token');
			if (String.isNotBlank(newAccessToken)) {
				accessToken = newAccessToken;
			}
		}
		if (tokenResponse.containsKey('expires_in')) {
				expiresIn = (Integer) tokenResponse.get('expires_in');
				tokenExpirationTime = System.now().addSeconds(expiresIn);
		}
		// Check if a new refresh token was issued
		if (tokenResponse.containsKey('refresh_token')) {
			String newRefreshToken = (String) tokenResponse.get('refresh_token');
			if (String.isNotBlank(newRefreshToken)) {
				refreshToken = newRefreshToken;
			}
		}

		System.debug('Access Token: ' + accessToken);
		System.debug('Refresh Token: ' + refreshToken);

		return null;
	}

	public PageReference getUserinfo() {
		String method = 'GET';
		String endpoint = 'https://www.googleapis.com/oauth2/v3/userinfo';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = 'https://www.googleapis.com/oauth2/v3/userinfo';
		inp.headerKey1 = 'Authorization';
		inp.headerValue1 = 'Bearer '+accessToken;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('refreshAccessToken returns: '+returns);

		getUserinfoRequestString = method + ' ' + endpoint;
		getUserinfoResponseBodyJson = returns[0].responseBody;

		return null;
	}

	public PageReference getAccounts() {
		String method = 'GET';
		String endpoint = 'https://mybusinessaccountmanagement.googleapis.com/v1/accounts';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = 'GET';
		inp.endpoint = 'https://mybusinessaccountmanagement.googleapis.com/v1/accounts';
		inp.headerKey1 = 'Authorization';
		inp.headerValue1 = 'Bearer '+accessToken;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('refreshAccessToken returns: '+returns);

		getAccountsRequestString = method + ' ' + endpoint;
		getAccountsResponseBodyJson = returns[0].responseBody;

		return null;
	}

	/*
	public PageReference getLocations() {
		String method = 'GET';
		String endpoint = 'https://mybusiness.googleapis.com/v4/accounts/'+accountidForGetLocations+'/locations';

//		AHttpResponse response = GoogleGETlocationsService.getGoogleLocations(accountidForGetLocations);
//
//		getLocationsRequestString = method + ' ' + endpoint;
//		getLocationsResponseBodyJson = response.getBody();
		return null;
	}

	public PageReference getReviews() {
		Datetime oneDayAgo = Datetime.now().addDays(-1);
		String datePart = oneDayAgo.format('yyyy-MM-dd');
		String timePart = oneDayAgo.format('HH:mm:ss');
		String oneDayAgoStr = datePart +'T'+ timePart +'Z'+ '';


		String method = 'GET';
		String endpoint = 'https://mybusiness.googleapis.com/v4/accounts/'+accountidForGetLocations+'/locations/'+locationidForGetReviews+'/reviews?filter=createTime>="'+oneDayAgoStr+'"&pageSize=100';
		Map<String, String> header = new Map<String, String>{
			'Authorization' => 'Bearer ' + accessToken
		};

//		AHttpResponse response = GoogleGETreviewsService.getGoogleReviews(accountidForGetLocations, locationidForGetReviews);
//
//		getReviewsRequestString = method + ' ' + endpoint;
//		getReviewsResponseBodyJson = response.getBody();
		return null;
	}

	 */

	/*
	public PageReference putReply() {
		// PUT https://mybusiness.googleapis.com/v4/accounts/1234567890/locations/0987654321/reviews/abcdef123456/reply

		String method = 'PUT';
		String endpoint = 'https://mybusiness.googleapis.com/v4/accounts/'+accountidForGetLocations+'/locations/'+locationidForGetReviews+'/reviews/'+reviewidForPutReply+'/reply';
		Map<String, String> header = new Map<String, String>{
			'Authorization' => 'Bearer ' + accessToken,
			'Content-Type' => 'application/json'
		};
		String body = '{\n' +
			'  "comment" : "'+commentForPutReply+'",\n' +

			'}';


//		AHttpResponse response = GooglePUTreplyService.putGoogleReply(accountidForGetLocations, locationidForGetReviews, reviewidForPutReply, commentForPutReply);
//
//		putReplyRequestString = method + ' ' + endpoint;
//		putReplyResponseBodyJson = response.getBody();
		return null;
	}

	 */

	public PageReference getCalendars() {
		String method = 'GET';
		String endpoint = 'https://www.googleapis.com/calendar/v3/users/me/calendarList';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = method;
		inp.endpoint = endpoint;
		inp.headerKey1 = 'Authorization';
		inp.headerValue1 = 'Bearer '+accessToken;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		System.debug('getCalendars returns: '+returns);

		getCalendarsRequestString = method + ' ' + endpoint;
		getCalendarsResponseBodyJson = returns[0].responseBody;

		Map<String, Object> calendarsMap = (Map<String, Object>) JSON.deserializeUntyped(getCalendarsResponseBodyJson);
		System.debug('calendarsMap: '+calendarsMap);
		Object[] items = (List<Object>) calendarsMap.get('items');
		System.debug('items: '+items);
		calendarItems = new List<CalendarItem>();
		if (items!=null && !items.isEmpty())
		for (Object item: items) {
			Map<String, Object> itemMap = (Map<String, Object>) item;
			System.debug('itemMap: '+itemMap);
			CalendarItem calItem = new CalendarItem();
			if (itemMap.containsKey('id')) calItem.id = itemMap.get('id').toString();
			if (itemMap.containsKey('summary')) calItem.summary = itemMap.get('summary').toString();
			if (itemMap.containsKey('description')) calItem.description = itemMap.get('description').toString();
			if (itemMap.containsKey('timeZone')) calItem.timeZone = itemMap.get('timeZone').toString();
			System.debug('calItem: '+calItem);
			calendarItems.add(calItem);
		}
		System.debug('calendarItems: '+calendarItems);

		return null;
	}

	public List<Map<String, Object>> filesMapsList {get; set;}

	public PageReference getDriveFilesList() {
		String method = 'GET';
		String endpoint = 'https://www.googleapis.com/drive/v3/files';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = method;
		inp.endpoint = endpoint;
		inp.headerKey1 = 'Authorization';
		inp.headerValue1 = 'Bearer '+accessToken;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		//System.debug('getDriveFilesList returns: '+returns);

		getDriveFilesListRequestString = method + ' ' + endpoint;
		getDriveFilesListResponseBodyJson = returns[0].responseBody;
		//System.debug('getDriveFilesList getDriveFilesListResponseBodyJson: '+getDriveFilesListResponseBodyJson);

		Map<String, Object> driveFilesListMap = (Map<String, Object>) JSON.deserializeUntyped(getDriveFilesListResponseBodyJson);
		Object[] filesList = (List<Object>) driveFilesListMap.get('files');
		filesMapsList = new List<Map<String, Object>>();
		if (filesList!=null && !filesList.isEmpty())
		for (Object fileObj: filesList) {
			Map<String, Object> fileMap = (Map<String, Object>) fileObj;
			filesMapsList.add(fileMap);
		}
		System.debug('filesMapsList: '+filesMapsList); // filesMapsList: ({id=1YE...tt8, kind=drive#file, mimeType=application/vnd.google-apps.spreadsheet, name=Waldorf Bál 2025},

		return null;
	}

	public PageReference getLastEmails() {
		String method = 'GET';
		String endpoint = 'https://gmail.googleapis.com/gmail/v1/users/me/messages';
		String endpointParameters = '?maxResults=5';

		HttpCalloutController.InputParams inp = new HttpCalloutController.InputParams();
		inp.method = method;
		inp.endpoint = endpoint + endpointParameters;
		inp.headerKey1 = 'Authorization';
		inp.headerValue1 = 'Bearer '+accessToken;
		HttpCalloutController.OutputParams[] returns = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inp});
		//System.debug('getLastEmails returns: '+returns);

		getLastEmailsRequestString = method + ' ' + endpoint;
		getLastEmailsResponseBodyJson = returns[0].responseBody;
		System.debug('getLastEmails getLastEmailsResponseBodyJson: '+getLastEmailsResponseBodyJson); // {"messages": [{"id": "1950e5bf4741a740","threadId": "1950e5bf4741a740"},{"id": "1950e4a81bef84a4","threadId": "1950e4a81bef84a4"},

		return null;
	}
}
