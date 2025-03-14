/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

@IsTest
private class EmailMessageTriggerTest {
	@IsTest
	static void testBehavior() {
		EmailMessage mail = new EmailMessage(
			FromId = UserInfo.getUserId(),
			ToAddress = 'test@testtest.tst',
			Subject = 'Test',
			TextBody = 'Test'
		);

		insert mail;
		update mail;
		delete mail;
		undelete mail;
	}
}
