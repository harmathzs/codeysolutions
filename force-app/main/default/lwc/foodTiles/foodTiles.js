/**
 * Created by Harmath Zsolt on 2025. 03. 17.
 */

import {LightningElement, wire} from 'lwc';

import {publish, MessageContext, subscribe} from 'lightning/messageService';
import RESTAURANT_CHANNEL from '@salesforce/messageChannel/restaurantChannel__c';

import getCodeysRestaurantMenus from '@salesforce/apex/RestaurantController.getCodeysRestaurantMenus';
import getAllFoods from '@salesforce/apex/RestaurantController.getAllFoods';

export default class FoodTiles extends LightningElement {
	subscription;
	@wire(MessageContext) messageContext;

	menusCustomSettings = {};
	foodsMap = {};
	foodsList = [];
	menus = {};

	async connectedCallback() {
		this.subscribeToMessageChannel();

		this.menusCustomSettings = await getCodeysRestaurantMenus();
		console.log('menusCustomSettings', this.menusCustomSettings);

		this.foodsMap = await getAllFoods();

		const menuA_ProductId = this.menusCustomSettings?.Menu_A_Product_Id__c;
		const menuB_ProductId = this.menusCustomSettings?.Menu_B_Product_Id__c;

		if (this.foodsMap.hasOwnProperty(menuA_ProductId)) {
			this.foodsMap[menuA_ProductId].isMenuA = true;
			this.menus.A = this.foodsMap[menuA_ProductId];
		}
		if (this.foodsMap.hasOwnProperty(menuB_ProductId)) {
			this.foodsMap[menuB_ProductId].isMenuB = true;
			this.menus.B = this.foodsMap[menuB_ProductId];
		}
		console.log('menus', JSON.stringify(this.menus));
		// {"A":{"Id":"01tgL000000MH6LQAW","Name":"Lentil stew with beef","Family":"Food","isMenuA":true},"B":{"Id":"01tgL000000MJyTQAW","Name":"Chili lime chicken wings","Family":"Food","isMenuB":true}}
		console.log('foodsMap', JSON.stringify(this.foodsMap));
		// {"01tgL000000MC6rQAG":{"Id":"01tgL000000MC6rQAG","Name":"Vegan lasagna","Family":"Food"},"01tgL000000MH6LQAW":{"Id":"01tgL000000MH6LQAW","Name":"Lentil stew with beef","Family":"Food","isMenuA":true},"01tgL000000MJyTQAW":{"Id":"01tgL000000MJyTQAW","Name":"Chili lime chicken wings","Family":"Food","isMenuB":true}}

		// Populate foodsList from foodsMap
		this.foodsList = Object.values(this.foodsMap);
		console.log('foodsList', JSON.stringify(this.foodsList));
	}

	subscribeToMessageChannel() {
		this.subscription = subscribe(
			this.messageContext,
			RESTAURANT_CHANNEL,
			(message) => this.handleIncomingMessage(message)
		);
	}

	handleIncomingMessage(message) {
		if (message?.messageType == 'FoodFilters') {
			console.log('message', message);
		}
	}

	handleFoodClick(event) {
		const foodId = event.currentTarget.dataset.id;
		// Handle the click event - maybe navigate to a detail page or show a modal
		console.log('Food clicked:', foodId);

		// Publish the message
		let message = {
			messageType: 'FoodTiles',
			payload: {
				foodId: foodId
			}
		};
		publish(this.messageContext, RESTAURANT_CHANNEL, message);
	}
}
