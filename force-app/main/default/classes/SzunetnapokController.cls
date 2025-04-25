/**
 * Created by Harmath Zsolt on 2025. 04. 25..
 */

public with sharing class SzunetnapokController {

	// szunetnapok.hu sample response body json:
	/*

	{
	  "response": "OK",
	  "year": 2025,
	  "days": [
		{
		  "date": "2025-01-01",
		  "name": "Újév",
		  "type": "1",
		  "weekday": "3"
		},
		{
		  "date": "2025-03-15",
		  "name": "1848-as forradalom",
		  "type": "1",
		  "weekday": "6"
		},
		{
		  "date": "2025-04-18",
		  "name": "Húsvét",
		  "type": "1",
		  "weekday": "5"
		},
		{
		  "date": "2025-04-20",
		  "name": "Húsvét vasárnap",
		  "type": "1",
		  "weekday": "7"
		},
		{
		  "date": "2025-04-21",
		  "name": "Húsvét hétfő",
		  "type": "1",
		  "weekday": "1"
		},
		{
		  "date": "2025-05-01",
		  "name": "Munka ünnepe",
		  "type": "1",
		  "weekday": "4"
		},
		{
		  "date": "2025-05-02",
		  "name": "Munka ünnepe",
		  "type": "1",
		  "weekday": "5"
		},
		{
		  "date": "2025-05-17",
		  "name": "Áthelyezett munkanap (2025-05-02)",
		  "type": "2",
		  "weekday": "6"
		},
		{
		  "date": "2025-06-08",
		  "name": "Pünkösd vasárnap",
		  "type": "1",
		  "weekday": "7"
		},
		{
		  "date": "2025-06-09",
		  "name": "Pünkösdhétfő",
		  "type": "1",
		  "weekday": "1"
		},
		{
		  "date": "2025-08-20",
		  "name": "Államalapítás ünnepe",
		  "type": "1",
		  "weekday": "3"
		},
		{
		  "date": "2025-10-18",
		  "name": "Áthelyezett munkanap (2025-10-24)",
		  "type": "2",
		  "weekday": "6"
		},
		{
		  "date": "2025-10-23",
		  "name": "1956-os forradalom",
		  "type": "1",
		  "weekday": "4"
		},
		{
		  "date": "2025-10-24",
		  "name": "1956-os forradalom",
		  "type": "1",
		  "weekday": "5"
		},
		{
		  "date": "2025-11-01",
		  "name": "Mindenszentek",
		  "type": "1",
		  "weekday": "6"
		},
		{
		  "date": "2025-12-13",
		  "name": "Áthelyezett munkanap (2025-12-24)",
		  "type": "2",
		  "weekday": "6"
		},
		{
		  "date": "2025-12-24",
		  "name": "Karácsony",
		  "type": "1",
		  "weekday": "3"
		},
		{
		  "date": "2025-12-25",
		  "name": "Karácsony",
		  "type": "1",
		  "weekday": "4"
		},
		{
		  "date": "2025-12-26",
		  "name": "Karácsony",
		  "type": "1",
		  "weekday": "5"
		}
	  ]
	}

	 */

// Inner class to represent the entire JSON response structure
	public class ResponseData {
		public String response;
		public Integer year;
		public List<Day> days;
	}

	// Inner class to represent individual day entries
	public class Day {
		public String inDate;
		public String name;
		public String type;
		public String weekday;
	}

	// Wrapper class for Flow output with Invocable Variables
	public class DayWrapper {
		@InvocableVariable(label='Date' description='Holiday date')
		public String inDate;

		@InvocableVariable(label='Name' description='Holiday name')
		public String name;

		@InvocableVariable(label='Type' description='Holiday type')
		public String type;

		@InvocableVariable(label='Weekday' description='Weekday number')
		public String weekday;
	}

	@InvocableMethod(label='Parse Szunetnapok JSON' description='Parses holiday data from szunetnapok.hu API response')
	public static List<DayWrapper> parseSzunetnapokJson(List<String> jsonInputs) {
		List<DayWrapper> results = new List<DayWrapper>();

		for(String jsonInput : jsonInputs) {
			ResponseData responseData = (ResponseData) JSON.deserialize(jsonInput, ResponseData.class);

			if(responseData.days != null) {
				for(Day day : responseData.days) {
					DayWrapper wrapper = new DayWrapper();
					wrapper.inDate = day.inDate;
					wrapper.name = day.name;
					wrapper.type = day.type;
					wrapper.weekday = day.weekday;
					results.add(wrapper);
				}
			}
		}
		return results;
	}
}
