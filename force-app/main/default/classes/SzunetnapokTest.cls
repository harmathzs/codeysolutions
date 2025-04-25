/**
 * Created by Harmath Zsolt on 2025. 04. 25..
 */

@IsTest
private class SzunetnapokTest {
	@IsTest
	static void testBehavior() {
		String responseBodyJson = '{\n' +
			'\t  "response": "OK",\n' +
			'\t  "year": 2025,\n' +
			'\t  "days": [\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-01-01",\n' +
			'\t\t  "name": "Újév",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "3"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-03-15",\n' +
			'\t\t  "name": "1848-as forradalom",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "6"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-04-18",\n' +
			'\t\t  "name": "Húsvét",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "5"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-04-20",\n' +
			'\t\t  "name": "Húsvét vasárnap",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "7"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-04-21",\n' +
			'\t\t  "name": "Húsvét hétfő",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "1"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-05-01",\n' +
			'\t\t  "name": "Munka ünnepe",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "4"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-05-02",\n' +
			'\t\t  "name": "Munka ünnepe",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "5"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-05-17",\n' +
			'\t\t  "name": "Áthelyezett munkanap (2025-05-02)",\n' +
			'\t\t  "type": "2",\n' +
			'\t\t  "weekday": "6"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-06-08",\n' +
			'\t\t  "name": "Pünkösd vasárnap",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "7"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-06-09",\n' +
			'\t\t  "name": "Pünkösdhétfő",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "1"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-08-20",\n' +
			'\t\t  "name": "Államalapítás ünnepe",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "3"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-10-18",\n' +
			'\t\t  "name": "Áthelyezett munkanap (2025-10-24)",\n' +
			'\t\t  "type": "2",\n' +
			'\t\t  "weekday": "6"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-10-23",\n' +
			'\t\t  "name": "1956-os forradalom",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "4"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-10-24",\n' +
			'\t\t  "name": "1956-os forradalom",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "5"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-11-01",\n' +
			'\t\t  "name": "Mindenszentek",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "6"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-12-13",\n' +
			'\t\t  "name": "Áthelyezett munkanap (2025-12-24)",\n' +
			'\t\t  "type": "2",\n' +
			'\t\t  "weekday": "6"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-12-24",\n' +
			'\t\t  "name": "Karácsony",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "3"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-12-25",\n' +
			'\t\t  "name": "Karácsony",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "4"\n' +
			'\t\t},\n' +
			'\t\t{\n' +
			'\t\t  "date": "2025-12-26",\n' +
			'\t\t  "name": "Karácsony",\n' +
			'\t\t  "type": "1",\n' +
			'\t\t  "weekday": "5"\n' +
			'\t\t}\n' +
			'\t  ]\n' +
			'\t}';

		SzunetnapokController.parseSzunetnapokJson(new List<String>{responseBodyJson});
	}
}
