public with sharing class OrderService {
	public String renderAs { get; set; }

	public OrderService(ApexPages.StandardController stdController) {
		renderAs = 'pdf';
	}
}
