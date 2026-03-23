public class ApologizeService {
    /**
     * Sends an apology email to a contact using the Apologize_Email_Template_1 template
     * 
     * @param contactId The ID of the Contact to send the email to
     * @param whatId Optional ID of an object to associate with the email (e.g., Case, Opportunity)
     * @return Boolean indicating whether the email was sent successfully
     */
    public static Boolean sendApologyEmail(Id contactId, Id whatId) {
        try {
            // Query the contact information
            Contact contact = [SELECT Id, Name, Email, FirstName, LastName 
                             FROM Contact WHERE Id = :contactId LIMIT 1];
            
            if (contact == null || String.isBlank(contact.Email)) {
                System.debug('ApologizeService: No valid contact or email address found');
                return false;
            }
            
            // Query the email template
            EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body, DeveloperName
                                   FROM EmailTemplate 
                                   WHERE DeveloperName = 'Apologize_Email_Template_1' 
                                   LIMIT 1];
            
            if (template == null) {
                System.debug('ApologizeService: Email template Apologize_Email_Template_1 not found');
                return false;
            }
            
            // Create the email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            // Set target object ID (Contact ID)
            email.setTargetObjectId(contact.Id);
            
            // Set what ID if provided (associates email with an object like Case, Opportunity)
            if (whatId != null) {
                email.setWhatId(whatId);
            }
            
            // Set template ID
            email.setTemplateId(template.Id);
            
            // Set sender display name (optional)
            email.setSenderDisplayName('Customer Support');
            
            // Set save as activity flag (optional)
            email.setSaveAsActivity(true);
            
            // Send the email
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
            // Check if email was sent successfully
            if (!sendResults[0].isSuccess()) {
                System.debug('ApologizeService: Failed to send email: ' + sendResults[0].getErrors()[0].getMessage());
                return false;
            }
            
            System.debug('ApologizeService: Email sent successfully to ' + contact.Email);
            return true;
            
        } catch (Exception e) {
            System.debug('ApologizeService: Exception occurred: ' + e.getMessage());
            System.debug('ApologizeService: Stack trace: ' + e.getStackTraceString());
            return false;
        }
    }
    
    /**
     * Sends apology emails to multiple contacts
     * 
     * @param contactIds List of Contact IDs to send emails to
     * @param whatId Optional ID of an object to associate with the emails
     * @return List of results indicating success/failure for each contact
     */
    public static List<EmailSendResult> sendApologyEmails(List<Id> contactIds, Id whatId) {
        List<EmailSendResult> results = new List<EmailSendResult>();
        
        if (contactIds == null || contactIds.isEmpty()) {
            return results;
        }
        
        // Query all contacts at once for efficiency
        List<Contact> contacts = [SELECT Id, Name, Email, FirstName, LastName 
                                 FROM Contact WHERE Id IN :contactIds];
        
        // Query the email template
        EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body, DeveloperName
                               FROM EmailTemplate 
                               WHERE DeveloperName = 'Apologize_Email_Template_1' 
                               LIMIT 1];
        
        if (template == null) {
            System.debug('ApologizeService: Email template Apologize_Email_Template_1 not found');
            // Return error results for all contact IDs
            for (Id contactId : contactIds) {
                results.add(new EmailSendResult(contactId, false, 'Template not found'));
            }
            return results;
        }
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Contact contact : contacts) {
            if (contact != null && !String.isBlank(contact.Email)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(contact.Id);
                
                if (whatId != null) {
                    email.setWhatId(whatId);
                }
                
                email.setTemplateId(template.Id);
                email.setSenderDisplayName('Customer Support');
                email.setSaveAsActivity(true);
                
                emails.add(email);
            } else {
                results.add(new EmailSendResult(contact != null ? contact.Id : null, false, 'Invalid contact or email'));
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(emails);
            
            // Map results back to contact IDs
            Integer resultIndex = 0;
            for (Contact contact : contacts) {
                if (contact != null && !String.isBlank(contact.Email)) {
                    Boolean success = sendResults[resultIndex].isSuccess();
                    String errorMessage = null;
                    
                    if (!success && sendResults[resultIndex].getErrors() != null && !sendResults[resultIndex].getErrors().isEmpty()) {
                        errorMessage = sendResults[resultIndex].getErrors()[0].getMessage();
                    }
                    
                    results.add(new EmailSendResult(contact.Id, success, errorMessage));
                    resultIndex++;
                }
            }
        }
        
        return results;
    }
    
    /**
     * Inner class to represent email send results
     */
    public class EmailSendResult {
        public Id contactId;
        public Boolean success;
        public String errorMessage;
        
        public EmailSendResult(Id contactId, Boolean success, String errorMessage) {
            this.contactId = contactId;
            this.success = success;
            this.errorMessage = errorMessage;
        }
    }
}
