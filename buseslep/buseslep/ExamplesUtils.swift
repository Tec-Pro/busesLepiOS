//
//  ExamplesUtils.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ExamplesUtils {
    class var MERCHANT_PUBLIC_KEY : String {
		return "444a9ef5-8a6b-429f-abdf-587639155d88"
		// "444a9ef5-8a6b-429f-abdf-587639155d88" // AR
		// "APP_USR-f163b2d7-7462-4e7b-9bd5-9eae4a7f99c3" // BR
		// "6c0d81bc-99c1-4de8-9976-c8d1d62cd4f2" // MX
		// "2b66598b-8b0f-4588-bd2f-c80ca21c6d18" // VZ
		// "aa371283-ad00-4d5d-af5d-ed9f58e139f1" // CO
    }
    class var MERCHANT_MOCK_BASE_URL : String {
        return "https://www.mercadopago.com"
    }
   // class var MERCHANT_MOCK_GET_CUSTOMER_URI : String {
   //     return "/checkout/examples/getCustomer"
   // }
    
    class var MERCHANT_MOCK_CREATE_PAYMENT_URI : String {
        return  "/checkout/examples/doPayment"
    }
   // class var MERCHANT_MOCK_GET_DISCOUNT_URI : String {
   //     return  "/checkout/examples/getDiscounts"
   // }

    class var MERCHANT_ACCESS_TOKEN : String {
        return "mla-cards-data"
		// "mla-cards-data" // AR
		// "mlb-cards-data" // BR
		// "mlm-cards-data" // MX
		// "mlv-cards-data" // VZ
		// "mco-cards-data" // CO
		// "mla-cards-data-tarshop" // NO CVV
        // return "mla-cards-data-tarshop" // No CVV
    }

    
    class var ITEM_ID : String {
        return "id1"
    }
    
    class var ITEM_QUANTITY : Int {
        return 1
    }
    
    class var ITEM_UNIT_PRICE : Double {
        return 100.00
    }

 

    class func startAdvancedVaultActivity(merchantPublicKey: String, merchantBaseUrl: String, merchantAccessToken: String, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int) -> Void) -> AdvancedVaultViewController {
        return AdvancedVaultViewController(merchantPublicKey: merchantPublicKey, merchantBaseUrl: merchantBaseUrl,  merchantAccessToken: merchantAccessToken, amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    

    
    class func createPayment(token: String, installments: Int, idSell: Int, transactionAmount: Double, paymentMethod: PaymentMethod, callback: (payment: Payment) -> Void) {
        // Set item
        let item : Item = Item(_id: ExamplesUtils.ITEM_ID, quantity: ExamplesUtils.ITEM_QUANTITY,
            unitPrice: ExamplesUtils.ITEM_UNIT_PRICE)

		
        // Set merchant payment borrar estoooooo
        let payment : MerchantPayment = MerchantPayment(item: item, installments: installments, cardIssuerId: 0, token: token, paymentMethodId: paymentMethod._id, campaignId: 0, merchantAccessToken: ExamplesUtils.MERCHANT_ACCESS_TOKEN)
        
        
        //seteo el pago tecpro
        let paymentTecPro : PaymentTecPro = PaymentTecPro(description: "descripcion", externalReference : "externalReference", installments: installments, token: token, paymentMethodId: paymentMethod._id, transactionAmount : transactionAmount, email: "nico.orcasitas@gmail.com")
        println(paymentTecPro.toJSONString())
        //self.realizarPagoMercadoPago("s")
        
        var testRespuesta = "{\"id\": 28416,\"date_created\": \"2015-06-25T16:48:29.112-04:00\",\"date_approved\": \"2015-06-25T16:48:29.053-04:00\",  \"date_last_updated\": \"2015-06-25T16:48:29.052-04:00\",  \"money_release_date\": null, \"operation_type\": \"regular_payment\",  \"issuer_id\": \"3\", \"payment_method_id\": \"master\",  \"payment_type_id\": \"credit_card\",  \"status\": \"approved\", \"status_detail\": \"accredited\",  \"currency_id\": \"ARS\", \"description\": \"Title of what you are paying for\",  \"live_mode\": false, \"sponsor_id\": null,  \"collector_id\": 185927909,  \"payer\": {   \"type\": \"guest\",    \"id\": null,   \"email\": \"test_user_19653727@testuser.com\",    \"identification\": {     \"type\": \"DNI\",      \"number\": \"1111111\"    }  },  \"metadata\": {},  \"order\": {},  \"external_reference\": null,  \"transaction_amount\": 100,  \"transaction_amount_refunded\": 0,  \"coupon_amount\": 0,  \"differential_pricing_id\": null,  \"transaction_details\":    \"net_received_amount\": 94.01,    \"total_paid_amount\": 100,    \"overpaid_amount\": 0,    \"external_resource_url\": null,    \"installment_amount\": 100,    \"financial_institution\": null,    \"payment_method_reference_id\": null  },  \"fee_details\": [    {      \"type\": \"mercadopago_fee\",      \"fee_payer\": \"collector\",      \"amount\": 5.99    }  ],  \"captured\": true,  \"binary_mode\": false,  \"call_for_authorize_id\": null,  \"statement_descriptor\": \"WWW.MERCADOPAGO.COM\",  \"installments\": 1,  \"card\": {    \"id\": null,    \"first_six_digits\": \"503175\",    \"last_four_digits\": \"0604\",    \"expiration_month\": 6,    \"expiration_year\": 2016,    \"date_created\": \"2015-06-25T16:48:29.044-04:00\",    \"date_last_updated\": \"2015-06-25T16:48:28.697-04:00\",    \"cardholder\": {      \"name\": \"APRO\",      \"identification\": {        \"number\": \"32666666\",        \"type\": \"DNI\"      }    }  },  \"notification_url\": null,\"refunds\": []}"
        var datatest : NSData = testRespuesta.dataUsingEncoding(NSUTF8StringEncoding)!

        
        var jsonResult  = NSJSONSerialization.JSONObjectWithData(datatest, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary
        callback(payment: Payment.fromJSON(jsonResult))
        // Create payment
      MerchantServer.createPayment(ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantPaymentUri: ExamplesUtils.MERCHANT_MOCK_CREATE_PAYMENT_URI, payment: payment, success: callback, failure: nil)
    }
    
    
    class func realizarPagoMercadoPago(DatosCompra: String) {
        var UserCobro: String = "54GFDG2224785486DG" //paramatros
        var PassCobro: String = "15eQiDeCtCaDmS2506"
        var id_plataforma: Int = 2
        
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:RealizarCobroMercadoPago id='o0' c:root='1' xmlns:n0='urn:WSCobroMercadoPagoIntf-IWSCobroMercadoPago'><UserCobro i:type='d:string'>\(UserCobro)</UserCobro><PassCobro i:type='d:string'>\(PassCobro)</PassCobro><DatosCompra i:type='d:string'>\(DatosCompra)</DatosCompra><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:RealizarCobroMercadoPago></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WSCobroMercadoPago.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:WSCobroMercadoPagoIntf-IWSCobroMercadoPago#RealizarCobroMercadoPago", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            println(strData)
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    //println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    
                    println(json)
                    
                    


                }
            }
            if error != nil{
                // ove to the UI thread
               // dispatch_async(dispatch_get_main_queue(), { () -> Void in
               //     var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
               //     alert.show()
               // })
            }
        })
        task.resume()
    }
    }
