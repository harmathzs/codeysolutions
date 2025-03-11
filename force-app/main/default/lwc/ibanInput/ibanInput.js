/**
 * Created by Harmath Zsolt on 2025. 02. 08.
 */

import { LightningElement, api, wire} from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//import {countryCodes} from "c/countries";

import getIban from '@salesforce/apex/IbanInputController.getIban'

// import DXP_Incorrect_IBAN_length from '@salesforce/label/c.DXP_Incorrect_IBAN_length';
// import Cancel from '@salesforce/label/c.Cancel';
// import Next from '@salesforce/label/c.Next';
// import DXP_Country_Code_not_found_in_IBAN from '@salesforce/label/c.DXP_Country_Code_not_found_in_IBAN';
// import DXP_But_you_typed from '@salesforce/label/c.DXP_But_you_typed';
// import DXP_comma_Only from '@salesforce/label/c.DXP_comma_Only';

export default class IbanInput extends NavigationMixin(LightningElement) {

	@api existingIban;
	@api countryCode;
	@api isValid;
	@api iban;
	@api noSpacesIban;

	ibanLength;
	isIBANMandatory;
	showError = false;

	labels = {
		Cancel: 'Cancel',
		Next: 'Next'
	};
	DXP_But_you_typed = 'but you have typed';
	DXP_comma_Only = ')';

	ibanTable =
		[
			{"Country": "Albania", "Code": "AL", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "yes", "IBAN Example": "AL35202111090000000001234567"},
			{"Country": "Andorra", "Code": "AD", "SEPA": "Yes", "Length": 24, "Account Check": "", "Branch": "yes", "IBAN Example": "AD1400080001001234567890"},
			{"Country": "Austria", "Code": "AT", "SEPA": "Yes", "Length": 20, "Account Check": "yes", "Branch": "yes", "IBAN Example": "AT483200000012345864"},
			{"Country": "Azerbaijan", "Code": "AZ", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "AZ77VTBA00000000001234567890"},
			{"Country": "Bahrain", "Code": "BH", "SEPA": "No", "Length": 22, "Account Check": "", "Branch": "", "IBAN Example": "BH02CITI00001077181611"},
			{"Country": "Belarus", "Code": "BY", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "BY86AKBB10100000002966000000"},
			{"Country": "Belgium", "Code": "BE", "SEPA": "Yes", "Length": 16, "Account Check": "yes", "Branch": "yes", "IBAN Example": "BE71096123456769"},
			{"Country": "Bosnia and Herzegovina", "Code": "BA", "SEPA": "No", "Length": 20, "Account Check": "yes", "Branch": "yes", "IBAN Example": "BA393385804800211234"},
			{"Country": "Brazil", "Code": "BR", "SEPA": "No", "Length": 29, "Account Check": "", "Branch": "yes", "IBAN Example": "BR1500000000000010932840814P2"},
			{"Country": "Bulgaria", "Code": "BG", "SEPA": "Yes", "Length": 22, "Account Check": "", "Branch": "yes", "IBAN Example": "BG18RZBB91550123456789"},
			{"Country": "Burundi", "Code": "BI", "SEPA": "No", "Length": 27, "Account Check": "", "Branch": "", "IBAN Example": "BI1320001100010000123456789"},
			{"Country": "Costa Rica", "Code": "CR", "SEPA": "No", "Length": 22, "Account Check": "yes", "Branch": "", "IBAN Example": "CR23015108410026012345"},
			{"Country": "Croatia", "Code": "HR", "SEPA": "Yes", "Length": 21, "Account Check": "yes", "Branch": "", "IBAN Example": "HR1723600001101234565"},
			{"Country": "Cyprus", "Code": "CY", "SEPA": "Yes", "Length": 28, "Account Check": "", "Branch": "yes", "IBAN Example": "CY21002001950000357001234567"},
			{"Country": "Czech Republic", "Code": "CZ", "SEPA": "Yes", "Length": 24, "Account Check": "yes", "Branch": "", "IBAN Example": "CZ5508000000001234567899"},
			{"Country": "Denmark", "Code": "DK", "SEPA": "Yes", "Length": 18, "Account Check": "yes", "Branch": "yes", "IBAN Example": "DK9520000123456789"},
			{"Country": "Djibouti", "Code": "DJ", "SEPA": "No", "Length": 27, "Account Check": "", "Branch": "", "IBAN Example": "DJ2110002010010409943020008"},
			{"Country": "Dominican Republic", "Code": "DO", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "DO22ACAU00000000000123456789"},
			{"Country": "Egypt", "Code": "EG", "SEPA": "No", "Length": 29, "Account Check": "", "Branch": "", "IBAN Example": "EG800002000156789012345180002"},
			{"Country": "El Salvador", "Code": "SV", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "SV43ACAT00000000000000123123"},
			{"Country": "Estonia", "Code": "EE", "SEPA": "Yes", "Length": 20, "Account Check": "yes", "Branch": "yes", "IBAN Example": "EE471000001020145685"},
			{"Country": "Falkland Islands", "Code": "FK", "SEPA": "No", "Length": 18, "Account Check": "", "Branch": "", "IBAN Example": "FK12SC987654321098"},
			{"Country": "Faroe Islands", "Code": "FO", "SEPA": "No", "Length": 18, "Account Check": "yes", "Branch": "yes", "IBAN Example": "FO9264600123456789"},
			{"Country": "Finland", "Code": "FI", "SEPA": "Yes", "Length": 18, "Account Check": "yes", "Branch": "yes", "IBAN Example": "FI1410093000123458"},
			{"Country": "France", "Code": "FR", "SEPA": "Yes", "Length": 27, "Account Check": "yes", "Branch": "yes", "IBAN Example": "FR7630006000011234567890189"},
			{"Country": "Georgia", "Code": "GE", "SEPA": "No", "Length": 22, "Account Check": "", "Branch": "", "IBAN Example": "GE60NB0000000123456789"},
			{"Country": "Germany", "Code": "DE", "SEPA": "Yes", "Length": 22, "Account Check": "yes", "Branch": "yes", "IBAN Example": "DE75512108001245126199"},
			{"Country": "Gibraltar", "Code": "GI", "SEPA": "Yes", "Length": 23, "Account Check": "", "Branch": "yes", "IBAN Example": "GI56XAPO000001234567890"},
			{"Country": "Greece", "Code": "GR", "SEPA": "Yes", "Length": 27, "Account Check": "", "Branch": "yes", "IBAN Example": "GR9608100010000001234567890"},
			{"Country": "Greenland", "Code": "GL", "SEPA": "No", "Length": 18, "Account Check": "yes", "Branch": "yes", "IBAN Example": "GL8964710123456789"},
			{"Country": "Guatemala", "Code": "GT", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "GT20AGRO00000000001234567890"},
			{"Country": "Holy See (the)", "Code": "VA", "SEPA": "Yes", "Length": 22, "Account Check": "", "Branch": "", "IBAN Example": "VA59001123000012345678"},
			{"Country": "Hungary", "Code": "HU", "SEPA": "Yes", "Length": 28, "Account Check": "yes", "Branch": "yes", "IBAN Example": "HU93116000060000000012345676"},
			{"Country": "Iceland", "Code": "IS", "SEPA": "Yes", "Length": 26, "Account Check": "yes", "Branch": "yes", "IBAN Example": "IS750001121234563108962099"},
			{"Country": "Iraq", "Code": "IQ", "SEPA": "No", "Length": 23, "Account Check": "", "Branch": "", "IBAN Example": "IQ20CBIQ861800101010500"},
			{"Country": "Ireland", "Code": "IE", "SEPA": "Yes", "Length": 22, "Account Check": "yes", "Branch": "yes", "IBAN Example": "IE64IRCE92050112345678"},
			{"Country": "Israel", "Code": "IL", "SEPA": "No", "Length": 23, "Account Check": "yes", "Branch": "yes", "IBAN Example": "IL170108000000012612345"},
			{"Country": "Italy", "Code": "IT", "SEPA": "Yes", "Length": 27, "Account Check": "yes", "Branch": "yes", "IBAN Example": "IT60X0542811101000000123456"},
			{"Country": "Jordan", "Code": "JO", "SEPA": "No", "Length": 30, "Account Check": "", "Branch": "yes", "IBAN Example": "JO71CBJO0000000000001234567890"},
			{"Country": "Kazakhstan", "Code": "KZ", "SEPA": "No", "Length": 20, "Account Check": "", "Branch": "", "IBAN Example": "KZ244350000012344567"},
			{"Country": "Kosovo", "Code": "XK", "SEPA": "No", "Length": 20, "Account Check": "yes", "Branch": "yes", "IBAN Example": "XK051212012345678906"},
			{"Country": "Kuwait", "Code": "KW", "SEPA": "No", "Length": 30, "Account Check": "", "Branch": "", "IBAN Example": "KW81CBKU0000000000001234560101"},
			{"Country": "Latvia", "Code": "LV", "SEPA": "Yes", "Length": 21, "Account Check": "", "Branch": "", "IBAN Example": "LV97HABA0012345678910"},
			{"Country": "Lebanon", "Code": "LB", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "LB92000700000000123123456123"},
			{"Country": "Libya", "Code": "LY", "SEPA": "No", "Length": 25, "Account Check": "", "Branch": "", "IBAN Example": "LY38021001000000123456789"},
			{"Country": "Liechtenstein", "Code": "LI", "SEPA": "Yes", "Length": 21, "Account Check": "yes", "Branch": "yes", "IBAN Example": "LI7408806123456789012"},
			{"Country": "Lithuania", "Code": "LT", "SEPA": "Yes", "Length": 20, "Account Check": "", "Branch": "yes", "IBAN Example": "LT601010012345678901"},
			{"Country": "Luxembourg", "Code": "LU", "SEPA": "Yes", "Length": 20, "Account Check": "", "Branch": "", "IBAN Example": "LU120010001234567891"},
			{"Country": "Malta", "Code": "MT", "SEPA": "Yes", "Length": 31, "Account Check": "", "Branch": "yes", "IBAN Example": "MT31MALT01100000000000000000123"},
			{"Country": "Mauritania", "Code": "MR", "SEPA": "No", "Length": 27, "Account Check": "yes", "Branch": "yes", "IBAN Example": "MR1300020001010000123456753"},
			{"Country": "Mauritius", "Code": "MU", "SEPA": "No", "Length": 30, "Account Check": "", "Branch": "yes", "IBAN Example": "MU43BOMM0101123456789101000MUR"},
			{"Country": "Moldova", "Code": "MD", "SEPA": "No", "Length": 24, "Account Check": "", "Branch": "", "IBAN Example": "MD21EX000000000001234567"},
			{"Country": "Monaco", "Code": "MC", "SEPA": "Yes", "Length": 27, "Account Check": "yes", "Branch": "yes", "IBAN Example": "MC5810096180790123456789085"},
			{"Country": "Mongolia", "Code": "MN", "SEPA": "No", "Length": 20, "Account Check": "", "Branch": "", "IBAN Example": "MN580050099123456789"},
			{"Country": "Montenegro", "Code": "ME", "SEPA": "No", "Length": 22, "Account Check": "yes", "Branch": "", "IBAN Example": "ME25505000012345678951"},
			{"Country": "Netherlands", "Code": "NL", "SEPA": "Yes", "Length": 18, "Account Check": "yes", "Branch": "yes", "IBAN Example": "NL02ABNA0123456789"},
			{"Country": "Nicaragua", "Code": "NI", "SEPA": "No", "Length": 28, "Account Check": "", "Branch": "", "IBAN Example": "NI79BAMC00000000000003123123"},
			{"Country": "North Macedonia", "Code": "MK", "SEPA": "No", "Length": 19, "Account Check": "yes", "Branch": "", "IBAN Example": "MK07200002785123453"},
			{"Country": "Norway", "Code": "NO", "SEPA": "Yes", "Length": 15, "Account Check": "yes", "Branch": "yes", "IBAN Example": "NO8330001234567"},
			{"Country": "Pakistan", "Code": "PK", "SEPA": "No", "Length": 24, "Account Check": "", "Branch": "", "IBAN Example": "PK36SCBL0000001123456702"},
			{"Country": "Palestine", "Code": "PS", "SEPA": "No", "Length": 29, "Account Check": "", "Branch": "", "IBAN Example": "PS92PALS000000000400123456702"},
			{"Country": "Poland", "Code": "PL", "SEPA": "Yes", "Length": 28, "Account Check": "yes", "Branch": "yes", "IBAN Example": "PL10105000997603123456789123"},
			{"Country": "Portugal", "Code": "PT", "SEPA": "Yes", "Length": 25, "Account Check": "yes", "Branch": "yes", "IBAN Example": "PT50002700000001234567833"},
			{"Country": "Qatar", "Code": "QA", "SEPA": "No", "Length": 29, "Account Check": "", "Branch": "", "IBAN Example": "QA54QNBA000000000000693123456"},
			{"Country": "Romania", "Code": "RO", "SEPA": "Yes", "Length": 24, "Account Check": "", "Branch": "", "IBAN Example": "RO66BACX0000001234567890"},
			{"Country": "Russia", "Code": "RU", "SEPA": "No", "Length": 33, "Account Check": "yes", "Branch": "yes", "IBAN Example": "RU0204452560040702810412345678901"},
			{"Country": "Saint Lucia", "Code": "LC", "SEPA": "No", "Length": 32, "Account Check": "", "Branch": "", "IBAN Example": "LC14BOSL123456789012345678901234"},
			{"Country": "San Marino", "Code": "SM", "SEPA": "Yes", "Length": 27, "Account Check": "yes", "Branch": "yes", "IBAN Example": "SM76P0854009812123456789123"},
			{"Country": "Sao Tome and Principe", "Code": "ST", "SEPA": "No", "Length": 25, "Account Check": "", "Branch": "", "IBAN Example": "ST23000200000289355710148"},
			{"Country": "Saudi Arabia", "Code": "SA", "SEPA": "No", "Length": 24, "Account Check": "", "Branch": "", "IBAN Example": "SA4420000001234567891234"},
			{"Country": "Serbia", "Code": "RS", "SEPA": "No", "Length": 22, "Account Check": "yes", "Branch": "", "IBAN Example": "RS35105008123123123173"},
			{"Country": "Seychelles", "Code": "SC", "SEPA": "No", "Length": 31, "Account Check": "", "Branch": "", "IBAN Example": "SC74MCBL01031234567890123456USD"},
			{"Country": "Slovakia", "Code": "SK", "SEPA": "Yes", "Length": 24, "Account Check": "yes", "Branch": "", "IBAN Example": "SK8975000000000012345671"},
			{"Country": "Slovenia", "Code": "SI", "SEPA": "Yes", "Length": 19, "Account Check": "yes", "Branch": "yes", "IBAN Example": "SI56192001234567892"},
			{"Country": "Somalia", "Code": "SO", "SEPA": "No", "Length": 23, "Account Check": "", "Branch": "yes", "IBAN Example": "SO061000001123123456789"},
			{"Country": "Spain", "Code": "ES", "SEPA": "Yes", "Length": 24, "Account Check": "yes", "Branch": "yes", "IBAN Example": "ES7921000813610123456789"},
			{"Country": "Sudan", "Code": "SD", "SEPA": "No", "Length": 18, "Account Check": "", "Branch": "", "IBAN Example": "SD8811123456789012"},
			{"Country": "Sultanate of Oman", "Code": "OM", "SEPA": "No", "Length": 23, "Account Check": "", "Branch": "", "IBAN Example": "OM040280000012345678901"},
			{"Country": "Sweden", "Code": "SE", "SEPA": "Yes", "Length": 24, "Account Check": "yes", "Branch": "yes", "IBAN Example": "SE7280000810340009783242"},
			{"Country": "Switzerland", "Code": "CH", "SEPA": "Yes", "Length": 21, "Account Check": "yes", "Branch": "yes", "IBAN Example": "CH5604835012345678009"},
			{"Country": "Timor-Leste", "Code": "TL", "SEPA": "No", "Length": 23, "Account Check": "yes", "Branch": "", "IBAN Example": "TL380010012345678910106"},
			{"Country": "Tunisia", "Code": "TN", "SEPA": "No", "Length": 24, "Account Check": "yes", "Branch": "yes", "IBAN Example": "TN5904018104004942712345"},
			{"Country": "Turkey", "Code": "TR", "SEPA": "No", "Length": 26, "Account Check": "", "Branch": "yes", "IBAN Example": "TR320010009999901234567890"},
			{"Country": "Ukraine", "Code": "UA", "SEPA": "No", "Length": 29, "Account Check": "", "Branch": "yes", "IBAN Example": "UA903052992990004149123456789"},
			{"Country": "United Arab Emirates", "Code": "AE", "SEPA": "No", "Length": 23, "Account Check": "", "Branch": "", "IBAN Example": "AE460090000000123456789"},
			{"Country": "United Kingdom", "Code": "GB", "SEPA": "Yes", "Length": 22, "Account Check": "yes", "Branch": "yes", "IBAN Example": "GB33BUKB20201555555555"},
			{"Country": "Virgin Islands, British", "Code": "VG", "SEPA": "No", "Length": 24, "Account Check": "", "Branch": "", "IBAN Example": "VG07ABVI0000000123456789"},
			{"Country": "Yemen", "Code": "YE", "SEPA": "No", "Length": 30, "Account Check": "", "Branch": "", "IBAN Example": "YE09CBKU0000000000001234560101"}
		];


	@wire(getIban, { countryCode: '$countryCode'})
	wiredIbanLength({error, data}) {
		if (data) {
			this.ibanLength = data.IBANLength;
			this.isIBANMandatory = data.isIBANMandatory;
		} else if (error) {
			console.error(error);
		}
	}

	addSeparatorsToIban() {
		let ibanInputField = this.template.querySelector('.iban');

		this.noSpacesIban = ibanInputField.value.replace(/ /g, "");
		let separatedIban = '';
		for (let i=0; i<this.noSpacesIban.length; i++) {
			separatedIban += this.noSpacesIban.charAt(i);

			if ((i+1) % 4 == 0 && i != this.noSpacesIban.length-1)
				separatedIban += ' ';
		}

		ibanInputField.value = separatedIban;
		this.iban = separatedIban;

		const validateIbanResult = this.validateIbanWithoutToast();
	}

	validateIbanWithToast() {
		console.log('validateIbanWithToast');
		return this.validateIban(true);
	}

	validateIbanWithoutToast() {
		return this.validateIban(false);
	}

	validateIban(toastIfError) {
		console.log('validateIban noSpacesIban', this.noSpacesIban);


		console.log(this.noSpacesIban?.length);
		console.log(this.ibanLength);

		const inputIBANValue = this.refs.inputIBAN.value.trim();
		console.log('validateIban inputIBANValue', inputIBANValue);

		// if (!this.noSpacesIban) return true; // existing iban found, allow next button

		// Populate countryCodes from ibanTable
		let countryCodes = this.ibanTable.map(row => row.Code);
		console.log('countryCodes: ', countryCodes);

		let foundCountry = false;
		for (let country of countryCodes) {
			if (inputIBANValue.toUpperCase().startsWith(country)) {
				foundCountry = true;
				break;
			}
		}
		console.log('validateIban foundCountry', foundCountry);
		if (inputIBANValue.length>=1 && !foundCountry) {
			// User did not start iban with country code!
			const event = new ShowToastEvent({
				title: 'Error',
				message: 'Country Code Not Found in IBAN',
				variant: 'error',
			});
			if (toastIfError) {
				this.dispatchEvent(event);
				return false;
			}
		} else {
			this.showError = false;
			if (inputIBANValue.length<=0) return true;
		}

		console.log('validateIban isIBANMandatory', this.isIBANMandatory);
		if (
			this.isIBANMandatory
			|| (
				!this.isIBANMandatory && inputIBANValue !== null && inputIBANValue !== ''
			)
		) {
			let startsWithFoundCountry = false;
			for (const ibanTableRow of this.ibanTable) {
				if (inputIBANValue.toUpperCase().startsWith(ibanTableRow.Code)) {
					startsWithFoundCountry = true;
					console.log('inputIBANValue.length', this.noSpacesIban.length);
					console.log('ibanTableRow', ibanTableRow);
					if (this.noSpacesIban.length != ibanTableRow.Length) {
						this.ibanLength = ibanTableRow.Length;
						this.isValid = false;
						this.showError = true;
						return false;
					}
				}
			}

			if (startsWithFoundCountry && this.noSpacesIban.length != this.ibanLength) {
				this.isValid = false;
				//this.showError = true; // INC-2024-05-13/1594
				return false;
			} else {
				this.isValid = true;
				this.showError = false;
				return true;
			}
		} else {
			return false;
		}
	}

	jumpToNextScreen(event) {
		console.log('jumpToNextScreen event', event);
		console.log('jumpToNextScreen showInput', this.showInput);
		if (!this.showInput) {
			const navigateNextEvent = new FlowNavigationNextEvent();
			this.dispatchEvent(navigateNextEvent);
		}

		const validateIbanResult = this.validateIbanWithToast();
		console.log('jumpToNextScreen validateIbanResult', validateIbanResult);
		if (validateIbanResult) {
			const navigateNextEvent = new FlowNavigationNextEvent();
			this.dispatchEvent(navigateNextEvent);
		}
	}

	get showInput() {
		return this.existingIban == null || this.existingIban == '';
	}

	get incorrectLengthMessage() {
		if (this.ibanLength > this.noSpacesIban?.length) {
			return `Incorrect IBAN Length. Correct = ${this.ibanLength} (${this.DXP_But_you_typed} ${this.noSpacesIban?.length}${this.DXP_comma_Only}.`;
		} else {
			return `Incorrect IBAN Length. Correct = ${this.ibanLength} (${this.DXP_But_you_typed} ${this.noSpacesIban?.length}).`;
		}
	}

	handleCancel() {
		this[NavigationMixin.Navigate](
			{
				type: "comm__namedPage",
				attributes: {
					name: "get_a_quote__c"
				}
			}
		);
	}
}
