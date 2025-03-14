/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

import {LightningElement, api} from 'lwc';
import calloutToGroq from '@salesforce/apex/AiChatController.calloutToGroq';

export default class AiAnswerer extends LightningElement {
	@api question;
	@api answer;

	conversation = {
		model: 'deepseek-r1-distill-llama-70b',
		messages: [],
	};

	connectedCallback() {
		if (this.question) {
			console.log('question', this.question);

			this.conversation.messages.push({
				role: 'user',
				content: this.question,
			});
			const conversationJSON = JSON.stringify(this.conversation);
			let outputParams = calloutToGroq({requestBodyJSON: conversationJSON});
			console.log('calloutToGroq outputParams', outputParams);
			const outputParamsObj = JSON.parse(outputParams);
			const responseBody = outputParamsObj?.responseBody;
			console.log('calloutToGroq responseBody', responseBody);
			const responseObj = JSON.parse(responseBody);
			console.log('calloutToGroq responseObj', JSON.stringify(responseObj));
			const choices = responseObj?.choices;
			console.log('calloutToGroq choices', JSON.stringify(choices));
			for (let choice of choices) {
				this.answer = choice?.message;
				console.log('calloutToGroq answer', JSON.stringify(this.answer));
			}
			console.log('Final answer: ', JSON.stringify(this.answer));
		}
	}
}
