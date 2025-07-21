public with sharing class ContinuationDemoController {
	public String myUniqueLabel; // unique label identifying the corresponding continuation process
	public String myResult {get; set;} // result of callout

	// callout endpoint as a web service url
	private static final String MY_ENDPOINT_URL = 'https://jsonplaceholder.typicode.com/todos/1';

	// action to invoke from Visualforce page
	public Object myAction() {
		// instantiate continuation with a timeout and set callback method
		Continuation con = new Continuation(40);
		con.continuationMethod = 'myCallbackMethod'; // Specify the callback method to invoke after the response is received from the App Server

		// create callout request
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(MY_ENDPOINT_URL);
		System.debug('endpoint: '+MY_ENDPOINT_URL);

		// add callout request
		this.myUniqueLabel = con.addHttpRequest(req);

		return con;
	}

	// the callback method
	public Object myCallbackMethod() {
		// get response by using the unique label
		HttpResponse response = Continuation.getResponse(this.myUniqueLabel);
		this.myResult = response.getBody();
		System.debug('myResult: '+myResult);

		// return null to re-render page
		return null;
	}
}
