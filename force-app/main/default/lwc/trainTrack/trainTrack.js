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
		this.stats = '';
		this.stats += `<p><strong>total_snapshots</strong>: ${resStats?.stats?.total_snapshots}</p>`;
		this.stats += `<p><strong>avg_age_days</strong>: ${resStats?.stats?.avg_age_days}</p>`;

		const resObjTrains = await fetch('https://api.traintrack.hu/v1/trains');
		const resTrains = await resObjTrains.json();
		console.log('resTrains', resTrains);

		this.isLoading = false;
	}
}
