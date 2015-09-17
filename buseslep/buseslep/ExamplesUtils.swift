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
        return "TEST-2e5d7d95-7cb8-48d3-8bd6-cfde1bc34254"
		//return "APP_USR-3f8dc194-8894-4d07-bb6c-b4a786a19c6c"

    }
   // class var MERCHANT_MOCK_BASE_URL : String {
   //     return "https://www.mercadopago.com"
   // }
   // class var MERCHANT_MOCK_GET_CUSTOMER_URI : String {
   //     return "/checkout/examples/getCustomer"
   // }
   
   // class var MERCHANT_MOCK_CREATE_PAYMENT_URI : String {
   //     return  "/checkout/examples/doPayment"
   // }
   // class var MERCHANT_MOCK_GET_DISCOUNT_URI : String {
   //     return  "/checkout/examples/getDiscounts"
   // }

    //class var MERCHANT_ACCESS_TOKEN : String {
    //    return "mla-cards-data"
		// "mla-cards-data" // AR
		// "mlb-cards-data" // BR
		// "mlm-cards-data" // MX
		// "mlv-cards-data" // VZ
		// "mco-cards-data" // CO
		// "mla-cards-data-tarshop" // NO CVV
        // return "mla-cards-data-tarshop" // No CVV
   // }

    


 

    class func startAdvancedVaultActivity(merchantPublicKey: String, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int) -> Void) -> AdvancedVaultViewController {
        return AdvancedVaultViewController(merchantPublicKey: merchantPublicKey, amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: callback)
    }
    

    
    class func createPayment(token: String, installments: Int, idSell: Int, transactionAmount: Double, paymentMethod: PaymentMethod, callback: (payment: Payment, codImpresion: String) -> Void) {
        // Set item

        let preferences = NSUserDefaults.standardUserDefaults()// obtengo el mail
        var email: AnyObject? = preferences.objectForKey("email")
        //seteo el pago tecpro
        let paymentTecPro : PaymentTecPro = PaymentTecPro(description: "boletos", externalReference : "boleto:\(idSell)", installments: installments, token: token, paymentMethodId: paymentMethod._id, transactionAmount : transactionAmount, email: email as! String)
        //println(paymentTecPro.toJSONString())
        //self.realizarPagoMercadoPago("s")
        
        var UserCobro: String = "54GFDG2224785486DG" //paramatros
        var PassCobro: String = "15eQiDeCtCaDmS2506"
        var id_plataforma: Int = 2
        
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:RealizarCobroMercadoPago id='o0' c:root='1' xmlns:n0='urn:WSCobroMercadoPagoIntf-IWSCobroMercadoPago'><UserCobro i:type='d:string'>\(UserCobro)</UserCobro><PassCobro i:type='d:string'>\(PassCobro)</PassCobro><DatosCompra i:type='d:string'>\(paymentTecPro.toJSONString())</DatosCompra><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma></n0:RealizarCobroMercadoPago></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
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
  //          println(strData)
            if let rangeFrom = parser.rangeOfString(":string\">") { // con esto hago un subrango
                //TESTEO SIMULANDO ACEPTACION DE PAGOOOOO
                //var rangeTotest = parser.rangeOfString("</return>")
                //var auxParser: String = parser.substringToIndex(rangeTotest!.startIndex)
                //auxParser.extend(" \"Cod_Impresion\":\"Q1Q2\"")
                //auxParser.extend(parser.substringFromIndex(rangeTotest!.startIndex))
                //parser = auxParser
                if let rangeTo = parser.rangeOfString("}{") {
                    var datos: String = parser[rangeFrom.endIndex..<rangeTo.startIndex]
                    datos.extend("}")
                  //  println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    let rangeFromCod = parser.rangeOfString("Cod_Impresion\":\"")
                    let rangeToCod = parser.rangeOfString("\"}</return>")
                    var codImpresion: String = parser[rangeFromCod!.endIndex..<rangeToCod!.startIndex]
                    println(json)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(payment: Payment.fromJSON(json),codImpresion: codImpresion)
                    })

                }else{
                   let rangeTo = parser.rangeOfString("</return>")
                    var datos: String = parser[rangeFrom.endIndex..<rangeTo!.startIndex]
                    //datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    //println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    
                    println(json)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(payment: Payment.fromJSON(json),codImpresion: "-1")
                    })
                }
            }
            if error != nil{
                // ove to the UI thread
                 dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                     alert.show()
                 })
            }
        })
        task.resume()

    
        // Create payment
      //MerchantServer.createPayment(ExamplesUtils.MERCHANT_MOCK_BASE_URL, merchantPaymentUri: ExamplesUtils.MERCHANT_MOCK_CREATE_PAYMENT_URI, payment: payment, success: callback, failure: nil)
    }
    
    
/*    class func realizarPagoMercadoPago(DatosCompra: String) {
        var UserCobro: String = "54GFDG2224785486DG" //paramatros
        var PassCobro: String = "15eQiDeCtCaDmS2506"
        var id_plataforma: Int = 2
        
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:RealizarCobroMercadoPago id='o0' c:root='1' xmlns:n0='urn:WSCobroMercadoPagoIntf-IWSCobroMercadoPago'><UserCobro i:type='d:string'>\(UserCobro)</UserCobro><PassCobro i:type='d:string'>\(PassCobro)</PassCobro><DatosCompra i:type='d:string'>\(DatosCompra)</DatosCompra><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma></n0:RealizarCobroMercadoPago></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
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
    }*/
    }
