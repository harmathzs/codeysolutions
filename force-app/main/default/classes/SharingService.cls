/**
 * Created by User on 2025. 07. 10..
 */

public with sharing class SharingService {
	public static void manualShareDog(Id recordToShareId, Id shareWithId) {
		// Create a new sharing object
		Dog__Share dogShare = new Dog__Share();

		// ID of the object we want to share
		dogShare.ParentId = recordToShareId;

		// ID of the person we want to share with
		dogShare.UserOrGroupId = shareWithId;

		// Access level - valid values are Read, Edit
		dogShare.AccessLevel = 'Edit';

		dogShare.RowCause = 'Manual';

		// Activate the defined access to the record
		insert dogShare;
	}
}
