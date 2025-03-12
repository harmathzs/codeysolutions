/**
 * Created by Harmath Zsolt on 2025. 03. 12..
 */

public class AccountTriggerHandler implements ITriggerExecutable {
	public void execute(TriggerContext context) {
		if (context.beforeInsert()) {
			handleBeforeInsert(context);
		} else if (context.afterUpdate()) {
			handleAfterUpdate(context);
		}
	}

	private void handleBeforeInsert(TriggerContext context) {
		List<SObject> records = context.getRecords();
		for (SObject record : records) {
			Account acc = (Account)record;
			// Handle before insert logic
			System.debug('acc before insert: '+acc);
		}
	}

	private void handleAfterUpdate(TriggerContext context) {
		// In synchronous mode
		if (!context.isAsyncMode) {
			List<SObject> records = context.getRecords();
			// Process records
		}
		// In asynchronous mode
		else {
			Set<Id> recordIds = context.getRecordIds();
			// Process record IDs
		}
	}
}
