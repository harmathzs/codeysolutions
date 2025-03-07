/**
 * Created by Harmath Zsolt on 2025. 02. 07.
 */

import {LightningElement, api} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ScrollEnforcerWithValues extends LightningElement {
	@api showScrollEnforcer = false;
	handleLaunch(event) {
		this.showScrollEnforcer = true;
	}



	handleAccept(event) {
		console.log('handleAccept event', event);

		const toast = new ShowToastEvent({
			title: 'Accepted',
			variant: 'success',
			mode: 'dismissable',
			message: 'Accepted'
		});
		this.dispatchEvent(toast);

		this.showScrollEnforcer = false;
	}

	handleReject(event) {
		console.log('handleReject event', event);

		const toast = new ShowToastEvent({
			title: 'Rejected',
			variant: 'warning',
			mode: 'dismissable',
			message: 'Rejected'
		});
		this.dispatchEvent(toast);

		this.showScrollEnforcer = false;
	}
}
