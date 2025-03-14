/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

public with sharing class CaseEmailAnswerGroqAsync implements Queueable, Database.AllowsCallouts {
	public EmailMessage[] mails {get; set;}

	public CaseEmailAnswerGroqAsync(EmailMessage[] mails) {
		this.mails = mails;
	}

	public void execute(QueueableContext context) {
		Set<String> caseIds = new Set<String>();
		for (EmailMessage mail: mails) if (String.isNotBlank(mail.ParentId)) caseIds.add(mail.ParentId);

		Case[] cases = [
			SELECT Id
				,CaseNumber
				,Email_Thread__c
				,(SELECT Id, CreatedDate, Subject, TextBody, HtmlBody FROM EmailMessages ORDER BY CreatedDate DESC )
			FROM Case
			WHERE Id IN :caseIds
		];

		for (Case c: cases) {
			c.Email_Thread__c = '';
			for (Integer i=0; i<c.EmailMessages.size(); i++) {
				EmailMessage mail = c.EmailMessages[i];
				System.debug('Populating Email_Thread__c for EmailMessage; id= '+mail.Id);

					c.Email_Thread__c += ' Email ' + (c.EmailMessages.size() - i + 1) + ': ';
					c.Email_Thread__c += ' CreatedDate: ' + String.valueOf(mail.CreatedDate);
					c.Email_Thread__c += ' Subject: ' + mail.Subject;

					if (String.isNotBlank(mail.TextBody)) c.Email_Thread__c += ' TextBody: ' + mail.TextBody;
					else c.Email_Thread__c += ' HtmlBody: ' + mail.HtmlBody;
			}


			c.Email_Thread__c = c.Email_Thread__c.replace('"', ' ').replace('\n', ' ').replace('\'', ' ').replace('\\', ' ').replace('\t', '    ');
			String cutThreadStr = (c.Email_Thread__c.length()<2000) ? c.Email_Thread__c : c.Email_Thread__c.substring(0, 2000);

			String questionStr = 'As a Salesforce service rep for Codey Solutions, check all EmailMessages for this Case. Express your excitement to discuss and work on solving and closing the case. Use a friendly and enthusiastic tone. Create an answer email for the case which can be sent out back. Some recent emails of the previous existing email feed thread is here: '+cutThreadStr+' . ';
			//questionStr = 'What is the capital of France?'; // test question was

			String aiRequestJson = '{"model":"deepseek-r1-distill-llama-70b",' +
				'"messages":[{' +
				'"role":"user",' +
				'"content":"'+questionStr+'"' +
				'}]}';
			System.debug('aiRequestJson:');
			System.debug(aiRequestJson);
			String aiAnswer = AiChatController.calloutToGroq(aiRequestJson);
			System.debug('aiAnswer: '+aiAnswer);
		}

		update cases;
	}
}
