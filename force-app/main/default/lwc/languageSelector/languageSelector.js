/**
 * Created by Harmath Zsolt on 2025. 02. 03.
 */

import {LightningElement, wire} from 'lwc';
import {getRecord, updateRecord, lockRecord} from "lightning/uiRecordApi";
import {CurrentPageReference} from 'lightning/navigation';
import userId from "@salesforce/user/Id";

import LWC_Select_new_language from '@salesforce/label/c.LWC_Select_new_language';

export default class LanguageSelector extends LightningElement {

	// Labels
	LWC_Select_new_language = LWC_Select_new_language;

	isProcessing = false;
	showLanguageSelector = true;

	selectedLanguage;
	languages = [
		{label: 'English', value: 'en_US', imgSrc:   `/flags/4x3/gb.svg`},
		{label: 'Magyar', value: 'hu_HU', imgSrc:   `/flags/4x3/hu.svg`},
		//{label: 'Čeština', value: 'cs', imgSrc:   `/flags/4x3/cz.svg`},
		//{label: 'Slovensko', value: 'sk', imgSrc:   `/flags/4x3/sk.svg`},
		//{label: 'Polski', value: 'pl', imgSrc:   `/flags/4x3/pl.svg`},
		//{label: 'deutsch', value: 'de', imgSrc:   `/flags/4x3/at.svg`},
		//{label: 'Română', value: 'ro', imgSrc:   `/flags/4x3/ro.svg`},
		//{label: 'Српски', value: 'sr', imgSrc:   `/flags/4x3/rs.svg`},
		//{label: 'Slovene', value: 'sl', imgSrc:   `/flags/4x3/si.svg`},
	];

	@wire(getRecord, {recordId: userId, fields: ['User.LocaleSidKey', 'User.LanguageLocaleKey']})
	onLoad({data, error}) {
		if (data) {
			console.log('getRecord User data', data);
			this.selectedLanguage = data.fields?.LocaleSidKey?.value;
			console.log('getRecord LWC_Select_new_language', this.LWC_Select_new_language);
		}
		else if (error) {
			console.error(error);
		}
	}

	async handleLanguageChange(event) {
		try {
			this.isProcessing = true;
			this.selectedLanguage = event?.detail?.value;
			console.log(`this.selectedLanguage`, this.selectedLanguage);
			if(this.selectedLanguage=='en_US'){this.locale='en_US'};
			if(this.selectedLanguage=='hu_HU'){this.locale='hu'};
			//if(this.selectedLanguage=='sl'){this.locale='sl_SI'};
			//if(this.selectedLanguage=='pl'){this.locale='pl_PL'};
			await updateRecord({
				fields: {
					Id: userId,
					LanguageLocaleKey: this.locale,
					LocaleSidKey: this.selectedLanguage
				}
			});
			let href = new URL(location.href);
			href.searchParams.set('language', this.locale);
			location.href = href.toString();
		} catch (error) {
			console.error(error);
			//showErrorMessageInToast(this, error);
		}finally {
			this.isProcessing = false; // Hide spinner and overlay
		}
	}
}
