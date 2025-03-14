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
		for (SObject record : records) {
			EmailMessage mail = (EmailMessage)record;
			// Handle after insert logic
			System.debug('mail after insert: '+mail);
		}
	}
}
