/**
 * Created by Harmath Zsolt on 2025. 02. 19.
 */

public with sharing class MnbSoapAsync implements Queueable, Database.AllowsCallouts {
	public void execute(QueueableContext context) {
		MnbSoapService.CustomBinding_MNBArfolyamServiceSoap soapService = new MnbSoapService.CustomBinding_MNBArfolyamServiceSoap();
		String currentRatesXml = soapService.GetCurrentExchangeRates();
		if (Test.isRunningTest()) currentRatesXml = '<MNBCurrentExchangeRates><Day date="2025-02-19"><Rate unit="1" curr="AUD">244,76</Rate><Rate unit="1" curr="BGN">205,27</Rate><Rate unit="1" curr="BRL">67,66</Rate><Rate unit="1" curr="CAD">271,08</Rate><Rate unit="1" curr="CHF">425,61</Rate><Rate unit="1" curr="CNY">52,84</Rate><Rate unit="1" curr="CZK">15,99</Rate><Rate unit="1" curr="DKK">53,82</Rate><Rate unit="1" curr="EUR">401,47</Rate><Rate unit="1" curr="GBP">485,24</Rate><Rate unit="1" curr="HKD">49,5</Rate><Rate unit="100" curr="IDR">2,36</Rate><Rate unit="1" curr="ILS">108,77</Rate><Rate unit="1" curr="INR">4,43</Rate><Rate unit="1" curr="ISK">2,74</Rate><Rate unit="100" curr="JPY">253,83</Rate><Rate unit="100" curr="KRW">26,71</Rate><Rate unit="1" curr="MXN">19,02</Rate><Rate unit="1" curr="MYR">86,67</Rate><Rate unit="1" curr="NOK">34,57</Rate><Rate unit="1" curr="NZD">220,39</Rate><Rate unit="1" curr="PHP">6,62</Rate><Rate unit="1" curr="PLN">96,54</Rate><Rate unit="1" curr="RON">80,66</Rate><Rate unit="1" curr="RSD">3,43</Rate><Rate unit="1" curr="RUB">4,24</Rate><Rate unit="1" curr="SEK">35,9</Rate><Rate unit="1" curr="SGD">286,68</Rate><Rate unit="1" curr="THB">11,42</Rate><Rate unit="1" curr="TRY">10,6</Rate><Rate unit="1" curr="UAH">9,23</Rate><Rate unit="1" curr="USD">384,96</Rate><Rate unit="1" curr="ZAR">20,91</Rate></Day></MNBCurrentExchangeRates>';
		System.debug('MnbSoapSchedulable currentRatesXml: ');
		System.debug(currentRatesXml);

		Map<String, MNB_Currency_Rate__c> ratesToHufMap = new Map<String, MNB_Currency_Rate__c>();

		DOM.Document doc = new Dom.Document();
		doc.load(currentRatesXml);

		// Get the root element
		DOM.XmlNode root = doc.getRootElement();

		// Get the Day element
		DOM.XmlNode dayNode = root.getChildElements()[0];

		// Get all Rate elements
		List<DOM.XmlNode> rateNodes = dayNode.getChildElements();

		for(DOM.XmlNode rateNode : rateNodes) {
			MNB_Currency_Rate__c rate = new MNB_Currency_Rate__c();
			rate.Base_Currency_Name__c = rateNode.getAttribute('curr', rateNode.getNamespace());
			rate.Counter_Currency_Name__c = 'HUF';
			rate.Unit__c = Integer.valueOf(rateNode.getAttribute('unit', rateNode.getNamespace()));
			rate.Unique_Key__c = rate.Base_Currency_Name__c + '_' +
				rate.Counter_Currency_Name__c + '_' +
				rate.Unit__c;
			// Replace comma with dot for decimal parsing
			String rateValue = rateNode.getText().replace(',', '.');
			rate.Rate__c = Decimal.valueOf(rateValue);

			ratesToHufMap.put(rate.Base_Currency_Name__c, rate);
		}

		System.debug('ratesToHufMap before upsert: '+ratesToHufMap);
		upsert ratesToHufMap.values() Unique_Key__c;
		System.debug('ratesToHufMap after upsert: '+ratesToHufMap);
	}
}
