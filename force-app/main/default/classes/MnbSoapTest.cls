/**
 * Created by Harmath Zsolt on 2025. 02. 20.
 */

@IsTest
private class MnbSoapTest {
	// <MNBCurrentExchangeRates><Day date="2025-02-19"><Rate unit="1" curr="AUD">244,76</Rate><Rate unit="1" curr="BGN">205,27</Rate><Rate unit="1" curr="BRL">67,66</Rate><Rate unit="1" curr="CAD">271,08</Rate><Rate unit="1" curr="CHF">425,61</Rate><Rate unit="1" curr="CNY">52,84</Rate><Rate unit="1" curr="CZK">15,99</Rate><Rate unit="1" curr="DKK">53,82</Rate><Rate unit="1" curr="EUR">401,47</Rate><Rate unit="1" curr="GBP">485,24</Rate><Rate unit="1" curr="HKD">49,5</Rate><Rate unit="100" curr="IDR">2,36</Rate><Rate unit="1" curr="ILS">108,77</Rate><Rate unit="1" curr="INR">4,43</Rate><Rate unit="1" curr="ISK">2,74</Rate><Rate unit="100" curr="JPY">253,83</Rate><Rate unit="100" curr="KRW">26,71</Rate><Rate unit="1" curr="MXN">19,02</Rate><Rate unit="1" curr="MYR">86,67</Rate><Rate unit="1" curr="NOK">34,57</Rate><Rate unit="1" curr="NZD">220,39</Rate><Rate unit="1" curr="PHP">6,62</Rate><Rate unit="1" curr="PLN">96,54</Rate><Rate unit="1" curr="RON">80,66</Rate><Rate unit="1" curr="RSD">3,43</Rate><Rate unit="1" curr="RUB">4,24</Rate><Rate unit="1" curr="SEK">35,9</Rate><Rate unit="1" curr="SGD">286,68</Rate><Rate unit="1" curr="THB">11,42</Rate><Rate unit="1" curr="TRY">10,6</Rate><Rate unit="1" curr="UAH">9,23</Rate><Rate unit="1" curr="USD">384,96</Rate><Rate unit="1" curr="ZAR">20,91</Rate></Day></MNBCurrentExchangeRates>

	class mock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest request) {
			HttpResponse result = new HttpResponse();
			result.setStatusCode(200);
			result.setBody('<MNBCurrentExchangeRates><Day date="2025-02-19"><Rate unit="1" curr="AUD">244,76</Rate><Rate unit="1" curr="BGN">205,27</Rate><Rate unit="1" curr="BRL">67,66</Rate><Rate unit="1" curr="CAD">271,08</Rate><Rate unit="1" curr="CHF">425,61</Rate><Rate unit="1" curr="CNY">52,84</Rate><Rate unit="1" curr="CZK">15,99</Rate><Rate unit="1" curr="DKK">53,82</Rate><Rate unit="1" curr="EUR">401,47</Rate><Rate unit="1" curr="GBP">485,24</Rate><Rate unit="1" curr="HKD">49,5</Rate><Rate unit="100" curr="IDR">2,36</Rate><Rate unit="1" curr="ILS">108,77</Rate><Rate unit="1" curr="INR">4,43</Rate><Rate unit="1" curr="ISK">2,74</Rate><Rate unit="100" curr="JPY">253,83</Rate><Rate unit="100" curr="KRW">26,71</Rate><Rate unit="1" curr="MXN">19,02</Rate><Rate unit="1" curr="MYR">86,67</Rate><Rate unit="1" curr="NOK">34,57</Rate><Rate unit="1" curr="NZD">220,39</Rate><Rate unit="1" curr="PHP">6,62</Rate><Rate unit="1" curr="PLN">96,54</Rate><Rate unit="1" curr="RON">80,66</Rate><Rate unit="1" curr="RSD">3,43</Rate><Rate unit="1" curr="RUB">4,24</Rate><Rate unit="1" curr="SEK">35,9</Rate><Rate unit="1" curr="SGD">286,68</Rate><Rate unit="1" curr="THB">11,42</Rate><Rate unit="1" curr="TRY">10,6</Rate><Rate unit="1" curr="UAH">9,23</Rate><Rate unit="1" curr="USD">384,96</Rate><Rate unit="1" curr="ZAR">20,91</Rate></Day></MNBCurrentExchangeRates>');

			return result;
		}
	}

	@IsTest
	static void testScheduledExecute() {
		Test.setMock(HttpCalloutMock.class, new mock());

		MnbSoapSchedulable schedulable = new MnbSoapSchedulable();
		Test.startTest();
		schedulable.execute(null);
		Test.stopTest();
	}

	@IsTest static void testGetCurrencies() {
		Test.setMock(HttpCalloutMock.class, new mock());

		MnbSoapService.CustomBinding_MNBArfolyamServiceSoap instance = new MnbSoapService.CustomBinding_MNBArfolyamServiceSoap();
		instance.GetCurrencies();
		instance.GetCurrentExchangeRates();
	}

	@IsTest static void testGetCurrenciesResponseBody() {
		MnbSoapService.GetCurrenciesResponseBody currenciesResponseBody = new MnbSoapService.GetCurrenciesResponseBody();
		String GetCurrenciesResult = currenciesResponseBody.GetCurrenciesResult;
		String[] GetCurrenciesResult_type_info = currenciesResponseBody.GetCurrenciesResult_type_info;
		String[] apex_schema_type_info = currenciesResponseBody.apex_schema_type_info;
		String[] field_order_type_info = currenciesResponseBody.field_order_type_info;
	}
}
