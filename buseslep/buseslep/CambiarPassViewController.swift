//
//  CambiarPassViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CambiarPassViewController: UIViewController{
    
    
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtRepPass: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuardar.layer.borderColor = UIColor.blackColor().CGColor
        btnGuardar.layer.borderWidth = 0.5
    }

    func dataOk()-> Bool{
        return (count(txtPass.text) >= 1 &&
            count(txtRepPass.text) >= 1)
    }
    
    @IBAction func guardar(sender: AnyObject) {
        if dataOk(){
            var userWS: String = "UsuarioLep" //paramatros
            var passWS: String = "Lep1234"
            var id_plataforma: Int = 2
            var pass = txtPass.text
            var repPass = txtRepPass.text
            let preferences = NSUserDefaults.standardUserDefaults()
            var dni = preferences.valueForKey("dni") as! Int
            var email = preferences.valueForKey("email") as! String
            var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:ModificarContraseña id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><Dni i:type='d:int'>\(dni)</Dni><Email i:type='d:string'>\(email)</Email><Pas i:type='d:string'>\(pass)</Pas><NuevaPass i:type='d:string'>\(repPass)</NuevaPass><Id_Plataforma i:type='d:int'>\(id_plataforma)</Id_Plataforma></n0:ModificarContraseña></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
            //holaokkkk
            var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
            var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
            var session = NSURLSession.sharedSession()
            var err: NSError?
            lobj_Request.HTTPMethod = "POST"
            lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
            lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#ModificarContraseña", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
            var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
               println("DATAAA")
                println(strData)
                var parser : String = strData as String
                if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                    if let rangeTo = parser.rangeOfString(",\"Cols") {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //self.load.hidden = true
                            var alert = UIAlertView( title: "Atencion!", message: "Perfil editado",delegate: nil,  cancelButtonTitle: "Aceptar")
                            alert.show()
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
