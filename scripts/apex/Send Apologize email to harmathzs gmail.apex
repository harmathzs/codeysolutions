/* Send Apologize email to harmathzs gmail */
Contact harmathzs = [SELECT Id, Email FROM Contact WHERE Email='harmathzs@gmail.com' LIMIT 1];
Boolean success = ApologizeService.sendApologyEmail(harmathzs.Id, null);
System.debug('success: '+success);
