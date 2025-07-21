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

		const resObjStats = await fetch('https://api.traintrack.hu/v1/stats');
		const resStats = await resObjStats.json();
		console.log('resStats', resStats);
		this.stats = '';
		this.stats += `<p><strong>total_snapshots</strong>: ${resStats?.stats?.total_snapshots}</p>`;
		this.stats += `<p><strong>avg_age_days</strong>: ${resStats?.stats?.avg_age_days}</p>`;

		const resObjTrains = await fetch('https://api.traintrack.hu/v1/trains');
		const resTrains = await resObjTrains.json();
		console.log('resTrains', resTrains);

		if (resTrains.r2_url) {
			// "https://bucket.traintrack.hu/trainstore/1752068756.json.gz"
			//const resObjGzip = await fetch(resTrains.r2_url); // LWC MIME hiba! Helyette:
			const blobStrGzipped = await fetchTrainGzip({url: resTrains.r2_url});
			//console.log('Base64 GZ panel:', blobStrGzipped);

			// => Base64 decode
			const byteCharacters = atob(blobStrGzipped); // native browser fn
			console.log('log1');

			const byteNumbers = new Array(byteCharacters.length);
			console.log('log2');
			for (let i = 0; i < byteCharacters.length; i++) {
				byteNumbers[i] = byteCharacters.charCodeAt(i);
				console.log('logi');
			}
			console.log('loga');

			const uint8Array = new Uint8Array(byteNumbers);
			console.log('log3');

			try {
				this.fflate.gunzip(uint8Array, (err, decompressed) => {
					if (err) {
						console.warn('GUNZIP ERROR:', err);
						//return;
					}

					const jsonText = new TextDecoder('utf-8').decode(decompressed);

					try {
						const data = JSON.parse(jsonText);
						//console.log('✅ JSON parsed successfully:', data);
						console.log('✅ JSON parsed successfully:');
						// további feldolgozás

					} catch (e) {
						console.error('❌ JSON parse error:', e);
					}
				});
			} catch (e) {
				console.warn('Got error: ', e);
			}
		}

		this.isLoading = false;
	}
}
