/**
 * Created by Harmath Zsolt on 2025. 04. 16..
 */

@RestResource(urlMapping='/typeformwebhook')
global with sharing class TypeformWebhookListener {
	@HttpPost
	global static void handleWebhook() {
		RestRequest req = RestContext.request;
		System.debug('TypeformWebhookListener handleWebhook req: '+req);
		if (req!=null) {
			String requestBody = req.requestBody.toString();
			System.debug('TypeformWebhookListener handleWebhook requestBody: '+requestBody);
		}

		// {
		//  "event_id": "01JRZGAEWCAH1M3EH31XYZDW0S",
		//  "event_type": "form_response",
		//  "form_response": {
		//    "form_id": "A1hDxGGe",
		//    "token": "6ldje6y7smus511ch86ldj0bcjfl3e2m",
		//    "landed_at": "2025-04-16T14:26:36Z",
		//    "submitted_at": "2025-04-16T14:33:49Z",
		//    "definition": {
		//      "id": "A1hDxGGe",
		//      "title": "Fill this form for test coupon",
		//      "fields": [
		//        {
		//          "id": "dpN7FpUkEdVc",
		//          "ref": "f8336747-afe6-46fb-ad09-fc1a98a9ec65",
		//          "type": "short_text",
		//          "title": "What is your name?",
		//          "properties": {}
		//        },
		//        {
		//          "id": "X1lJ8iinKvjH",
		//          "ref": "00ef3571-8787-4f6d-8d03-acdf746969be",
		//          "type": "email",
		//          "title": "What is your email address?",
		//          "properties": {}
		//        },
		//        {
		//          "id": "9QmKI5zFZPGm",
		//          "ref": "5a9a8039-5574-4fa9-8404-eae2437250d7",
		//          "type": "short_text",
		//          "title": "What is the name of your company?",
		//          "properties": {}
		//        },
		//        {
		//          "id": "NWURJERnyf7o",
		//          "ref": "2abb78cb-149e-41a1-a998-a92a4050f60e",
		//          "type": "phone_number",
		//          "title": "What is your phone number? (Optional)",
		//          "properties": {}
		//        },
		//        {
		//          "id": "SiSwcuE6aXMa",
		//          "ref": "c7871265-ae53-42be-8ef8-b0b0f5f5c5eb",
		//          "type": "dropdown",
		//          "title": "In which country are you located?",
		//          "properties": {},
		//          "choices": [
		//            {
		//              "id": "L8jBWsK77c78",
		//              "ref": "5639e95d-85c2-4a98-8a53-d9a519bd3f0f",
		//              "label": "United States"
		//            },
		//            {
		//              "id": "c1LgpbwganR7",
		//              "ref": "6c9016f4-1066-4a6a-b597-12f3347c8e62",
		//              "label": "Canada"
		//            },
		//            {
		//              "id": "vAzChtKBoRfX",
		//              "ref": "81967bb4-c4d8-4679-a171-b94d2ea6bcdb",
		//              "label": "United Kingdom"
		//            },
		//            {
		//              "id": "AWdF3QFxD7Ho",
		//              "ref": "1c91670c-a457-47e0-b566-f41bb196a82a",
		//              "label": "Australia"
		//            },
		//            {
		//              "id": "iG90f7gvKyMZ",
		//              "ref": "d7f2a40f-2394-4bb9-b445-8d8b605832e2",
		//              "label": "Germany"
		//            },
		//            {
		//              "id": "HgtgbabZReoA",
		//              "ref": "a4b22fd2-7b94-4c04-97d6-ec3997644874",
		//              "label": "Hungary"
		//            },
		//            {
		//              "id": "tUsfsJOqXhlF",
		//              "ref": "2c6bae21-abec-44c4-95d8-400b47ddbdab",
		//              "label": "France"
		//            },
		//            {
		//              "id": "KyqtKFiS860z",
		//              "ref": "43905d91-8339-4a7c-8bd4-5a21ef949ac6",
		//              "label": "Spain"
		//            },
		//            {
		//              "id": "SDVzCFVen6Fz",
		//              "ref": "35d5a684-bc6c-44ee-93b5-4341856bfeb0",
		//              "label": "Italy"
		//            },
		//            {
		//              "id": "vrxp0ZF7kkmr",
		//              "ref": "bd1e27e0-9075-4b0f-8e88-c7c7fd4a628d",
		//              "label": "Japan"
		//            },
		//            {
		//              "id": "im1HAghZkvb5",
		//              "ref": "a7a00093-356e-4b69-a873-d6473e2255a0",
		//              "label": "China"
		//            },
		//            {
		//              "id": "HP7NPuY2Rj5N",
		//              "ref": "0acf39bc-37c6-4cff-aed4-f53eb8233e56",
		//              "label": "India"
		//            },
		//            {
		//              "id": "t9fZYpFf9VjK",
		//              "ref": "7e371dea-15ac-4422-b2bf-c56b011f1079",
		//              "label": "Brazil"
		//            },
		//            {
		//              "id": "Qnq7oTeajc2F",
		//              "ref": "51185807-12af-49cf-b5fd-7669b6e8d966",
		//              "label": "Mexico"
		//            },
		//            {
		//              "id": "s92v94DiPaRg",
		//              "ref": "7f54863e-3cde-42c9-922a-2cdf8440aaea",
		//              "label": "South Africa"
		//            },
		//            {
		//              "id": "PQFZLvYgjPjy",
		//              "ref": "c30c8ff7-0bcd-4990-b5b8-8a21e26beb0f",
		//              "label": "Other"
		//            }
		//          ]
		//        }
		//      ],
		//      "endings": [
		//        {
		//          "id": "DefaultTyScreen",
		//          "ref": "default_tys",
		//          "title": "Thanks for completing this typeform\nNow *create your own* — it's free, easy, & beautiful",
		//          "type": "thankyou_screen",
		//          "properties": {
		//            "button_text": "Create a *typeform*",
		//            "show_button": true,
		//            "share_icons": false,
		//            "button_mode": "default_redirect"
		//          },
		//          "attachment": {
		//            "type": "image",
		//            "href": "https://images.typeform.com/images/2dpnUBBkz2VN"
		//          }
		//        }
		//      ],
		//      "settings": {
		//        "partial_responses_to_all_integrations": false
		//      }
		//    },
		//    "answers": [
		//      {
		//        "type": "text",
		//        "text": "Teszt Amarillisz",
		//        "field": {
		//          "id": "dpN7FpUkEdVc",
		//          "type": "short_text",
		//          "ref": "f8336747-afe6-46fb-ad09-fc1a98a9ec65"
		//        }
		//      },
		//      {
		//        "type": "email",
		//        "email": "teszt.amarillisz@teszt.hu",
		//        "field": {
		//          "id": "X1lJ8iinKvjH",
		//          "type": "email",
		//          "ref": "00ef3571-8787-4f6d-8d03-acdf746969be"
		//        }
		//      },
		//      {
		//        "type": "text",
		//        "text": "Amarillisz Kft",
		//        "field": {
		//          "id": "9QmKI5zFZPGm",
		//          "type": "short_text",
		//          "ref": "5a9a8039-5574-4fa9-8404-eae2437250d7"
		//        }
		//      },
		//      {
		//        "type": "phone_number",
		//        "phone_number": "+36702865009",
		//        "field": {
		//          "id": "NWURJERnyf7o",
		//          "type": "phone_number",
		//          "ref": "2abb78cb-149e-41a1-a998-a92a4050f60e"
		//        }
		//      },
		//      {
		//        "type": "choice",
		//        "choice": {
		//          "id": "HgtgbabZReoA",
		//          "label": "Hungary",
		//          "ref": "a4b22fd2-7b94-4c04-97d6-ec3997644874"
		//        },
		//        "field": {
		//          "id": "SiSwcuE6aXMa",
		//          "type": "dropdown",
		//          "ref": "c7871265-ae53-42be-8ef8-b0b0f5f5c5eb"
		//        }
		//      }
		//    ],
		//    "ending": {
		//      "id": "DefaultTyScreen",
		//      "ref": "default_tys"
		//    }
		//  }
		//}

		RestResponse res = RestContext.response;
		res.responseBody = Blob.valueOf('{"success": true}');
		res.statusCode = 200;
	}
}


