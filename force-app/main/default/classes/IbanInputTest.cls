/**
 * Created by Harmath Zsolt on 2025. 02. 11.
 */

@IsTest
private class IbanInputTest {
	@IsTest
	static void testBehavior() {
		IbanInputController.Result r1 = IbanInputController.getIban('hu');

		IbanInputController.Result r2 = new IbanInputController.Result(28, false);
	}
}
