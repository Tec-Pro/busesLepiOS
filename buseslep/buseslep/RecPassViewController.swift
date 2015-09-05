//
//  RecPassViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 3/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class RecPassViewController: UIViewController{
    
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnRecuperar: UIButton!
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRecuperar.layer.borderColor = UIColor.blackColor().CGColor
        btnRecuperar.layer.borderWidth = 0.5
        load.hidden = true
    }
    
    func dataOk()-> Bool{
        return (count(txtDni.text) >= 1 &&
            count(txtEmail.text) >= 1)
    }
    @IBAction func recuperar(sender: AnyObject) {
        if dataOk(){
            self.load.hidden = false
            var userWS: String = "UsuarioLep" //paramatros
            var passWS: String = "Lep1234"
            var id_plataforma: Int = 2
            var dni = txtDni.text
            var email = txtEmail.text
            var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:RecuperarContrasena id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><Dni i:type='d:int'>\(dni)</Dni><Email i:type='d:string'>\(email)</Email><Id_Plataforma i:type='d:int'>\(id_plataforma)</Id_Plataforma></n0:RecuperarContrasena></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
            //holaokkkk
            var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
            var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
            var session = NSURLSession.sharedSession()
            var err: NSError?
            lobj_Request.HTTPMethod = "POST"
            lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
            lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#RecuperarContrasena", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
            var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println(strData)
                var parser : String = strData as String
                //todo ok
                if let rangeT = parser.rangeOfString(">1</return>") {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.load.hidden = true
                        var alert = UIAlertView( title: "Atencion!", message: "Se ha enviado a su mail la contraseña",delegate: nil,  cancelButtonTitle: "Aceptar")
                        alert.show()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                } else {
                    if let rangeT = parser.rangeOfString(">-1</return>") {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.load.hidden = true
                            var alert = UIAlertView( title: "Atencion!", message: "La cuenta no existe o no esta activada",delegate: nil,  cancelButtonTitle: "Aceptar")
                            alert.show()
                        })
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.load.hidden = true
                            var alert = UIAlertView( title: "Atencion!", message: "DNI invalido",delegate: nil,  cancelButtonTitle: "Aceptar")
                            alert.show()
                        })
                    }
                }
                
                if error != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                        alert.show()
                        self.load.hidden = true
                    })
                }
            })
            task.resume()
        }else{
            let alert = UIAlertView(title: "Atencion!", message: "Por favor complete todos los campos", delegate:nil, cancelButtonTitle: "Aceptar")
            alert.show()
        }
        
    }
}
