/**
 * Created by Harmath Zsolt on 2025. 02. 05.
 */

import {api, LightningElement, track} from 'lwc';
// import select_all from '@salesforce/label/c.select_all';
// import multi_select_reset from '@salesforce/label/c.multi_select_reset';
// import complete_this_field from '@salesforce/label/c.complete_this_field';
// import select_an_option from '@salesforce/label/c.select_an_option';

export default class MultiSelect extends LightningElement {

	labels = {
		select_all: 'Select all',
		multi_select_reset: 'Multi-select reset',
		complete_this_field: 'Complete this field',
		select_an_option: 'Select an option',
	}

	@api label = '';
	@api spinnerActive = false;
	@api required = false;
	@api placeholder = this.labels.select_an_option;
	@api readOnly = false;
	@api canToggleAll = false;
	@api delimiter = ', ';
	@track selectedOptions = [];
	@track _options = [];
	_value;
	_isOpened = false;
	errorMessage;
	timeoutid;
	areAllSelected = false;

	@api get options() {
		return this._options;
	}

	set options(rawOptions) {
		this._options = [];
		this.selectedOptions = [];
		let hasValues = Array.isArray(this._value);
		if (Array.isArray(rawOptions)) {
			for (const option of rawOptions) {
				let clone = {
					...option
				};
				if (hasValues) {
					clone.isSelected = this._value.includes(clone.value);
				} else {
					clone.isSelected = false;
				}
				if (clone.isSelected) {
					this.selectedOptions.push(clone);
				}
				this._options.push(clone);
			}
		}
		for (const option of this._options) {
			this.initOption(option);
		}
	}

	@api get value() {
		let values = [];
		for (const selectedOption of this.selectedOptions) {
			values.push(selectedOption.value);
		}
		return values.join(';');
	}

	set value(values) {
		this.selectedOptions = [];
		if (typeof values === 'string') {
			values = values.split(';');
		}
		this._value = values;
		if (this._options.length > 0) {
			for (const option of this._options) {
				option.isSelected = Array.isArray(this._value) && this._value.includes(option.value);
				if (option.isSelected) {
					this.selectedOptions.push(option);
				}
			}
		}
	}

	set isOpened(value) {
		if (this._isOpened === value) {
			return;
		}
		clearTimeout(this.timeoutid);
		this._isOpened = value;
		if (this._isOpened === false) {
			this.reportValidity();
		}
		setTimeout(() => {
			if (this._isOpened === true) {
				addEventListener('mousedown', this.clickListener, {capture: true, passive: true});
				addEventListener('keydown', this.keydownListener, {capture: true, passive: true});
			} else {
				removeEventListener('mousedown', this.clickListener, {capture: true});
				removeEventListener('keydown', this.keydownListener, {capture: true});
			}
		});
	}

	handleContainerMouseDown() {
		clearTimeout(this.timeoutid);
	}

	handleButtonClick() {
		this.errorMessage = null;
		this.isOpened = !this.isOpened;
	}

	clickListener = event => {
		this.timeoutid = setTimeout(() => {
			this.isOpened = false;
		})
	}

	keydownListener = (event) => {
		if (event.key === 'Escape') {
			this.isOpened = false;
		}
	}

	toggleAllRows(event) {
		let isChecked = event.detail.checked;
		this.areAllSelected = isChecked;
		let values = [];
		this.selectedOptions = [];
		for (const option of this._options) {
			option.isSelected = isChecked;
			if (isChecked) {
				this.selectedOptions.push(option);
				values.push(option.value);
			}
		}
		event.stopPropagation();
		this.dispatchEvent(new CustomEvent('change', {detail: {value: values}}));
	}

	handleOptionToggle(event) {
		this._options[+event.currentTarget.dataset.index].isSelected = event.detail.checked;
		if (event.detail.checked === false) {
			this.areAllSelected = false;
		}
		let values = [];
		this.selectedOptions = [];
		for (const option of this._options) {
			if (option.isSelected === true) {
				this.selectedOptions.push(option);
				values.push(option.value)
			}
		}
		event.stopPropagation();
		this.dispatchEvent(new CustomEvent('change', {detail: {value: values}}));
	}

	handleOptionKeyDown(event) {
		if (event.key === 'Tab') {
			let index = +event.currentTarget.dataset.index;
			if (!event.shiftKey && index === this._options.length - 1) {
				this.isOpened = false;
			} else if (event.shiftKey && index === 0) {
				this.isOpened = false;
			}
		}
	}

	preventDefault(event) {
		event.preventDefault();
	}

	stopPropagation(event) {
		event.stopPropagation();
	}

	initOption(option) {
		Object.defineProperty(option, 'cssClasses', {
			get() {
				let classes = ['row'];
				if (option.isSelected === true) {
					classes.push('selected');
				}
				return classes.join(' ');
			}
		})
	}

	get isOpened() {
		return this._isOpened;
	}

	get computedLabel() {
		if (this.selectedOptions.length === 0) {
			return this.placeholder;
		}
		return this.selectedOptions.map(e => e.label).join(this.delimiter);
	}


	get hasLabel() {
		return this.label != null && this.label.trim() !== '';
	}

	get computedButtonClasses() {
		let classes = [];
		if (this.errorMessage != null) {
			classes.push('has-error');
		}
		if (this.readOnly === true) {
			classes.push('read-only');
		}
		if (this.selectedOptions.length === 0) {
			classes.push('placeholder');
		}
		return classes.join(' ');
	}

	get hasOptions() {
		return this.options.length > 0;
	}

	get computedToggleLabel() {
		return this.areAllSelected ? this.labels.multi_select_reset : this.labels.select_all;
	}

	@api reportValidity() {
		this.errorMessage = null;
		if (this.required === true && this.selectedOptions.length === 0) {
			this.errorMessage = this.labels.complete_this_field;
		}
	}
}
