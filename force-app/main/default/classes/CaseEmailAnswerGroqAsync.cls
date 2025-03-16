/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

public with sharing class CaseEmailAnswerGroqAsync implements Queueable, Database.AllowsCallouts {
	public Integer threadStrLimit = 16000;

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
				,Product__c
				,Description
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
			String cutThreadStr = (c.Email_Thread__c.length()<threadStrLimit) ? c.Email_Thread__c : c.Email_Thread__c.substring(0, threadStrLimit);

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
			// {
			//  "statusText" : "OK",
			//  "statusCode" : 200,
			//  "responseBody" : "{\"id\":\"chatcmpl-4d43c04e-d7de-49f3-a908-8e1d08581c20\",\"object\":\"chat.completion\",\"created\":1741960145,\"model\":\"deepseek-r1-distill-llama-70b\",\"choices\":[{\"index\":0,\"message\":{\"role\":\"assistant\",\"content\":\"\\u003cthink\\u003e\\nOkay, I need to help the user by creating a response email based on the provided email thread. The user is a Salesforce service rep for Codey Solutions, and they want to express excitement about working on the case and closing it. The tone needs to be friendly and enthusiastic.\\n\\nLooking at the email thread, the customer, Zsolt Harmath, initially had a problem with a board he purchased, which was broken. The service rep offered assistance, and Zsolt then asked about buying a new vacuum cleaner. Now, the service rep needs to respond to that inquiry.\\n\\nI should start by thanking Zsolt for considering Codey Solutions. Then, express excitement about helping him find the right vacuum cleaner. It's important to mention that they'll provide personalized suggestions. Also, I should acknowledge his previous issue and reassure him that the team is on it. Finally, encourage him to reply with more details about his cleaning needs.\\n\\nI need to make sure the email is upbeat and positive, showing eagerness to assist. Also, include placeholders for personalization, like the customer's first name and the rep's name. The subject line should reference the case number and express excitement.\\n\\nI should structure the email with a friendly greeting, a thank you, an offer to help, a mention of the previous issue, and a call to action for more details. Keep each section concise and enthusiastic.\\n\\nNow, putting it all together, ensuring the tone matches the requirements and all key points are addressed.\\n\\u003c/think\\u003e\\n\\nSubject: Re: ESCALATED CASE 00001030 [ thread::JHAU84ApDSCYj8suAT_vYTQ:: ] - Let's Solve This Together! 🚀\\n\\nHi Zsolt,\\n\\nThank you so much for considering Codey Solutions for your new vacuum cleaner! I’m super excited to help you find the perfect product to make your home cleaner and your life easier. 😊\\n\\nI understand you’ve had some issues with a previous purchase, and I want to assure you that we’re working hard to resolve that for you. Your satisfaction is our top priority, and I’m here to make sure everything gets back on track.\\n\\nLet’s focus on finding you the best vacuum cleaner for your needs. Could you share a bit more about what you're looking for? For example, do you have any specific features in mind or preferences for the type of vacuum?\\n\\nLooking forward to hearing from you and helping you get the cleanest home on the block! 🎯\\n\\nBest regards,  \\n[Your Name]  \\nCustomer Success Representative  \\nCodey Solutions\"},\"logprobs\":null,\"finish_reason\":\"stop\"}],\"usage\":{\"queue_time\":0.20127035699999998,\"prompt_tokens\":740,\"prompt_time\":0.07157021,\"completion_tokens\":524,\"completion_time\":1.905454545,\"total_tokens\":1264,\"total_time\":1.977024755},\"system_fingerprint\":\"fp_c1494dd356\",\"x_groq\":{\"id\":\"req_01jpaemsy6e779dh9npazpg5az\"}}\n",
			//  "errorMessage" : null
			//}

			Map<String, Object> mainMap = (Map<String, Object>) JSON.deserializeUntyped(aiAnswer);
			System.debug('mainMap: '+mainMap);
			String errorMessage = String.valueOf(mainMap.get('errorMessage'));
			System.debug('errorMessage: '+errorMessage);
			if (String.isBlank(errorMessage) || errorMessage.contains('null')) {
				String responseBodyJson = String.valueOf(mainMap.get('responseBody'));
				System.debug('responseBodyJson: '+responseBodyJson);
				Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(responseBodyJson);
				System.debug('responseBody: '+responseBody);
				Object[] choices = (List<Object>) responseBody.get('choices');
				System.debug('choices: '+choices);
				Map<String, Object> choice = (Map<String, Object>) choices[0];
				System.debug('choice: '+choice);
				Map<String, Object> message = (Map<String, Object>) choice.get('message');
				System.debug('message: '+message);
				String content = String.valueOf(message.get('content'));
				System.debug('content: '+content);
				c.Email_Answer_on_Thread_AI_by_Groq__c = content;
			} else {
				c.Email_Answer_on_Thread_AI_by_Groq__c = errorMessage;
			}
		}

		update cases;
	}
}
