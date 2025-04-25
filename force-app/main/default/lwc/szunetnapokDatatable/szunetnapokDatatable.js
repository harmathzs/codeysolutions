/**
 * Created by Harmath Zsolt on 2025. 04. 25..
 */

import {LightningElement, api} from 'lwc';

export default class SzunetnapokDatatable extends LightningElement {
	_inputJson;
	@api get inputJson() {
		return this._inputJson;
	}
	set inputJson(value) {
		console.log('set inputJson value', value);
		this._inputJson = value;
	}

	data;
}
