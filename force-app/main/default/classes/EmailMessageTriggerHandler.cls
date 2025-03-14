/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

public with sharing class EmailMessageTriggerHandler implements ITriggerExecutable {
	public void execute(TriggerContext context) {
		if (context.beforeInsert()) {
			handleBeforeInsert(context);
		} else if (context.afterInsert()) {
			handleAfterInsert(context);
		}
	}

	private void handleBeforeInsert(TriggerContext context) {
		List<SObject> records = context.getRecords();
		for (SObject record : records) {
			EmailMessage mail = (EmailMessage)record;
			// Handle before insert logic
			System.debug('mail before insert: '+mail);
		}
	}

	private void handleAfterInsert(TriggerContext context) {
		List<SObject> records = context.getRecords();
		EmailMessage[] mails = new List<EmailMessage>();
		for (SObject record : records) {
			EmailMessage mail = (EmailMessage)record;
			// Handle after insert logic
			//System.debug('mail after insert: '+mail);
			mails.add(mail);
		}

		// Populate Case.Email Thread field from Case.EmailMessages:
		populateCaseEmailThread(mails);
	}

	public void populateCaseEmailThread(EmailMessage[] mails) {
		Set<String> caseIds = new Set<String>();
		for (EmailMessage mail: mails) if (String.isNotBlank(mail.ParentId)) caseIds.add(mail.ParentId);

		Case[] cases = [
			SELECT Id
				,CaseNumber
				,Email_Thread__c
				,(SELECT Id, Subject, TextBody, HtmlBody FROM EmailMessages)
			FROM Case
			WHERE Id IN :caseIds
		];


	}
}
