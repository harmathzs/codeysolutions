/**
 * Created by User on 2025. 07. 17..
 */

@IsTest
private class ExceptionsTest {
	@IsTest
	static void testExceptionHandling() {
		try {
			String s;
			System.debug('This code could contain an exception!');
			Integer i = s.length();
			System.debug('This code does not contain an exception!');
		} catch (Exception e) {
			System.debug('The following exception has occurred: '+e.getMessage()+'!');
			// DEBUG|The following exception has occurred: Attempt to de-reference a null object!
		} finally {
			System.debug('This statement is being executed in the finally block!');
		}
	}

	@IsTest
	static void testDmlException() {
		try {
			Contact con = new Contact();
			insert con;
		} catch (DmlException de) {
			System.debug('The following exception has occurred: '+de.getTypeName()+'.');
			// DEBUG|The following exception has occurred: System.DmlException.
			System.debug('The associated error message is as follows:');
			System.debug(de.getMessage());
			// DEBUG|Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]
		}
	}

	@IsTest
	static void testListException() {
		try {
			Contact[] contacts = new List<Contact>();
			Contact c = new Contact(LastName='Connor');
			contacts.add(c);
			Contact con = contacts.get(1);
		} catch (ListException le) {
			System.debug('The following exception has occurred '+le.getTypeName());
			// DEBUG|The following exception has occurred System.ListException
			System.debug('The associated error is as follows:');
			System.debug(le.getMessage());
			// DEBUG|List index out of bounds: 1
		}
	}

	@IsTest
	static void testNullPointerException() {
		try {
			Contact con = new Contact(LastName='Morty');
			String s;
			con.FirstName = s;
			s.containsWhitespace();
		} catch (NullPointerException npe) {
			System.debug('The following exception has occurred: '+npe.getTypeName());
			// DEBUG|The following exception has occurred: System.NullPointerException
			System.debug('The associated error message is as follows:');
			System.debug(npe.getMessage());
			// DEBUG|Attempt to de-reference a null object
		}
	}

	@IsTest
	static void testQueryException() {
		try {
			Contact[] contacts = [SELECT Id, FirstName, LastName FROM Contact];
			Integer size = contacts.size();
			System.debug('The size of the contact list is '+size);
			Contact c = [SELECT Id, FirstName, LastName FROM Contact];
		} catch (QueryException qe) {
			System.debug('The following exception has occurred: '+qe.getTypeName());
			// DEBUG|The following exception has occurred: System.QueryException
			System.debug('The associated error message is as follows:');
			System.debug(qe.getMessage());
			// DEBUG|List has no rows for assignment to SObject
		}
	}

	@IsTest
	static void testSObjectException() {
		Contact c = new Contact(LastName='Test');
		insert c;

		try {
			Contact con = [SELECT Id, LastName FROM Contact LIMIT 1];
			String s1, s2;
			s1 = con.FirstName;
			s2 = con.LastName;
		} catch (SObjectException soe) {
			System.debug('The following exception has occurred: '+soe.getTypeName());
			// DEBUG|The following exception has occurred: System.SObjectException
			System.debug('The associated error message is as follows:');
			System.debug(soe.getMessage());
			// DEBUG|SObject row was retrieved via SOQL without querying the requested field: Contact.FirstName
		}
	}

	@IsTest
	static void testExceptionMethods() {
		try {
			Integer b = 0;
			Integer c = 1 / b;
		} catch (Exception e) {
			System.debug('getMessage: '+e.getMessage()); // DEBUG|getMessage: Divide by 0
			System.debug('getCause: '+e.getCause()); // DEBUG|getCause: null
			System.debug('getLineNumber: '+e.getLineNumber()); // DEBUG|getLineNumber: 107
			System.debug('getStackTraceString: '+e.getStackTraceString()); // DEBUG|getStackTraceString: Class.ExceptionsTest.testExceptionMethods: line 107, column 1
			System.debug('getTypeName: '+e.getTypeName()); // DEBUG|getTypeName: System.MathException
		}
	}

	@IsTest
	static void testDmlExceptionMethods() {
		try {
			Contact con = new Contact();
			insert con;
		} catch (DmlException e) {
			System.debug('getMessage: '+e.getMessage()); // DEBUG|getMessage: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]
			System.debug('getCause: '+e.getCause()); // DEBUG|getCause: null
			System.debug('getLineNumber: '+e.getLineNumber()); // DEBUG|getLineNumber: 121
			System.debug('getStackTraceString: '+e.getStackTraceString()); // DEBUG|getStackTraceString: Class.ExceptionsTest.testDmlExceptionMethods: line 121, column 1
			System.debug('getTypeName: '+e.getTypeName()); // DEBUG|getTypeName: System.DmlException

			System.debug('getDmlFieldNames: '+e.getDmlFieldNames(0)); // DEBUG|getDmlFieldNames: (LastName)
			System.debug('getDmlId: '+e.getDmlId(0)); // DEBUG|getDmlId: null
			System.debug('getDmlMessage: '+e.getDmlMessage(0)); // DEBUG|getDmlMessage: Required fields are missing: [LastName]
			System.debug('getNumDml: '+e.getNumDml()); // DEBUG|getNumDml: 1
		}
	}

	@IsTest
	static void testCalloutException() {
		Account acc = new Account(Name='John Doe');
		insert acc;

		try {
			HttpRequest req = new HttpRequest();
			req.setEndpoint('https://fake.test');

			Http http = new Http();
			HttpResponse res = http.send(req);
			// EXCEPTION_THROWN|[146]|System.TypeException: Methods defined as TestMethod do not support Web service callouts

			String responseBodyStr = res.getBody();
			System.debug('Response:');
			System.debug(responseBodyStr);
		} catch (Exception e) {
			System.debug('getMessage: '+e.getMessage());
			// DEBUG|getMessage: Methods defined as TestMethod do not support Web service callouts
		}
	}
}
