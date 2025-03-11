/**
 * Created by Harmath Zsolt on 2025. 02. 08.
 */

// numberToWordsConverter.js
import { LightningElement, track } from 'lwc';

export default class NumberToWordsConverter extends LightningElement {
	@track number;
	@track wordRepresentation;

	unitsTensTeens = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
	tens = ['', 'Ten', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

	handleNumberChange(event) {
		this.number = event.target.value;
		this.wordRepresentation = this.convertNumberToText(this.number);
	}

	convertNumberToText(n) {
		if (!n) {
			return '';
		}
		let integerValue = parseInt(n);
		if (integerValue === 0) {
			return 'Zero';
		}
		let textRepresentation = '';
		if (integerValue >= 1000000) {
			textRepresentation += this.convertNumberToText(Math.floor(integerValue / 1000000)) + ' Million ';
			integerValue %= 1000000;
		}
		if (integerValue >= 1000) {
			textRepresentation += this.convertNumberToText(Math.floor(integerValue / 1000)) + ' Thousand ';
			integerValue %= 1000;
		}
		if (integerValue >= 100) {
			textRepresentation += this.unitsTensTeens[Math.floor(integerValue / 100)] + ' Hundred ';
			integerValue %= 100;
		}
		if (integerValue >= 20) {
			textRepresentation += this.tens[Math.floor(integerValue / 10)] + ' ';
			integerValue %= 10;
		}
		if (integerValue > 0) {
			textRepresentation += this.unitsTensTeens[integerValue];
		}
		return textRepresentation.trim();
	}
}

