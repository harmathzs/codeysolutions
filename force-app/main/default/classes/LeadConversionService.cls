public with sharing class LeadConversionService {
	@AuraEnabled
	public static Map<String, Object> customConvertLead(Lead lead) {
		Map<String, Object> resultMap = new Map<String, SObject>{
			'Account' => null,
			'Contact' => null,
			'Opportunity' => null,
			'Errors' => null
		};

		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(lead.Id);

		LeadStatus convertStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=TRUE LIMIT 1];
		lc.setConvertedStatus(convertStatus.ApiName);

		Database.LeadConvertResult lcr = Database.convertLead(lc);
		if (lcr.isSuccess()) {
			Account acc = [SELECT Id FROM Account WHERE Id = :lcr.getAccountId()];
			Contact contact = [SELECT Id FROM Contact WHERE Id = :lcr.getContactId()];
			Opportunity opp = [SELECT Id FROM Opportunity WHERE Id = :lcr.getOpportunityId()];

			resultMap.put('Account', acc);
			resultMap.put('Contact', contact);
			resultMap.put('Opportunity', opp);
		} else {
			resultMap.put('Errors', lcr.getErrors());
		}

		return resultMap;
	}
}
