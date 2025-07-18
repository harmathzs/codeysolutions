import {LightningElement} from 'lwc';

export default class StarWarsApiLwc extends LightningElement {
	films; people; planets; species; vehicles; starships;
	filmsJSON; peopleJSON; planetsJSON; speciesJSON; vehiclesJSON; starshipsJSON;

	filmsColumns = [
		{ label: 'Title', fieldName: 'title' },
		{ label: 'Created', fieldName: 'created', type: 'date' },
		{ label: 'Director', fieldName: 'director' },
		{ label: 'Edited', fieldName: 'edited', type: 'date' },
		{ label: 'Episode ID', fieldName: 'episodeId' },
		{ label: 'Opening Crawl', fieldName: 'openingCrawl' },
		{ label: 'Producer', fieldName: 'producer' },
		{ label: 'Release Date', fieldName: 'releaseDate', type: 'date' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	peopleColumns;
	planetsColumns;
	speciesColumns;
	vehiclesColumns;
	starshipsColumns;

	filmsTableData;
	peopleTableData;
	planetsTableData;
	speciesTableData;
	vehiclesTableData;
	starshipsTableData;

	connectedCallback() {
		fetch('https://swapi.info/api/films').then(res => res.json())
			.then(data => {
				this.films=data;
				console.log('films', this.films);
				this.filmsJSON = JSON.stringify(this.films);

				// convert to table data
				this.filmsTableData = this.films.map((film, idx) => {
					return {
						id: idx,
						title: film.title,
						created: film.created,
						director: film.director,
						edited: film.edited,
						episodeId: film.episode_id,
						openingCrawl: film.opening_crawl,
						producer: film.producer,
						releaseDate: film.release_date,
						url: film.url,
					}
				});
			})
			.catch(console.warn);

		fetch('https://swapi.info/api/people').then(res => res.json())
			.then(data => {
				this.people=data;
				console.log('people', this.people);
				this.peopleJSON = JSON.stringify(this.people);
			})
			.catch(console.warn);

		fetch('https://swapi.info/api/planets').then(res => res.json())
			.then(data => {
				this.planets=data;
				console.log('planets', this.planets);
				this.planetsJSON = JSON.stringify(this.planets);
			})
			.catch(console.warn);

		fetch('https://swapi.info/api/species').then(res => res.json())
			.then(data => {
				this.species=data;
				console.log('species', this.species);
				this.speciesJSON = JSON.stringify(this.species);
			})
			.catch(console.warn);

		fetch('https://swapi.info/api/vehicles').then(res => res.json())
			.then(data => {
				this.vehicles=data;
				console.log('vehicles', this.vehicles);
				this.vehiclesJSON = JSON.stringify(this.vehicles);
			})
			.catch(console.warn);

		fetch('https://swapi.info/api/starships').then(res => res.json())
			.then(data => {
				this.starships=data;
				console.log('starships', this.starships);
				this.starshipsJSON = JSON.stringify(this.starships);
			})
			.catch(console.warn);
	}
}
