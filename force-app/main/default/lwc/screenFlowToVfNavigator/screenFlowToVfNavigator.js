/**
 * Created by Harmath Zsolt on 2025. 03. 25.
 */

import {LightningElement, api} from 'lwc';
import { FlowNavigationFinishEvent, FlowNavigationBackEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';

export default class ScreenFlowToVfNavigator extends NavigationMixin(LightningElement) {
	@api availableActions = [];

	@api ids;
	@api recordId;
	@api vfpagename;

	@api showPrevious;
	@api showFinish;

	handlePrevious() {
		// Check if previous is allowed
		if (this.availableActions.find(action => action === 'BACK')) {
			// Navigate back
			const navigateBackEvent = new FlowNavigationBackEvent();
			this.dispatchEvent(navigateBackEvent);
		}
	}

	handleFinish() {
		// Open Visualforce page in new tab
		window.open(
			`/apex/${this.vfpagename}?recordId=${this.recordId}&ids=${JSON.stringify(this.ids)}`,
			'_blank' // This specifies to open in new tab
		);

		// Finish the flow
		if (this.availableActions.find(action => action === 'FINISH')) {
			const navigateFinishEvent = new FlowNavigationFinishEvent();
			this.dispatchEvent(navigateFinishEvent);
		}
	}
}
