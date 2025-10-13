/**
 * Created by User on 2025. 10. 13.
 */

public with sharing class QuoteProductsService {
	public Quote quote {get; set;}
	public Id qliId {get; set;}

	public QuoteProductsService(ApexPages.StandardController stdController) {
		quote = (Quote) stdController.getRecord();

		if (ApexPages.currentPage().getParameters().containsKey('qliid')) {
			qliId = ApexPages.currentPage().getParameters().get('qliid');
			QuoteLineItem qli = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id=:qliId];
			quote = [SELECT
				Id
				,Name
				,(SELECT Id, Product2Id, Product2.Name, Quantity, UnitPrice FROM QuoteLineItems)
			FROM Quote
			WHERE Id=:qli.QuoteId];
		}
	}
}
