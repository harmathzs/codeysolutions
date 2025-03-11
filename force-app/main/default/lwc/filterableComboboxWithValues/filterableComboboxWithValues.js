/**
 * Created by Harmath Zsolt on 2025. 02. 05.
 */

import {LightningElement} from 'lwc';

export default class FilterableComboboxWithValues extends LightningElement {
	value;
	options = [
		{label: 'First label', value: 'val1'},
		{label: 'Second label', value: 'val2'},
		{label: 'Third label', value: 'val3'},
		{label: 'Fourth', value: 'val4'},
	];

	handleChange(event) {
		this.value = event.detail.value;
		console.log(`this.value`,this.value);
	}
}
