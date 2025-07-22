public with sharing class WeatherController {
	public String getWeatherJson() {
		HttpCalloutController.InputParams inputs = new HttpCalloutController.InputParams();
		inputs.method = 'GET';
		inputs.endpoint = 'https://api.open-meteo.com/v1/forecast?latitude=47.4984&longitude=19.0404&hourly=apparent_temperature,rain,visibility&current=apparent_temperature,rain,is_day,weather_code';

		HttpCalloutController.OutputParams[] outputs = HttpCalloutController.httpCallout(new List<HttpCalloutController.InputParams>{inputs});

		return outputs[0].responseBody;
	}

	public Map<String, Object> getWeatherMap {
		get {
			String weatherJson = getWeatherJson();
			if (String.isBlank(weatherJson)) {
				return new Map<String, Object>();
			} else {
				return (Map<String, Object>) JSON.deserializeUntyped(weatherJson);
			}
		}
	}
}
