/**
 * Created by Harmath Zsolt on 2025. 02. 07.
 */

import {api, LightningElement} from 'lwc';

export default class ScrollEnforcer extends LightningElement {

	labels = {
		I_Reject: 'Reject',
		I_acknowledged: 'Accept',
	}

	@api label;
	@api content;
	@api primaryButtonLabel = this.labels.I_acknowledged;
	@api spinnerActive = false;

	isButtonDisabled = true;
	hasScrolledDown = false;

	connectedCallback() {
		addEventListener('resize', this.resizeListener, {passive: true});
		setTimeout(() => {
			this.checkScrollBar();
		})
	}

	disconnectedCallback() {
		removeEventListener('resize', this.resizeListener);
	}

	resizeListener = () => {
		this.checkScrollBar()
	}

	handleRejectButtonClick() {
		this.dispatchEvent(new CustomEvent('reject'));
	}

	handleAcceptButtonClick() {
		this.dispatchEvent(new CustomEvent('accept'));
	}

	checkScrollBar = throttle(() => {
		if (this.hasScrolledDown === true) {
			return;
		}
		let boxBottom = this.refs.content.getBoundingClientRect().bottom;
		let inputBottom = this.refs.richText.getBoundingClientRect().bottom;
		let distance = Math.floor(inputBottom - boxBottom);
		if (distance <= 0) {
			this.hasScrolledDown = true;
			this.isButtonDisabled = false;
			this.dispatchEvent(new CustomEvent('scrolleddown'));
			removeEventListener('resize', this.resizeListener);
			//addEventListener('scroll', this.checkScrollBar);
		}
	}, 200)
}

function throttle(func, delay) {
	let lastExecutionTime = 0;
	let timeoutId;

	return function (...args) {
		const currentTime = Date.now();

		if (currentTime - lastExecutionTime >= delay) {
			func.apply(this, args);
			lastExecutionTime = currentTime;
		} else {
			clearTimeout(timeoutId);
			timeoutId = setTimeout(() => {
				func.apply(this, args);
				lastExecutionTime = Date.now();
			}, delay - (currentTime - lastExecutionTime));
		}
	};
}
