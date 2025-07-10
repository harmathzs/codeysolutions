/**
 * Created by User on 2025. 07. 10..
 */

@IsTest
private class SharingTest {
	@IsTest
	static void testBehavior() {
		Dog__c fido = new Dog__c(Name='Fido');
		insert fido;

		Id recordToShareId = fido.Id;
		Id shareWithId = UserInfo.getUserId();
		Dog__Share result;
		try {
			result = SharingService.manualShareDog(recordToShareId, shareWithId);
		} catch (Exception e) {
			System.debug(e.getMessage());
		}

		//System.assertNotEquals(null, result);
	}
}
