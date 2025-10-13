/**
 * Created by User on 2025. 10. 13.
 */

public with sharing class QuoteProductsService {
	public Quote quote {get; set;}

	public QuoteProductsService(ApexPages.StandardController stdController) {
		quote = (Quote) stdController.getRecord();
	}
}
