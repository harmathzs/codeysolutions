/**
 * Created by Harmath Zsolt on 2025. 03. 25..
 */

public without sharing class AccountFlowLauncherBatch implements Database.Batchable<SObject>, Schedulable, Database.AllowsCallouts {
	public List<Map<String, Object>> flowOutputsList = new List<Map<String, Object>>();

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
		System.debug('accounts.size: '+accounts.size());
		for (Account account: accounts) {
			Map<String, Object> flowInputs = new Map<String, Object>{
				'recordId' => account.Id  // flow has an input variable named 'recordId'
			};

			Flow.Interview flow = Flow.Interview.createInterview('Autolaunched_Flow_Account_Updater_Manually', flowInputs);
			flow.start();

			Map<String, Object> flowOutputs = new Map<String, Object>{
				'recordId' => flow.getVariableValue('recordId'),
				'flowFaultMessage' => flow.getVariableValue('flowFaultMessage')
			};
			flowOutputsList.add(flowOutputs);
		}
	}

	public void finish(Database.BatchableContext context) {
		System.debug('flowOutputsList:');
		System.debug(flowOutputsList);
	}
}
