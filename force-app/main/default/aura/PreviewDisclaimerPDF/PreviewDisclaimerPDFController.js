/**
 * Created by Harmath Zsolt on 2025. 03. 11..
 */

({
	generatePDF : function(component, event, helper) {
		// If you need to generate the PDF dynamically, keep the Apex call
		// var action = component.get("c.generatePDF");
		// action.setCallback(this, function(response) {
		//     var state = response.getState();
		//     if (state === "SUCCESS") {
		//         component.set("v.pdfUrl", response.getReturnValue());
		//         component.set("v.showModal", true);
		//     }
		// });
		// $A.enqueueAction(action);

		// If you're using a static Visualforce page, you can simply do:
		component.set("v.showModal", true);
	},

	handleCreateFile  : function(component, event, helper) {
		console.log('createFile');
		// Implement file creation logic
		var action = component.get("c.createFile");
		action.setParams({
			"base64PDF": component.get("v.pdfUrl").split(',')[1]
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var fileId = response.getReturnValue();
				if (fileId) {
					component.set("v.resultText", "Success: File created successfully. Id: "+fileId);
				} else {
					component.set("v.resultText", "Error: File creation failed.");
				}
			} else {
				component.set("v.resultText", "Error: An error occurred while creating the file.");
			}
		});
		$A.enqueueAction(action);
	},

	downloadPDF : function(component, event, helper) {
		var pdfUrl = component.get("v.pdfUrl");
		var link = document.createElement("a");
		link.href = pdfUrl;
		//link.target = "_blank";
		var now = new Date().getDate();
		link.download = "Generated Disclaimer PDF - "+ now.toString() +".pdf";
		link.click();
	},

	closeModal : function(component, event, helper) {
		console.log('closeModal');
		component.set("v.showModal", false);
	}
});
