/**
 * Created by User on 2025. 10. 13..
 */

@IsTest
private class QuoteProductsTest {
	@TestSetup static void testFactory() {
		Product2 prod = new Product2(
			Name = 'Test Product'
		);
		insert prod;

		PricebookEntry pbe = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			IsActive = true,
			Product2Id = prod.Id,
			UnitPrice = 1
		);
		insert pbe;

		Opportunity oppy = new Opportunity(
			Name = 'Test Oppy',
			StageName = 'Closed Won',
			CloseDate = Date.today()
		);
		insert oppy;

		Quote quote = new Quote(
			Name = 'Test Quote',
			OpportunityId = oppy.Id,
			Pricebook2Id = Test.getStandardPricebookId()
		);
		insert quote;

		QuoteLineItem qli = new QuoteLineItem(
			QuoteId=quote.Id,
			Product2Id = prod.Id,
			PricebookEntryId = pbe.Id,
			Quantity=1,
			UnitPrice=1
		);
		insert qli;
	}

	@IsTest
	static void testQuote() {
		Quote quote = [SELECT Id FROM Quote LIMIT 1];

		ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
		QuoteProductsService controller = new QuoteProductsService(stdController);
	}

	@IsTest
	static void testQLI() {
		QuoteLineItem qli = [SELECT Id, QuoteId FROM QuoteLineItem LIMIT 1];
		Quote quote = [SELECT Id FROM Quote WHERE Id=:qli.QuoteId];

		ApexPages.StandardController stdController = new ApexPages.StandardController(quote);
		ApexPages.currentPage().getParameters().put('qliid', qli.Id);
		QuoteProductsService controller = new QuoteProductsService(stdController);
	}
}
