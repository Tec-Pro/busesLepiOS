//
//  EditProfileViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuardar.layer.borderColor = UIColor.blackColor().CGColor
        btnGuardar.layer.borderWidth = 0.5
        
        let preferences = NSUserDefaults.standardUserDefaults()
        nombre.text = preferences.valueForKey("nombre") as! String
        apellido.text = preferences.valueForKey("apellido") as! String
        mail.text = preferences.valueForKey("email") as! String
        
        nombre.delegate = self
        apellido.delegate = self
        mail.delegate = self
    }
    
    func dataOk()-> Bool{
        return (count(nombre.text) >= 1 &&
            count(apellido.text) >= 1 &&
            count(mail.text) >= 1)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func editarPerfil(sender: UIButton) {
        if dataOk(){
            var userWS: String = "UsuarioLep" //paramatros
            var passWS: String = "Lep1234"
            var id_plataforma: Int = 2
            var nom = nombre.text
            var ape = apellido.text
            var email = mail.text
            let preferences = NSUserDefaults.standardUserDefaults()
            var dni = preferences.valueForKey("dni") as! Int
            var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:EditarPerfilCliente id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:int'>\(dni)</DNI><Nombre i:type='d:string'>\(nom)</Nombre><Apellido i:type='d:string'>\(ape)</Apellido><Email i:type='d:string'>\(email)</Email><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma></n0:EditarPerfilCliente></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
            //holaokkkk
            var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
            var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
            var session = NSURLSession.sharedSession()
            var err: NSError?
            lobj_Request.HTTPMethod = "POST"
            lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
            lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#EditarPerfilCliente", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
            var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                var parser : String = strData as String
                if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                    if let rangeTo = parser.rangeOfString(",\"Cols") {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //self.load.hidden = true
                            var alert = UIAlertView( title: "Atencion!", message: "Perfil editado",delegate: nil,  cancelButtonTitle: "Aceptar")
                            alert.show()
                            let preferences = NSUserDefaults.standardUserDefaults()
                            preferences.setObject(nom, forKey: "nombre")
                            preferences.setObject(ape, forKey: "apellido")
                            preferences.setObject(email, forKey: "email")
                            preferences.synchronize()
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                              //  self.load.hidden = true
                                let alert = UIAlertView(title: "Atencion!", message: "Ocurrio un error", delegate:nil, cancelButtonTitle: "Aceptar")
                                alert.show()
                            })
                }
                if error != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                        alert.show()
                        //self.load.hidden = true
                    })
                }
            })
            task.resume()
            
        } else {
            var alert = UIAlertView( title: "Atencion!", message: "Por favor complete todos los campos",delegate: nil,  cancelButtonTitle: "Aceptar")
            alert.show()
        }
        
    }
    
    
}
