/**
 * Created by User on 2025. 10. 12.
 */

public with sharing class ConvertibleLeadsController {
	public Lead[] convertibleLeads {
		get {
			return [
				SELECT
					Id, CreatedDate
					,Name
					,Email
					,Company
					,Status
				FROM
					Lead
				WHERE
					NOT Status LIKE '%Converted%'
				LIMIT 100
			];
		}
	}
}
