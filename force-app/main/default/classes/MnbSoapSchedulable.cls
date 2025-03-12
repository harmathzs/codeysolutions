/**
 * Created by Harmath Zsolt on 2025. 02. 18.
 */

public with sharing class MnbSoapSchedulable implements Schedulable, Database.AllowsCallouts {
	public void execute(SchedulableContext context) {
		MnbSoapAsync asyncInstance = new MnbSoapAsync();
		String jobId = System.enqueueJob(asyncInstance);
		System.debug('MnbSoapSchedulable jobId: '+jobId);
	}
}
