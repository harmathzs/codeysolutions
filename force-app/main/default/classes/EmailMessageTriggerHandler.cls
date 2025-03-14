/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

public with sharing class EmailMessageTriggerHandler implements ITriggerExecutable {
	public void execute(TriggerContext context) {
		if (context.beforeInsert()) {
			handleBeforeInsert(context);
		} else if (context.afterInsert()) {
			handleAfterInsert(context);
		} else if (context.afterUpdate()) {
			handleAfterUpdate(context);
		}
	}

	private void handleBeforeInsert(TriggerContext context) {
		List<SObject> records = context.getRecords();
		EmailMessage[] mails = new List<EmailMessage>();
		for (SObject record : records) {
			EmailMessage mail = (EmailMessage)record;
			// Handle before insert logic
			//System.debug('mail before insert: '+mail);
			mails.add(mail);
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
	}

	private void handleAfterUpdate(TriggerContext context) {
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
				,(SELECT Id, CreatedDate, Subject, TextBody, HtmlBody FROM EmailMessages ORDER BY CreatedDate ASC )
			FROM Case
			WHERE Id IN :caseIds
		];

		for (Case c: cases) {
			c.Email_Thread__c = '';
			for (Integer i=0; i<c.EmailMessages.size(); i++) {
				EmailMessage mail = c.EmailMessages[i];
				System.debug('Populating Email_Thread__c for EmailMessage; id= '+mail.Id);

				c.Email_Thread__c += ' Email '+(i+1)+': ';
				c.Email_Thread__c += ' CreatedDate: '+String.valueOf(mail.CreatedDate);
				c.Email_Thread__c += ' Subject: '+mail.Subject;

				if (String.isNotBlank(mail.TextBody)) c.Email_Thread__c += ' TextBody: '+mail.TextBody;
				else c.Email_Thread__c += ' HtmlBody: '+mail.HtmlBody;
			}
		}

		update cases;
	}
}
