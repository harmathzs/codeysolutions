import {LightningElement} from 'lwc';

import { loadScript } from 'lightning/platformResourceLoader';
import FFLATE from '@salesforce/resourceUrl/fflate_lib'; // fflate.min.js static resource

import fetchTrainGzip from '@salesforce/apex/TrainTrackController.fetchTrainGzip';

export default class TrainTrack extends LightningElement {
	status='TODO - status';
	stats='TODO - stats';
	trains='TODO - trains';

	isLoading = false;

	fflate;
	fflateLoaded = false;

	async connectedCallback() {
		this.isLoading = true;

		if (!this.fflateLoaded) {
			await loadScript(this, FFLATE);
			this.fflate = window.fflate;
			this.fflateLoaded = true;
		}

		const resObjStatus = await fetch('https://api.traintrack.hu/v1/status');
		const resStatus = await resObjStatus.json();
		console.log('resStatus', resStatus);
		this.status = '';
		for (const key in resStatus) {
			this.status += `<p><strong>${key}</strong>: ${resStatus[key]}</p>`;
		}

		this.isLoading = false;
	}
}
