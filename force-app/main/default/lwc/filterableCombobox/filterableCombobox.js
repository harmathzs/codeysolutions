/**
 * Created by Harmath Zsolt on 2025. 02. 03.
 */

import {api, LightningElement} from 'lwc';
//import select_an_option from '@salesforce/label/c.select_an_option';
//import complete_this_field from '@salesforce/label/c.complete_this_field';
//import start_typing_to_search from '@salesforce/label/c.start_typing_to_search';

export default class FilterableCombobox extends LightningElement {

	@api label;
	@api required = false;
	@api disabled = false;
	@api placeholder = 'Select an option';

	displayedOptions = [];
	searchText = '';
	timeoutId;
	errorMessage;
	_highlightedRow;
	isDropdownOpened = false;
	_inputValue = '';
	_isConnected = false;
	_options;
	_value;

	@api get options() {
		return this._options;
	}

	set options(value) {
		this._options = value;
		if (this._isConnected) {
			this.inputValue = this._options.find(e => e.value === this._value)?.label;
		}
	}

	@api get value() {
		return this._value;
	}

	set value(value) {
		if (this._value === value) {
			return;
		}
		this._value = value;
		if (this._isConnected) {
			this.inputValue = this._options.find(e => e.value === this._value)?.label;
		}
	}

	set inputValue(value) {
		if (value !== null && value !== undefined) {
			this._inputValue = value;
		} else {
			this._inputValue = '';
		}
	}

	connectedCallback() {
		this._isConnected = true;
		if (Array.isArray(this._options)) {
			this.inputValue = this._options.find(e => e.value === this._value)?.label;
		}
	}

	disconnectedCallback() {
		this._isConnected = false;
	}

	get highlightedRow() {
		return this._highlightedRow;
	}

	set highlightedRow(value) {
		if (this._highlightedRow === value) {
			return;
		}
		if (this._highlightedRow != null) {
			this._highlightedRow.classList.remove('highlighted');
		}
		this._highlightedRow = value;
		if (this._highlightedRow != null) {
			this._highlightedRow.classList.add('highlighted');
		}
	}

	handleInputClick(event) {
		if (!this.isDropdownOpened) {
			this.openDropdown();
		}
	}

	handleIconClick(event) {
		event.stopPropagation();
		if (!this.isDropdownOpened) {
			this.refs.searchInput.focus();
			this.refs.searchInput.click();
		}
	}

	handleInputFocus() {
		/*if (this.refs.searchInput.validity.customError === true) {
			this.refs.searchInput.setCustomValidity('');
			this.refs.searchInput.reportValidity();
		}*/
		//this.openDropdown();
	}

	openDropdown() {
		this.isDropdownOpened = true;
		this.errorMessage = null;
		this.inputValue = '';
		this.displayedOptions = this._options.map(e => {
			return {
				label: e.label ?? '',
				value: e.value,
				displayedLabel: e.label ?? '',
			}
		});
		let index = this.displayedOptions.findIndex(e => e.value === this._value);
		if (index !== -1) {
			setTimeout(() => {
				this.highlightedRow = this.template.querySelector(`[data-index="${index}"]`);
				scrollIntoViewIfNeeded(this.highlightedRow, this.refs.dropdownContainer);
			})
		}
	}

	handleInputBlur() {
		this.isDropdownOpened = false;
		this.inputValue = this._options.find(e => e.value === this._value)?.label;
		this.refs.searchInput.value = this._inputValue;
		this.highlightedRow = null;
		this.reportValidity();
	}


	handleRowMouseEnter(event) {
		this.highlightedRow = event.currentTarget;
	}

	handleRowMouseLeave(event) {
		this.highlightedRow = null;
	}

	handleInputKeyDown(event) {
		try {
			if (!this.isDropdownOpened) {
				this.refs.searchInput.click();
			} else {
				if (this.displayedOptions.length > 0) {
					if (event.key === 'ArrowDown') {
						event.preventDefault();
						if (this.highlightedRow == null || this.highlightedRow.nextElementSibling == null) {
							this.highlightedRow = this.template.querySelector(".row");
						} else {
							this.highlightedRow = this.highlightedRow.nextElementSibling;
						}
						scrollIntoViewIfNeeded(this.highlightedRow, this.refs.dropdownContainer);
					} else if (event.key === 'ArrowUp') {
						event.preventDefault();
						if (this.highlightedRow == null || this.highlightedRow.previousElementSibling == null) {
							this.highlightedRow = this.template.querySelector(".row:last-child");
						} else {
							this.highlightedRow = this.highlightedRow.previousElementSibling;
						}
						scrollIntoViewIfNeeded(this.highlightedRow, this.refs.dropdownContainer);
					} else if (event.key === 'Enter') {
						if (this.highlightedRow) {
							let option = this.displayedOptions[+this.highlightedRow.dataset.index];
							this.handleOptionSelection(option);
						}
					}
				}
				if (event.key === 'Escape') {
					this.refs.searchInput.blur();
				}
			}
		} catch (error) {
			console.error(error.stack ?? error.message ?? error);
		}
	}

	handleRowClick(event) {
		let option = this.displayedOptions[+event.currentTarget.dataset.index];
		this.handleOptionSelection(option);
	}

	handleOptionSelection(option) {
		this._value = option.value;
		this.refs.searchInput.blur();
		this.dispatchEvent(new CustomEvent('change', {
			detail: {
				value: this._value,
			}
		}));
	}

	handleInputChange(event) {
		event.stopPropagation();
		this.inputValue = event.target.value;
		let value = this._inputValue?.trim();
		if (value === this.searchText) {
			return;
		}
		clearTimeout(this.timeoutId);
		this.searchText = value;
		this.timeoutId = setTimeout(() => {
			this.searchOptions();
		}, 100);
	}

	searchOptions() {
		this.highlightedRow = null;
		this.displayedOptions = [];
		let searchText = this.searchText.toLowerCase();
		let escapedSearchText = escapeRegExp(searchText);
		const regex = new RegExp(`(${escapedSearchText})`, 'gi');
		for (const option of this._options) {
			if (option.label.toLowerCase().includes(searchText)) {
				this.displayedOptions.push({...option, displayedLabel: option.label.replace(regex, '<b>$1</b>')});
			}
		}
	}

	preventDefault(event) {
		event.preventDefault();
	}

	stopPropagation(event) {
		event.stopPropagation();
	}

	get hasResults() {
		return this.displayedOptions?.length > 0;
	}

	get hasNoResults() {
		return this.displayedOptions?.length === 0;
	}

	get computedInputClass() {
		let classes = 'slds-input slds-p-right_x-large ';
		if (!this.isDropdownOpened) {
			return classes;
		}
		classes += ' is-opened ';
		return classes;
	}

	get computedInputContainerClass() {
		if (this.errorMessage != null) {
			return 'slds-form-element slds-has-error ';
		}
		return 'slds-form-element';
	}

	get computedPlaceholder() {
		if (this.isDropdownOpened) {
			return 'Start typing to search';
		}
		return this.placeholder;
	}

	@api reportValidity() {
		this.errorMessage = null;
		if (this.required === true && this._options.find(e => e.value === this._value) == null) {
			this.errorMessage = 'Complete this field';
		}
	}

	@api checkValidity() {
		if (this.required === true && this._options.find(e => e.value === this._value) == null) {
			return false;
		}
		return true;
	}
}

function generateId() {
	return Math.floor(Math.random() * 100000000);
}

function escapeRegExp(text) {
	return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
}

function scrollIntoViewIfNeeded(element, scrollingParent) {
	const parentRect = scrollingParent.getBoundingClientRect();
	const findMeRect = element.getBoundingClientRect();
	if (findMeRect.top < parentRect.top) {
		if (element.offsetTop + findMeRect.height < parentRect.height) {
			scrollingParent.scrollTop = 0;
		} else {
			scrollingParent.scrollTop = element.offsetTop;
		}
	} else if (findMeRect.bottom > parentRect.bottom) {
		scrollingParent.scrollTop += findMeRect.bottom - parentRect.bottom;
	}
}
