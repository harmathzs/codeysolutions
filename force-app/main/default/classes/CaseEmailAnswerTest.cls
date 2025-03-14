/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

@IsTest
private class CaseEmailAnswerTest {
	@IsTest
	static void testBehavior() {
		Case c = new Case(
			Reason = 'Other',
			Description = 'Test'
		);
		insert c;

		EmailMessage mail = new EmailMessage(
			FromId = UserInfo.getUserId(),
			ToAddress = 'test@testtest.tst',
			Subject = 'Test',
			TextBody = 'Test',

			ParentId = c.Id
		);
		EmailMessage[] mails = new List<EmailMessage>{mail};

		Test.startTest();
		insert mails;
		Test.stopTest();
	}
}
