/**
 * SOAP API webservice class for external systems
 *
 * @author Zsolt Harmath
 * @date 2025-11-11
 */
global class SoapWebservice {
	webService static List<String> getAllAccountNames() {
		String[] result = new List<String>();
		for (Account acc: [SELECT Name FROM Account]) {
			result.add(acc.Name);
		}
		return result;
	}

	webService static String insertNewLead(
		String firstName, String lastName,
		String email, String phone,
		String company
	) {
		Lead lead = new Lead(
			FirstName=firstName,
			LastName=lastName,
			Email=email,
			Phone=phone,
			Company=company
		);
		insert lead;
		return lead.Id;
	}
}
