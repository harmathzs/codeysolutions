/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

trigger EmailMessageTrigger on EmailMessage (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	TriggerDispatcher.run(Schema.EmailMessage.SObjectType);
}
