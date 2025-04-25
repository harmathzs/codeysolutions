/**
 * Created by Harmath Zsolt on 2025. 04. 25..
 */

import {LightningElement, api} from 'lwc';

export default class SzunetnapokDatatable extends LightningElement {
	_inputJson;
	inputObj;
	data;
	@api get inputJson() {
		return this._inputJson;
	}
	set inputJson(value) {
		console.log('set inputJson value', value);
		this._inputJson = value;
		this.inputObj = JSON.parse(value);
		this.data = this.inputObj.days;
	}

	columns = [
		{ label: 'Date', fieldName: 'date' },
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Type', fieldName: 'type' },
		{ label: 'Weekday', fieldName: 'weekday' },
	];

}
