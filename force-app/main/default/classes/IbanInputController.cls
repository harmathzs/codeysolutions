/**
 * Created by Harmath Zsolt on 2025. 02. 11.
 */

public with sharing class IbanInputController {

    @AuraEnabled(cacheable=true)
    public static IbanInputController.Result getIban(String countryCode) {
        IbanInputController.Result controllerResult;

        try {
//            DXP_RFQ_Defaults__mdt rfqMdt = [
//                    SELECT IBAN_length__c,
//                        Is_IBAN_Mandatory__c
//                    FROM DXP_RFQ_Defaults__mdt
//                    WHERE Company_Country_Code__c = :countryCode AND Iban_length__c != null
//                    LIMIT 1
//            ];
//            controllerResult = new IbanInputController.Result(
//                rfqMdt.IBAN_length__c,
//                rfqMdt.Is_IBAN_Mandatory__c
//            );
        } catch (QueryException e) {
            return null;
        }

        return controllerResult;
    }

    public class Result {
        @AuraEnabled public Decimal IBANLength;
        @AuraEnabled public Boolean isIBANMandatory;

        public Result(Decimal inIBANLength, Boolean inIsIBANMandatory) {
            IBANLength = inIBANLength;
            isIBANMandatory = inIsIBANMandatory;
        }
    }
}
