// Custom Convert Lead by Apex
Lead lead = [
        SELECT Id
            ,Name
            ,Company
            ,Email
        FROM Lead
        WHERE 
            Email = 'freddy@convertible.com'
];
System.debug('lead: '+lead);

Map<String, Object> conversionResults = LeadConversionService.customConvertLead(lead);
System.debug('conversionResults: '+conversionResults);
