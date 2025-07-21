public without sharing class TrainTrackController {
	public String numberStr {get; set;}

	public TrainTrackController() {
		if (ApexPages.currentPage().getParameters().containsKey('number')) {
			numberStr = ApexPages.currentPage().getParameters().get('number');
		}
	}

	public String getTrainInfoContent {
		get {
			String fileUrl = 'https://bucket.traintrack.hu/trainstore/'+numberStr+'.json.gz';
			String fetchedTrainGzip = TrainTrackController.fetchTrainGzip(fileUrl);
			return fetchedTrainGzip; // H4sIAAAAAAACA8S9z28bSbYu+K8IGmBWkhG/I7J...
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
