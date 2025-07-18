import {LightningElement} from 'lwc';

export default class StarWarsApiLwc extends LightningElement {
	films; people; planets; species; vehicles; starships;
	filmsJSON; peopleJSON; planetsJSON; speciesJSON; vehiclesJSON; starshipsJSON;

	connectedCallback() {
		fetch('https://swapi.info/api/films').then(res => res.json())
			.then(data => {
				this.films=data;
				console.log('films', this.films);
				this.filmsJSON = JSON.stringify(this.films);
			})
			.catch(error => console.warn(error));
	}
}
