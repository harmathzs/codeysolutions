/**
 * SOAP API webservice class for external systems
 *
 * @author Zsolt Harmath
 * @date 2025-11-11
 */
global class SoapWebservice {
	webService static Account[] getAllAccounts() {
		return [SELECT Id ,Name	,Phone FROM Account];
	}
	webService static Id insertNewLead(
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
