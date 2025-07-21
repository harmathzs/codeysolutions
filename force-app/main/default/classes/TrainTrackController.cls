public without sharing class TrainTrackController {
	public String getTrainInfoContent {
		get {
			return 'TODO - VF train info';
		}
	}

	@AuraEnabled
	public static String fetchTrainGzip(String url) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		Http http = new Http();
		HttpResponse res = http.send(req);

		Blob gzipped = res.getBodyAsBlob();
		// ⚠️ Apex nem támogatja gunzip-et natívan → alap blobként küldheted csak vissza
		return EncodingUtil.base64Encode(gzipped);
	}
}
