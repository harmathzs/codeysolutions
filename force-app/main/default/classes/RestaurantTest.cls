/**
 * Created by Harmath Zsolt on 2025. 03. 18..
 */

@IsTest
private class RestaurantTest {
	@IsTest
	static void testgetCodeysRestaurantMenus() {
		RestaurantController.getCodeysRestaurantMenus();
	}

	@IsTest static void testgetAllFoods() {
		RestaurantController.getAllFoods();
	}
}
