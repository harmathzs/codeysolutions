/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

public without sharing class AccountFlowLauncherBatch implements Database.Batchable<SObject>, Schedulable, Database.AllowsCallouts {
	public void execute(SchedulableContext context) {
	}

	public Database.QueryLocator start(Database.BatchableContext context) {
		return null;
	}

	public void execute(Database.BatchableContext context, List<SObject> records) {
	}

	public void finish(Database.BatchableContext context) {
	}
}
