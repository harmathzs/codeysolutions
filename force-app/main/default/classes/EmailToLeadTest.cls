/**
 * Created by User on 2025. 11. 04..
 */

@IsTest
private class EmailToLeadTest {
	@IsTest static void testHandleInboundEmail() {
		// Create a mock inbound email message
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		email.fromAddress = 'testsender@example.com';
		email.subject = 'Test Lead Creation';
		email.plainTextBody = 'This is a test email body';

		// Add sample attachment (optional)
		Messaging.InboundEmail.BinaryAttachment binAttachment = new Messaging.InboundEmail.BinaryAttachment();
		binAttachment.fileName = 'testfile.txt';
		binAttachment.body = Blob.valueOf('Sample attachment body');
		email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { binAttachment };

		// Create inbound envelope (can be empty for testing)
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

		// Instantiate your Email Handler class
		EmailToLeadHandler handler = new EmailToLeadHandler();

		// Call handleInboundEmail method
		Messaging.InboundEmailResult result = handler.handleInboundEmail(email, env);

		// Verify method succeeded
		System.assert(result.success, 'Email handler should succeed');

		// Verify a Lead was created with expected values
		Lead[] leads = [SELECT Id, Email, LastName, Company, Description, Title FROM Lead WHERE Email = :email.fromAddress];
		System.assertEquals(1, leads.size(), 'One Lead should be created');
		Lead createdLead = leads[0];
		System.assertEquals('testsender@example.com', createdLead.Email);
		System.assertEquals('testsender', createdLead.LastName); // Assuming extractLastNameFromEmail logic
		System.assertEquals('Unknown', createdLead.Company);
		System.assertEquals(email.plainTextBody, createdLead.Description);
		System.assertEquals(email.subject, createdLead.Title);

		// Optionally check attachments linked to Lead
		Attachment[] attachments = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :createdLead.Id];
		System.assertEquals(1, attachments.size(), 'One attachment should be linked to the Lead');
		System.assertEquals('testfile.txt', attachments[0].Name);
	}
}
