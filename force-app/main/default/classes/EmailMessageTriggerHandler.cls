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

		// Populate Case.Email Thread field from Case.EmailMessages:
		populateCaseEmailThread(mails);
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
		CaseEmailAnswerGroqAsync queueable = new CaseEmailAnswerGroqAsync(mails);
		System.enqueueJob(queueable);
	}
}
