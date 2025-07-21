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

	filenameAsNumber = 0;
	iframeSrc;

	async connectedCallback() {
		this.isLoading = true;

		if (!this.fflateLoaded) {
			await loadScript(this, FFLATE);
			this.fflate = window.fflate;
			this.fflateLoaded = true;
		}

		const resObjStatus = await fetch('https://api.traintrack.hu/v1/status');
		const resStatus = await resObjStatus.json();
		//console.log('resStatus', resStatus);
		this.status = '';
		for (const key in resStatus) {
			this.status += `<p><strong>${key}</strong>: ${resStatus[key]}</p>`;
		}

		const resObjStats = await fetch('https://api.traintrack.hu/v1/stats');
		const resStats = await resObjStats.json();
		//console.log('resStats', resStats);
		this.stats = '';
		this.stats += `<p><strong>total_snapshots</strong>: ${resStats?.stats?.total_snapshots}</p>`;
		this.stats += `<p><strong>avg_age_days</strong>: ${resStats?.stats?.avg_age_days}</p>`;

		const resObjTrains = await fetch('https://api.traintrack.hu/v1/trains');
		const resTrains = await resObjTrains.json();
		console.log('resTrains', resTrains);

		if (resTrains.r2_url) {
			// "https://bucket.traintrack.hu/trainstore/1752068756.json.gz"

			const url = resTrains.r2_url;
			const fileName = url.split('/').pop(); // "1752068756.json.gz"
			const numberStr = fileName.split('.')[0]; // "1752068756"
			const number = parseInt(numberStr, 10);
			console.log('Szám:', number);

			this.filenameAsNumber = number;

			this.iframeSrc = '/apex/TrainTrackTrainsFramed?number='+number;
		}

		this.isLoading = false;
	}
}
