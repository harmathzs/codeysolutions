/**
 * Created by Harmath Zsolt on 2025. 03. 17..
 */

import {LightningElement, wire} from 'lwc';

import getCodeysRestaurantMenus from '@salesforce/apex/RestaurantController.getCodeysRestaurantMenus';
import getMenus from '@salesforce/apex/RestaurantController.getProducts';

export default class FoodTiles extends LightningElement {
	menusCustomSettings = {};
	menus = {};

	async connectedCallback() {
		this.menusCustomSettings = await getCodeysRestaurantMenus();
		console.log('menusCustomSettings', this.menusCustomSettings);

		const menuA_ProductId = this.menusCustomSettings?.Menu_A_Product_Id__c;
		const menuB_ProductId = this.menusCustomSettings?.Menu_B_Product_Id__c;

		this.menus = await getMenus({productIds: [menuA_ProductId, menuB_ProductId]});

		console.log('menus', JSON.stringify(this.menus));
	}
}
