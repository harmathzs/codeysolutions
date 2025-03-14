/**
 * Created by Harmath Zsolt on 2025. 03. 14..
 */

import {LightningElement, api} from 'lwc';

export default class AiAnswerer extends LightningElement {
	@api question;
	@api answer;
}
