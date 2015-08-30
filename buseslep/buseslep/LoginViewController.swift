//
//  LoginViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    
    @IBAction func ingresar(sender: UIButton) {
        println("cacaaa")
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var dni = txtDni.text
        var pass = txtPass.text
        println(dni)
        println(pass)
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:login id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><Pass i:type='d:string'>\(pass)</Pass><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:login></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        //holaokkkk
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#login", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
        println("PRINT1")
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println("PRINT2")
            println(strData)
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    println("parseado")
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                  //  self.ciudadesOrigen = CiudadOrigen.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                }
            }
            if error != nil{
                println("Error: " + error.description)
            }
            
            
            
        })
        task.resume()
        println("bueno chau")
        
    }
}
