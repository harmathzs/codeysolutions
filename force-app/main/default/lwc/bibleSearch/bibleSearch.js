/**
 * Created by User on 2025. 07. 18.
 */

import {LightningElement} from 'lwc';
import getBibleComCustomSettings from '@salesforce/apex/BibleController.getBibleComCustomSettings';

export default class BibleSearch extends LightningElement {
	BibleComCustomSettings;

	async connectedCallback() {
		this.BibleComCustomSettings = await getBibleComCustomSettings();
		console.log('BibleComCustomSettings', this.BibleComCustomSettings);
	}
}
