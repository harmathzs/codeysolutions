@IsTest
private class DynamicApexTest {
	@IsTest
	static void testDescribe() {
		// Access a token for Account by accessing the sObjectType member variable
		Schema.SObjectType o1 = Account.SObjectType;
		System.debug('Account.SObjectType: '+o1);
		// DEBUG|Account.SObjectType: Account

		// Access a token for Contact by calling the getSObjectType method on Contact variable
		Contact c = new Contact();
		Schema.SObjectType o2 = c.getSObjectType();
		System.debug('Contact getSObjectType: '+o2);
		// DEBUG|Contact getSObjectType: Contact

		// Access the describe result
		Schema.DescribeSObjectResult or1 = Account.SObjectType.getDescribe();
		System.debug('Account getDescribe: '+or1);
		// DEBUG|Account getDescribe: Schema.DescribeSObjectResult[getAssociateEntityType=null;getAssociateParentEntity=null;getDataTranslationEnabled=null;getDefaultImplementation=null;getHasSubtypes=false;getImplementedBy=null;getImplementsInterfaces=null;getIsInterface=false;getIsSubtype=false;getKeyPrefix=001;getLabel=Account;getLabelPlural=Accounts;getName=Account;getRecordTypeInfosByDeveloperName={Academic_Program=Schema.RecordTypeInfo[getDeveloperName=Academic_Program;getName=Academic Program;getRecordTypeId=012gL000000NI4HQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Administrative=Schema.RecordTypeInfo[getDeveloperName=Administrative;getName=Administrative;getRecordTypeId=012gL000000NI4IQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Business_Organization=Schema.RecordTypeInfo[getDeveloperName=Business_Organization;getName=Business Organization;getRecordTypeId=012gL000000NI4JQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Educational_Institution=Schema.RecordTypeInfo[getDeveloperName=Educational_Institution;getName=Educational Institution;getRecordTypeId=012gL000000NI4KQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], HH_Account=Schema.RecordTypeInfo[getDeveloperName=HH_Account;getName=Household Account;getRecordTypeId=012gL000000NI4LQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Master=Schema.RecordTypeInfo[getDeveloperName=Master;getName=Master;getRecordTypeId=012000000000000AAA;isActive=true;isAvailable=true;isDefaultRecordTypeMapping=true;isMaster=true;], Sports_Organization=Schema.RecordTypeInfo[getDeveloperName=Sports_Organization;getName=Sports Organization;getRecordTypeId=012gL000000NI4MQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], University_Department=Schema.RecordTypeInfo[getDeveloperName=University_Department;getName=University Department;getRecordTypeId=012gL000000NI4NQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;]};getSObjectDescribeOption=DEFERRED;isAccessible=true;isCreateable=true;isCustom=false;isCustomSetting=false;isDeletable=true;isDeprecatedAndHidden=false;isFeedEnabled=true;isMergeable=true;isMruEnabled=true;isQueryable=true;isSearchable=true;isUndeletable=true;isUpdateable=true;]
		Schema.DescribeSObjectResult or2 = Schema.SObjectType.Account;
		System.debug('Schema.SObjectType.Account: '+or2);
		// DEBUG|Schema.SObjectType.Account: Schema.DescribeSObjectResult[getAssociateEntityType=null;getAssociateParentEntity=null;getDataTranslationEnabled=null;getDefaultImplementation=null;getHasSubtypes=false;getImplementedBy=null;getImplementsInterfaces=null;getIsInterface=false;getIsSubtype=false;getKeyPrefix=001;getLabel=Account;getLabelPlural=Accounts;getName=Account;getRecordTypeInfosByDeveloperName={Academic_Program=Schema.RecordTypeInfo[getDeveloperName=Academic_Program;getName=Academic Program;getRecordTypeId=012gL000000NI4HQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Administrative=Schema.RecordTypeInfo[getDeveloperName=Administrative;getName=Administrative;getRecordTypeId=012gL000000NI4IQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Business_Organization=Schema.RecordTypeInfo[getDeveloperName=Business_Organization;getName=Business Organization;getRecordTypeId=012gL000000NI4JQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Educational_Institution=Schema.RecordTypeInfo[getDeveloperName=Educational_Institution;getName=Educational Institution;getRecordTypeId=012gL000000NI4KQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], HH_Account=Schema.RecordTypeInfo[getDeveloperName=HH_Account;getName=Household Account;getRecordTypeId=012gL000000NI4LQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Master=Schema.RecordTypeInfo[getDeveloperName=Master;getName=Master;getRecordTypeId=012000000000000AAA;isActive=true;isAvailable=true;isDefaultRecordTypeMapping=true;isMaster=true;], Sports_Organization=Schema.RecordTypeInfo[getDeveloperName=Sports_Organization;getName=Sports Organization;getRecordTypeId=012gL000000NI4MQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], University_Department=Schema.RecordTypeInfo[getDeveloperName=University_Department;getName=University Department;getRecordTypeId=012gL000000NI4NQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;]};getSObjectDescribeOption=DEFERRED;isAccessible=true;isCreateable=true;isCustom=false;isCustomSetting=false;isDeletable=true;isDeprecatedAndHidden=false;isFeedEnabled=true;isMergeable=true;isMruEnabled=true;isQueryable=true;isSearchable=true;isUndeletable=true;isUpdateable=true;]

		Map<String, Schema.SObjectField> m = Schema.SObjectType.Lead.fields.getMap();
		System.debug('getMap: '+m);
		// DEBUG|getMap: {address=Address, annualrevenue=AnnualRevenue, city=City, cleanstatus=CleanStatus, company=Company, companydunsnumber=CompanyDunsNumber, convertedaccountid=ConvertedAccountId, convertedcontactid=ConvertedContactId, converteddate=ConvertedDate, convertedopportunityid=ConvertedOpportunityId, ...}

		Schema.SObjectField f1 = Account.Name;
		System.debug('Account.Name: '+f1);
		// DEBUG|Account.Name: Name
		Schema.DescribeFieldResult fr = Schema.SObjectType.Contact.fields.LastName;
		System.debug('Schema.SObjectType.Contact.fields.LastName: '+fr);
		// DEBUG|Schema.SObjectType.Contact.fields.LastName: Schema.DescribeFieldResult[getByteLength=240;getCalculatedFormula=null;getCompoundFieldName=Name;getController=null;getDataTranslationEnabled=null;getDefaultValue=null;getDefaultValueFormula=null;getDigits=0;getFilteredLookupInfo=null;getInlineHelpText=null;getLabel=Last Name;getLength=80;getLocalName=LastName;getMask=null;getMaskType=null;getName=LastName;getPrecision=0;getReferenceTargetField=null;getRelationshipName=null;getRelationshipOrder=null;getScale=0;getSoapType=STRING;getSobjectField=LastName;getSObjectType=Contact;getType=STRING;isAccessible=true;isAggregatable=true;isAiPredictionField=false;isAutoNumber=false;isCalculated=false;isCascadeDelete=false;isCaseSensitive=false;isCreateable=true;isCustom=false;isDefaultedOnCreate=false;isDependentPicklist=false;isDeprecatedAndHidden=false;isDisplayLocationInDecimal=false;isEncrypted=false;isExternalId=false;isFilterable=true;isFormulaTreatNullNumberAsZero=false;isGroupable=true;isHighScaleNumber=false;isHtmlFormatted=false;isIdLookup=false;isNameField=false;isNamePointing=false;isNillable=false;isPermissionable=false;isQueryByDistance=false;isRestrictedDelete=false;isSearchPrefilterable=false;isSortable=true;isUnique=false;isUpdateable=true;isWriteRequiresMasterRead=false;]

		String[] objectTypes = new String[]{'Account'};
		Schema.DescribeSObjectResult[] results = Schema.describeSObjects(objectTypes);
		System.debug('describeSObjects: '+results);
		// DEBUG|describeSObjects: (Schema.DescribeSObjectResult[getAssociateEntityType=null;getAssociateParentEntity=null;getDataTranslationEnabled=null;getDefaultImplementation=null;getHasSubtypes=false;getImplementedBy=null;getImplementsInterfaces=null;getIsInterface=false;getIsSubtype=false;getKeyPrefix=001;getLabel=Account;getLabelPlural=Accounts;getName=Account;getRecordTypeInfosByDeveloperName={Academic_Program=Schema.RecordTypeInfo[getDeveloperName=Academic_Program;getName=Academic Program;getRecordTypeId=012gL000000NI4HQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Administrative=Schema.RecordTypeInfo[getDeveloperName=Administrative;getName=Administrative;getRecordTypeId=012gL000000NI4IQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Business_Organization=Schema.RecordTypeInfo[getDeveloperName=Business_Organization;getName=Business Organization;getRecordTypeId=012gL000000NI4JQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Educational_Institution=Schema.RecordTypeInfo[getDeveloperName=Educational_Institution;getName=Educational Institution;getRecordTypeId=012gL000000NI4KQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], HH_Account=Schema.RecordTypeInfo[getDeveloperName=HH_Account;getName=Household Account;getRecordTypeId=012gL000000NI4LQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], Master=Schema.RecordTypeInfo[getDeveloperName=Master;getName=Master;getRecordTypeId=012000000000000AAA;isActive=true;isAvailable=true;isDefaultRecordTypeMapping=true;isMaster=true;], Sports_Organization=Schema.RecordTypeInfo[getDeveloperName=Sports_Organization;getName=Sports Organization;getRecordTypeId=012gL000000NI4MQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;], University_Department=Schema.RecordTypeInfo[getDeveloperName=University_Department;getName=University Department;getRecordTypeId=012gL000000NI4NQAW;isActive=true;isAvailable=false;isDefaultRecordTypeMapping=false;isMaster=false;]};getSObjectDescribeOption=DEFERRED;isAccessible=true;isCreateable=true;isCustom=false;isCustomSetting=false;isDeletable=true;isDeprecatedAndHidden=false;isFeedEnabled=true;isMergeable=true;isMruEnabled=true;isQueryable=true;isSearchable=true;isUndeletable=true;isUpdateable=true;])
		Boolean flag = results[0].isAccessible();
		System.debug('isAccessible: '+flag);
		// DEBUG|isAccessible: true

		Map<String, Schema.SObjectType> objectMap = Schema.getGlobalDescribe();
		System.debug('getGlobalDescribe: '+objectMap);
		// DEBUG|getGlobalDescribe: {acceptedeventrelation=AcceptedEventRelation, account=Account, accountbrand=AccountBrand, accountbrandshare=AccountBrandShare, accountchangeevent=AccountChangeEvent, accountcleaninfo=AccountCleanInfo, accountcleaninfochangeevent=AccountCleanInfoChangeEvent, accountcontactrole=AccountContactRole, accountcontactrolechangeevent=AccountContactRoleChangeEvent, accountfeed=AccountFeed, ...}
	}
	@IsTest
	static void testPicklist() {
		// Retrieve Program Enrollment Status field metadata
		Schema.DescribeFieldResult fieldStatus = hed__Program_Enrollment__c.hed__Enrollment_Status__c.getDescribe();
		// Retrieve picklist entries
		Schema.PicklistEntry[] picklistItems = fieldStatus.getPicklistValues();
		for (Schema.PicklistEntry picklistItem: picklistItems) {
			System.debug('Label: '+picklistItem.getLabel()+'; Value: '+picklistItem.getValue());
			// DEBUG|Label: Full-time; Value: Full-time
			// DEBUG|Label: Half-time; Value: Half-time
			// DEBUG|Label: Less than half-time; Value: Less than half-time
		}
	}
}
