/**
 * EmailToLeadHandler
 *
 * @author Zsolt Harmath
 * @description Email-to-Lead Apex handler class for Email Services
 * @date 2025-11-04
 */
public with sharing class EmailToLeadHandler implements Messaging.InboundEmailHandler {
	/**
	 * handleInboundEmail()
	 *
	 * @author Zsolt Harmath
	 * @description Email-to-Lead handler method
	 * @date 2025-11-04
	 * @param email InboundEmail
	 * @param envelope InboundEnvelope
	 * @return InboundEmailResult
	 */
	public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

		try {
			// Check if lead with sender's email already exists
			Lead[] existingLeads = [SELECT Id FROM Lead WHERE Email = :email.fromAddress LIMIT 1];

			if (existingLeads.isEmpty()) {
				// Create new Lead with more dynamic info
				Lead newLead = new Lead();
				newLead.Email = email.fromAddress;
				newLead.LastName = extractLastNameFromEmail(email.fromAddress);
				newLead.Company = 'Unknown'; // TODO - Replace if you parse company from email

				// Optionally map other fields from email
				if (email.subject != null) {
					newLead.Title = email.subject;
				}
				if (email.plainTextBody != null) {
					newLead.Description = email.plainTextBody;
				}

				insert newLead;

				// Process and save attachments
				List<Attachment> attachmentsToInsert = new List<Attachment>();
				if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
					for (Messaging.InboundEmail.BinaryAttachment bAttachment : email.binaryAttachments) {
						Attachment att = new Attachment();
						att.ParentId = newLead.Id;
						att.Name = bAttachment.fileName;
						att.Body = bAttachment.body;
						attachmentsToInsert.add(att);
					}
				}
				if (email.textAttachments != null && email.textAttachments.size() > 0) {
					for (Messaging.InboundEmail.TextAttachment tAttachment : email.textAttachments) {
						Attachment att = new Attachment();
						att.ParentId = newLead.Id;
						att.Name = tAttachment.fileName;
						att.Body = Blob.valueOf(tAttachment.body);
						attachmentsToInsert.add(att);
					}
				}
				if (!attachmentsToInsert.isEmpty()) {
					insert attachmentsToInsert;
				}

				System.debug('Created new lead and saved attachments: ' + newLead);
			} else {
				System.debug('Duplicate lead found for email: ' + email.fromAddress);
			}

			result.success = true;

		} catch (Exception e) {
			System.debug('Error processing inbound email: ' + e.getMessage());
			result.success = false;
		}

		return result;
	}

	private String extractLastNameFromEmail(String emailAddress) {
		if (emailAddress != null && emailAddress.contains('@')) {
			return emailAddress.substringBefore('@');
		}
		return 'Unknown';
	}
}
