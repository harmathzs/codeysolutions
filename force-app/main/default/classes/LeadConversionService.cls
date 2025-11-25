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

	@AuraEnabled
	public static Map<Id, Map<String, Object>> customConvertLeads(List<Id> leadIds) {
		Map<Id, Map<String, Object>> resultsMap = new Map<Id, Map<String, Object>>();

		LeadStatus convertStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=TRUE LIMIT 1];

		List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
		for (Id leadId : leadIds) {
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(leadId);
			lc.setConvertedStatus(convertStatus.ApiName);
			leadConverts.add(lc);
		}

		// Convert leads in bulk, allow partial success
		List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);

		for (Integer i = 0; i < results.size(); i++) {
			Database.LeadConvertResult lcr = results[i];
			Id leadId = leadIds[i];

			Map<String, Object> resultMap = new Map<String, Object>{
				'Account' => null,
				'Contact' => null,
				'Opportunity' => null,
				'Errors' => null
			};

			if (lcr.isSuccess()) {
				resultMap.put('Account', [SELECT Id FROM Account WHERE Id = :lcr.getAccountId()]);
				resultMap.put('Contact', [SELECT Id FROM Contact WHERE Id = :lcr.getContactId()]);
				resultMap.put('Opportunity', [SELECT Id FROM Opportunity WHERE Id = :lcr.getOpportunityId()]);
			} else {
				resultMap.put('Errors', lcr.getErrors());
			}
			resultsMap.put(leadId, resultMap);
		}
		return resultsMap;
	}
}
