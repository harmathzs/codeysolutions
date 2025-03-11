/**
 * Created by Harmath Zsolt on 2025. 02. 10.
 */

import {LightningElement} from 'lwc';
import calloutToGroq from '@salesforce/apex/AiChatController.calloutToGroq';

export default class AiChat extends LightningElement {
	question;
	conversation = {
		model: 'deepseek-r1-distill-llama-70b',
		messages: [],
	};

	get messages() {
		return [...this.conversation?.messages];
	}

	isLoading = false;

	handleInputChange(event) {
		//console.log('handleInputChange event', event);
		this.question = event?.detail?.value;
		//console.log('handleInputChange question', this.question);
	}

	handleSendClick(event) {
		console.log('handleSendClick event', event);

		this.isLoading = true;

		this.conversation.messages.push({
			role: 'user',
			content: this.question,
		});
		const conversationJSON = JSON.stringify(this.conversation);

		calloutToGroq({requestBodyJSON: conversationJSON})
			.then(outputParams => {
				console.log('calloutToGroq outputParams', outputParams); // {"statusText" : "OK","statusCode" : 200,"responseBody" : "{\"id\":
				const outputParamsObj = JSON.parse(outputParams);
				//console.log('calloutToGroq outputParamsObj', JSON.stringify(outputParamsObj));

				const statusCode = +outputParamsObj?.statusCode;
				const statusText = outputParamsObj?.statusText;
				const responseBody = outputParamsObj?.responseBody;
				const errorMessage = outputParamsObj?.errorMessage;

				console.log('calloutToGroq statusCode', statusCode); // 200
				console.log('calloutToGroq statusText', statusText); // OK
				console.log('calloutToGroq responseBody', responseBody); // {"id":"chatcmpl-f16b0693-df32-44e4-a34f-0a029e91368a","object":"chat.completion","created":1739268208,"model":"deepseek-r1-distill-llama-70b","choices":[{"index":0,"message":{"role":"assistant","content":
				console.log('calloutToGroq errorMessage', errorMessage); // null

				const responseObj = JSON.parse(responseBody);
				console.log('calloutToGroq responseObj', JSON.stringify(responseObj)); // {"id":"chatcmpl-f16b0693-df32-44e4-a34f-0a029e91368a","object":"chat.completion","created":1739268208,"model":"deepseek-r1-distill-llama-70b","choices":[{"index":0,"message":{"role":"assistant","content":
				// TODO - merge answer into conversation
				const choices = responseObj?.choices;
				console.log('calloutToGroq choices', JSON.stringify(choices)); // [{"index":0,"message":{"role":"assistant","content":

				for (let choice of choices) {
					const message = choice?.message;
					console.log('calloutToGroq message', JSON.stringify(message));

					this.conversation.messages.push({...message});
					console.log('calloutToGroq conversation', JSON.stringify(this.conversation));
				}


			})
			.catch(err => console.log(err))
			.finally(() => {
				this.isLoading = false;
			});
	}

	handleResetClick(event) {
		console.log('handleResetClick event', event);

		this.conversation = {
			model: 'deepseek-r1-distill-llama-70b',
			messages: [],
		};
		this.question = null;
	}

	handleKeyPress(event) {
		//console.log('handleKeyPress event', event);
		if (event?.key == 'Enter') {
			console.log('handleKeyPress key', event?.key);
			this.handleSendClick(event);
		}
	}
}
