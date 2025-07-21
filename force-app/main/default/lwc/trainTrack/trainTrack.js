import {LightningElement} from 'lwc';

export default class TrainTrack extends LightningElement {
	status='TODO - status';
	stats='TODO - stats';
	trains='TODO - trains';

	isLoading = false;

	async connectedCallback() {
		this.isLoading = true;

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

		const resObjTrains = await fetch('https://api.traintrack.hu/v1/trains');
		const resTrains = await resObjTrains.json();
		console.log('resTrains', resTrains);

		this.isLoading = false;
	}
}
