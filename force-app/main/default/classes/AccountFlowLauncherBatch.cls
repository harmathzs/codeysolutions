/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

public without sharing class AccountFlowLauncherBatch implements Database.Batchable<SObject>, Schedulable, Database.AllowsCallouts {
	public void execute(SchedulableContext context) {
		if (Test.isRunningTest()) Database.executeBatch(this, 1);
		else Database.executeBatch(this);
	}

	public Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator([
			SELECT Id
			FROM Account
			WHERE CreatedDate = THIS_MONTH
		]);
	}

	public void execute(Database.BatchableContext context, List<Account> accounts) {
		// TODO - launch "Autolaunched Flow - Account Updater Manually" Flow
	}

	public void finish(Database.BatchableContext context) {}
}
