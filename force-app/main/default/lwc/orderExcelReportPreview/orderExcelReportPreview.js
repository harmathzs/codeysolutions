/**
 * Created by Harmath Zsolt on 2025. 04. 15..
 */

import {LightningElement, api} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getTableData from '@salesforce/apex/OrderExcelReportController.getTableData';
import createContentVersion from '@salesforce/apex/OrderExcelReportController.createContentVersion';

export default class OrderExcelReportPreview extends LightningElement {
	_recordId;
	@api get recordId() {
		return this._recordId;
	}
	set recordId(value) {
		this._recordId = value;
		console.log('set recordId', this.recordId);
		if (this.recordId) {
			this.showSpinner = true;
			this.fillPreviewTableData()
				.finally(()=>{
					this.showSpinner = false;
				})
		}
	}

	showSpinner = false;

	headers = [];
	data = [];

	cdlId;
	urlToCD;

	async fillPreviewTableData() {
		console.log('fillPreviewTableData recordId', this.recordId);

		//await loadScript(this, sheetjs);

		// Get the base64 encoded data
		const base64Data = await getTableData({orderId: this.recordId});
		console.log('base64Data', base64Data);
		// Decode base64 to string
		// Use TextDecoder for UTF-8 decoding
		const decodedString = new TextDecoder('utf-8').decode(
			Uint8Array.from(atob(base64Data), c => c.charCodeAt(0))
		);
		console.log('decodedString', decodedString);
		const jsonData = JSON.parse(decodedString);
		console.log('jsonData', JSON.stringify(jsonData));
		// First row is headers
		this.headers = jsonData[0];
		console.log('headers', JSON.stringify(this.headers));
		// Rest is data
		this.data = jsonData.slice(1).map((row, index) => ({
			id: index,
			cells: row
		}));
		console.log('data', JSON.stringify(this.data));
	}

	async handleCreateFile(event) {
		this.showSpinner = true;

		this.cdlId = await createContentVersion({orderId: this.recordId});
		this.urlToCD = '/' + this.cdlId;

		this.showSpinner = false;

		// Show toast message
		const toastEvent = new ShowToastEvent({
			title: 'Success',
			message: `XLSX file created! ContentDocument Id: ${this.cdlId}`,
			messageData: {
				url: this.urlToCD,
				label: 'This is a clickable link to the new Excel file ...',
				target: '_blank'
			},
			variant: 'success',
			mode: 'dismissable'
		});
		this.dispatchEvent(toastEvent);

	}


	handleShowTable(event) {
		//console.log('handleShowTable event', event);

		// Create the URL for the Visualforce page with the record ID
		let vfPageUrl = '/apex/OrderExcelReport?id=' + this.recordId;

		// Open the URL in a new window/tab which will trigger the Excel download
		window.open(vfPageUrl, '_blank');
	}

	handleCloseWindow(event) {
		//console.log('handleCloseWindow event', event);
		this.dispatchEvent(new CloseActionScreenEvent());
	}
}
