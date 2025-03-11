/**
 * Created by Harmath Zsolt on 2024. 08. 26.
 */

import { LightningElement, api, wire } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';

export default class NumberInputWithSpaceSeparator extends LightningElement {
	@wire(getRecord, { recordId: USER_ID, fields: ['User.Name', 'User.LanguageLocaleKey', 'User.LocaleSidKey'] })
	userDetails;

	@api value;
	@api name;
	@api label;
	@api numericValue;
	@api language;
	@api separator;

	@api
	getNumericValue() {
		return this.numericValue;
	}

	get formattedValue() {
		console.log('userDetails.data', this.userDetails.data);
		const LocaleSidKey = this.userDetails.data?.fields?.LocaleSidKey?.value;
		console.log('LocaleSidKey', LocaleSidKey);

		const sep = ((this.language && this.language.toLowerCase().includes('hu')) || (LocaleSidKey && LocaleSidKey.toLowerCase().includes('hu'))) ? ' ' : ',';
		console.log('formattedValue, thousand separator character: "'+sep+'"')
		return this.formatNumber(this.value, sep);
	}

	formatNumber(num, sep=' ') {
		console.log('formatNumber num', num);
		if (num === undefined || num === null) return '';

		// Távolítsuk el az esetleges szóközöket a számból
		const cleanedNum = num.toString().replace(/\s+/g, '').replace(',', '');
		console.log('formatNumber cleanedNum', cleanedNum);

		// Kettéválasztjuk az egész részt és a tizedes részt (ha van)
		const [integerPart, decimalPart] = cleanedNum.split('.');
		console.log('formatNumber integerPart', integerPart);
		console.log('formatNumber decimalPart', decimalPart);

		// Formázzuk az egész részt ezres elválasztással
		const formattedInteger = integerPart.replace(/\B(?=(\d{3})+(?!\d))/g, sep);
		console.log('formatNumber formattedInteger', formattedInteger);

		// Ha van tizedesjegy, hozzácsatoljuk
		const formattedNumber = decimalPart ? `${formattedInteger},${decimalPart}` : formattedInteger;
		console.log('formatNumber formatted', formattedNumber);
		return formattedNumber;
	}

	handleInput(event) {
		let inputValue = event.target.value.replace(/\s/g, '');
		console.log('handleInput inputValue 1', inputValue);
		inputValue = inputValue.replace(',', '');
		console.log('handleInput inputValue 2', inputValue);

		this.numericValue = parseFloat(inputValue);

		if (!isNaN(this.numericValue)) {
			this.value = this.numericValue;
			this.dispatchEvent(new CustomEvent('change', {
				detail: {
					name: this.name,
					value: this.numericValue,
					numericValue: this.numericValue
				}
			}));
		}
	}

	@api
	reportValidity() {
		return this.template.querySelector('lightning-input').reportValidity();
	}
}
