/**
 * Created by User on 2025. 12. 01..
 */

import {LightningElement, api} from 'lwc';

export default class LeadConverterLwc extends LightningElement {
	_recordId;
	@api get recordId() {
		return this._recordId
	}
	async handleRecordIdSet() {
		console.log('LeadConverterLwc recordId', this.recordId)
	}
	set recordId(value) {
		this._recordId = value
		this.handleRecordIdSet().catch(console.warn)
	}

	@api ids;

	showCard = true;

	displayInfo = {
		primaryField: "Name",
		additionalFields: ["Company"],
	};

	handleLeadPick(e) {
		//console.log('handleLeadPick e', e)
		this.recordId = e?.detail?.recordId
	}
}
