@IsTest
private class WeatherTest {
	@IsTest
	static void testBehavior() {
		WeatherController controller = new WeatherController();
		controller.getWeatherJson();
	}
}
