/**
 * Created by Harmath Zsolt on 2025. 02. 05.
 */

import {LightningElement} from 'lwc';

export default class MultiSelectComboboxWithValues extends LightningElement {
	options = [];
	value = [];

	connectedCallback() {
		this.options = [];
		for (let i = 0; i < 20; i++) {
			this.options.push({label: 'label ' + i, value: 'value ' + i})
		}
	}

	handleChange(event) {
		this.value = event.detail.value;
	}
}
