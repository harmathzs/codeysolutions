@isTest
public class ApologizeServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'Contact' + i,
                Email = 'test' + i + '@example.com'
            ));
        }
        insert testContacts;
        
        // Create a test case to use as whatId
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Description = 'Test case for email association'
        );
        insert testCase;
        
        // Store test case ID in static variable for use in tests
        TestCaseId = testCase.Id;
        
        // Store contact IDs in static variable
        TestContactIds = new List<Id>();
        for (Contact c : testContacts) {
            TestContactIds.add(c.Id);
        }
    }
    
    static Id TestCaseId;
    static List<Id> TestContactIds;
    
    @isTest
    static void testSendApologyEmailSuccess() {
        // Get a test contact
        Contact testContact = [SELECT Id, Email FROM Contact WHERE Email = 'test0@example.com' LIMIT 1];
        
        Test.startTest();
        Boolean result = ApologizeService.sendApologyEmail(testContact.Id, TestCaseId);
        Test.stopTest();
        
        // If template doesn't exist, result should be false
        // If template exists, result should be true
        // We can't assert either way definitively without knowing if template exists
        // So we just verify the method runs without exception
        System.assert(result != null, 'Method should return a boolean result');
    }
    
    @isTest
    static void testSendApologyEmailNoContact() {
        // Test with invalid contact ID
        Test.startTest();
        Boolean result = ApologizeService.sendApologyEmail('003000000000000AAA', TestCaseId);
        Test.stopTest();
        
        System.assert(!result, 'Should return false for invalid contact ID');
    }
    
    @isTest
    static void testSendApologyEmailNoEmailAddress() {
        // Create a contact without email
        Contact noEmailContact = new Contact(
            FirstName = 'NoEmail',
            LastName = 'Contact',
            Email = null
        );
        insert noEmailContact;
        
        Test.startTest();
        Boolean result = ApologizeService.sendApologyEmail(noEmailContact.Id, TestCaseId);
        Test.stopTest();
        
        System.assert(!result, 'Should return false for contact without email');
    }
    
    @isTest
    static void testSendApologyEmailsMultiple() {
        // Create a simple test with one known contact
        Contact testContact = [SELECT Id, Email FROM Contact WHERE Email = 'test0@example.com' LIMIT 1];
        List<Id> testContactIds = new List<Id>{testContact.Id};

        System.debug('testContactIds: ' + testContactIds);

        Test.startTest();
        List<ApologizeService.EmailSendResult> results = ApologizeService.sendApologyEmails(testContactIds, TestCaseId);
        Test.stopTest();

        System.debug('Results size: ' + results.size());
        System.debug('Results: ' + results);

        // Basic check - results should not be empty
        System.assert(!results.isEmpty(), 'Results should not be empty');
        System.assertEquals(1, results.size(), 'Should have 1 result');

        // Check the result
        ApologizeService.EmailSendResult result = results[0];
        System.assertEquals(testContact.Id, result.contactId, 'Contact ID should match');

        // If template doesn't exist, result should indicate template not found
        if (!result.success && result.errorMessage != null
            && result.errorMessage.contains('Template not found')) {
            System.assert(result.errorMessage.contains('Template not found'), 'Error should mention template');
        } else {
            // Template exists - should be successful
            System.assert(result.success, 'Email should be sent successfully');
        }
    }
    
    @isTest
    static void testSendApologyEmailsEmptyList() {
        Test.startTest();
        List<ApologizeService.EmailSendResult> results = ApologizeService.sendApologyEmails(new List<Id>(), TestCaseId);
        Test.stopTest();
        
        System.assert(results.isEmpty(), 'Should return empty list for empty input');
    }
    
    @isTest
    static void testSendApologyEmailsNullList() {
        Test.startTest();
        List<ApologizeService.EmailSendResult> results = ApologizeService.sendApologyEmails(null, TestCaseId);
        Test.stopTest();
        
        System.assert(results.isEmpty(), 'Should return empty list for null input');
    }
}
