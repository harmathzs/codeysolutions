import {LightningElement} from 'lwc';

export default class StarWarsApiLwc extends LightningElement {
	films; people; planets; species; vehicles; starships;
	filmsJSON; peopleJSON; planetsJSON; speciesJSON; vehiclesJSON; starshipsJSON;

	filmsColumns = [
		{ label: 'Title', fieldName: 'title' },
		//{ label: 'Created', fieldName: 'created', type: 'date' },
		{ label: 'Director', fieldName: 'director' },
		//{ label: 'Edited', fieldName: 'edited', type: 'date' },
		{ label: 'Episode ID', fieldName: 'episodeId' },
		{ label: 'Opening Crawl', fieldName: 'openingCrawl' },
		{ label: 'Producer', fieldName: 'producer' },
		{ label: 'Release Date', fieldName: 'releaseDate', type: 'date' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	peopleColumns= [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Birth Year', fieldName: 'birth_year' },
		{ label: 'Eye Color', fieldName: 'eye_color' },
		{ label: 'Gender', fieldName: 'gender' },
		{ label: 'Hair Color', fieldName: 'hair_color' },
		{ label: 'Height', fieldName: 'height' },
		{ label: 'Homeworld', fieldName: 'homeworld', type: 'url' },
		{ label: 'Mass', fieldName: 'mass' },
		{ label: 'Skin Color', fieldName: 'skin_color' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	planetsColumns= [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Climate', fieldName: 'climate' },
		{ label: 'Diameter', fieldName: 'diameter' },
		{ label: 'Gravity', fieldName: 'gravity' },
		{ label: 'Orbital Period', fieldName: 'orbital_period' },
		{ label: 'Population', fieldName: 'population' },
		{ label: 'Rotation Period', fieldName: 'rotation_period' },
		{ label: 'Surface Water', fieldName: 'surface_water' },
		{ label: 'Terrain', fieldName: 'terrain' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	speciesColumns= [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Average Height', fieldName: 'average_height' },
		{ label: 'Average Lifespan', fieldName: 'average_lifespan' },
		{ label: 'Classification', fieldName: 'classification' },
		{ label: 'Designation', fieldName: 'designation' },
		{ label: 'Eye Colors', fieldName: 'eye_colors' },
		{ label: 'Hair Colors', fieldName: 'hair_colors' },
		{ label: 'Homeworld', fieldName: 'homeworld', type: 'url' },
		{ label: 'Language', fieldName: 'language' },
		{ label: 'Skin Colors', fieldName: 'skin_colors' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	vehiclesColumns= [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'Cargo Capacity', fieldName: 'cargo_capacity' },
		{ label: 'Consumables', fieldName: 'consumables' },
		{ label: 'Cost In Credits', fieldName: 'cost_in_credits' },
		{ label: 'Crew', fieldName: 'crew' },
		{ label: 'Length', fieldName: 'length' },
		{ label: 'Manufacturer', fieldName: 'manufacturer' },
		{ label: 'Max Atmosphering Speed', fieldName: 'max_atmosphering_speed' },
		{ label: 'Model', fieldName: 'model' },
		{ label: 'Passengers', fieldName: 'passengers' },
		{ label: 'Vehicle Class', fieldName: 'vehicle_class' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];
	starshipsColumns= [
		{ label: 'Name', fieldName: 'name' },
		{ label: 'MGLT', fieldName: 'MGLT' },
		{ label: 'cargo_capacity', fieldName: 'cargo_capacity' },
		{ label: 'consumables', fieldName: 'consumables' },
		{ label: 'cost_in_credits', fieldName: 'cost_in_credits' },
		{ label: 'crew', fieldName: 'crew' },
		{ label: 'hyperdrive_rating', fieldName: 'hyperdrive_rating' },
		{ label: 'length', fieldName: 'length' },
		{ label: 'manufacturer', fieldName: 'manufacturer' },
		{ label: 'max_atmosphering_speed', fieldName: 'max_atmosphering_speed' },
		{ label: 'model', fieldName: 'model' },
		{ label: 'passengers', fieldName: 'passengers' },
		{ label: 'starship_class', fieldName: 'starship_class' },
		{ label: 'URL', fieldName: 'url', type: 'url' },
	];

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
				this.peopleTableData = [...this.people];
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
