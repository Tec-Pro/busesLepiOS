//
//  LoginViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var btnCrearCuenta: UIButton!
    
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnIngresar.layer.borderColor = UIColor.blackColor().CGColor
        btnIngresar.layer.borderWidth = 0.5
        btnCrearCuenta.layer.borderColor = UIColor.blackColor().CGColor
        btnCrearCuenta.layer.borderWidth = 0.5
        txtPass.delegate = self
        self.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Hecho", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = items as [AnyObject]
        doneToolbar.sizeToFit()
        
        self.txtDni.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtDni.resignFirstResponder()
    }
    
    func dataOk()->Bool{
        return (count(txtDni.text) >= 1 && count(txtPass.text) >= 1)
    }
    
    @IBAction func ingresar(sender: UIButton) {
        if dataOk(){
            self.load.hidden = false
            var userWS: String = "UsuarioLep" //paramatros
            var passWS: String = "Lep1234"
            var id_plataforma: Int = 2
            var dni = txtDni.text
            var pass = txtPass.text
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
            var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
                var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                var parser : String = strData as String
                if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                    if let rangeTo = parser.rangeOfString(",\"Cols") {
                        var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                        datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                        println(datos)
                        var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                        var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                        // Move to the UI thread
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.load.hidden = true
                            //guardo los datos del usuario en una configuracion
                            let list = json["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
                            list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
                                let preferences = NSUserDefaults.standardUserDefaults()
                                preferences.setInteger(item["DNI"] as! Int, forKey: "dni")
                                preferences.setValue(item["Apellido"] as! String, forKey: "apellido")
                                preferences.setValue(item["Nombre"] as! String, forKey: "nombre")
                                preferences.setValue(item["Email"] as! String, forKey: "email")
                                preferences.setInteger(1, forKey: "login")
                                preferences.setValue(pass, forKey: "pass")
                                preferences.synchronize()
                            })
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                } else {
                    if let rangeF = parser.rangeOfString("<return xsi:type=") { // con esto hago un subrango
                        if let rangeT = parser.rangeOfString("</return>") {
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.load.hidden = true
                            let alert = UIAlertView(title: "Atencion!", message: "No se ha podido iniciar sesión", delegate:nil, cancelButtonTitle: "Aceptar")
                            alert.show()
                        })
                    }
                }
                if error != nil{
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                        alert.show()
                        self.load.hidden = true
                    })
                    
                }
            })
            task.resume()
            
        }else{
            let alert = UIAlertView(title: "Atencion!", message: "Por favor complete los campos", delegate:nil, cancelButtonTitle: "Aceptar")
            alert.show()
        }
    }
    
}
