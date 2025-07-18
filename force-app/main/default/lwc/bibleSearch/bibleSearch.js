/**
 * Created by User on 2025. 07. 18.
 */

import {LightningElement} from 'lwc';
import getBibleComCustomSettings from '@salesforce/apex/BibleController.getBibleComCustomSettings';
import getBibleComCustomMetadata from '@salesforce/apex/BibleController.getBibleComCustomMetadata';

export default class BibleSearch extends LightningElement {
	BibleComCustomSettings;
	BibleComCustomMetadata;
	BibleComApiKey;

	BibleContent;

	passage = 'John3.16';

	async connectedCallback() {
		//this.BibleComCustomSettings = await getBibleComCustomSettings();
		//console.log('BibleComCustomSettings', this.BibleComCustomSettings);

		this.BibleComCustomMetadata = await getBibleComCustomMetadata();
		//console.log('BibleComCustomMetadata', this.BibleComCustomMetadata);

		this.BibleComApiKey = this.BibleComCustomMetadata?.Bible_com_API_key?.API_Key__c;

		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}

	handlePassageChange(e) {
		this.passage = e.detail.value;
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}

	showBibleContent(bibleId, passage, key) {
		fetch('https://api.biblia.com/v1/bible/content/' + bibleId + '.html?passage=' + passage + '&key=' + key)
			.then(res => res.text()).then(text => this.BibleContent = text)
			.catch(error => this.BibleContent = error);
	}

	handleLuke23_13_25_ButtonClick() {
		this.passage = 'Luke23.13-25';
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}
	handle_1_Kings_19_ButtonClick() {
		this.passage = '1 Kings 19';
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}
	handleGenesis_1_ButtonClick() {
		this.passage = 'Genesis 1';
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}
	handleIsaiah_9_1_3_ButtonClick() {
		this.passage = 'Isaiah.9.1-3';
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}
	handleMarkButtonClick() {
		this.passage = 'Mark';
		this.showBibleContent('kjv', this.passage, this.BibleComApiKey);
	}
}
