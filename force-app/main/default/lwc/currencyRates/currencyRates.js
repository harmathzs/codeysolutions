/**
 * Created by Harmath Zsolt on 2025. 02. 09.
 */

import {LightningElement} from 'lwc';

export default class CurrencyRates extends LightningElement {
	apiKey = '5007bbeac86574994088d4021dac9a12';
	base = 'EUR';
	supportedSymbols;
	symbolOptions;
	symbols;

	baseToEUR = 1.0;
	ratesToEUR;

	columns = [
		{label: 'Currency Abbreviation', fieldName: 'abbr'},
		{label: 'Conversion Rate', fieldName: 'rate'},
	];
	data = [];

	connectedCallback() {
		this.loadSupportedSymbols();
		this.loadRatesToEUR();
	}

	loadSupportedSymbols() {
		fetch('https://data.fixer.io/api/symbols?access_key='+this.apiKey)
			.then(res => res.json())
			.then(json => {
				this.supportedSymbols = json;
				console.log('loadSupportedSymbols supportedSymbols', this.supportedSymbols);
				// {
				//     "success": true,
				//     "symbols": {
				//         "AED": "United Arab Emirates Dirham",
				//         "AFN": "Afghan Afghani",

				this.symbolOptions = [];
				for (const symbolRow in this.supportedSymbols?.symbols) {
					this.symbolOptions.push({
						label: '' + symbolRow + ' - ' + this.supportedSymbols.symbols[symbolRow],
						value: symbolRow
					});
				}
			})
			.catch(err => console.log(err))
			.finally(() => {});
	}

	loadRatesToEUR() {
		fetch('https://data.fixer.io/api/latest?access_key='+this.apiKey+'&base=EUR')
			.then(res => res.json())
			.then(json => {
				this.ratesToEUR = json;
				console.log('loadRatesToEUR ratesToEUR', this.ratesToEUR);
				// {
				//     "success": true,
				//     "timestamp": 1739168655,
				//     "base": "EUR",
				//     "date": "2025-02-10",
				//     "rates": {
				//         "AED": 3.788652,
				//         "AFN": 76.945387,
			})
			.catch(err => console.log(err))
			.finally(()=>{});
	}

	recalculateTable() {
		this.data = [];
		for (const symbol of this.symbols) {
			for (const rateToEURabbr in this.ratesToEUR?.rates) {
				if (symbol == rateToEURabbr) {
					this.data.push({abbr: symbol, rate: +this.ratesToEUR?.rates[rateToEURabbr] / this.baseToEUR });
				}
			}
		}
	}

	handleMultiselectChange(event) {
		//console.log('handleMultiselectChange event', event);
		this.symbols = event?.detail?.value;
		console.log('handleMultiselectChange symbols', JSON.stringify(this.symbols));

		this.recalculateTable();
	}

	handleBaseChange(event) {
		this.base = event?.detail?.value;
		console.log('handleBaseChange base', this.base);
		this.baseToEUR = +this.ratesToEUR?.rates[this.base];
		console.log('handleBaseChange baseToEUR', this.baseToEUR);

		this.recalculateTable();
	}
}
