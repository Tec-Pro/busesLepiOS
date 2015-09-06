//
//  RegisterViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtRepetirPass: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegistrar.layer.borderColor = UIColor.blackColor().CGColor
        btnRegistrar.layer.borderWidth = 0.5
        self.load.hidden = true
        txtNombre.delegate = self
        txtApellido.delegate = self
        txtDni.delegate = self
        txtMail.delegate = self
        txtPass.delegate = self
        txtRepetirPass.delegate = self
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
    
    func dataOk()-> Bool{
        return (count(txtNombre.text) >= 1 &&
            count(txtApellido.text) >= 1 &&
            count(txtDni.text) >= 1 &&
            count(txtMail.text) >= 1 &&
            count(txtPass.text) >= 1 &&
            count(txtRepetirPass.text) >= 1)
    }
    
    func passOk()-> Bool{
        return (txtPass.text == txtRepetirPass.text)
    }
    
    @IBAction func registrar(sender: UIButton) {
        if dataOk(){
            if passOk(){
                self.load.hidden = false
                var userWS: String = "UsuarioLep" //paramatros
                var passWS: String = "Lep1234"
                var id_plataforma: Int = 2
                var dni = txtDni.text
                var pass = txtPass.text
                var nombre = txtNombre.text
                var apellido = txtApellido.text
                var email = txtMail.text
                
                var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:RegistrarUsuario id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><PDni i:type='d:int'>\(dni)</PDni><pass i:type='d:string'>\(pass)</pass><Nombre i:type='d:string'>\(nombre)</Nombre><Apellido i:type='d:string'>\(apellido)</Apellido><Email i:type='d:string'>\(email)</Email><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma></n0:RegistrarUsuario></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
                //holaokkkk
                var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
                var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
                var session = NSURLSession.sharedSession()
                var err: NSError?
                lobj_Request.HTTPMethod = "POST"
                lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
                lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
                lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#RegistrarUsuario", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
                var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
                    var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    var parser : String = strData as String
                    if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                        if let rangeTo = parser.rangeOfString(",\"Cols") {
                            var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                            datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                            var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.load.hidden = true
                                var alert = UIAlertView( title: "Atencion!", message: "Cuenta creada exitosamente",delegate: nil,  cancelButtonTitle: "Aceptar")
                                alert.show()
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    } else {
                        if let rangeF = parser.rangeOfString("<return xsi:type=") { // con esto hago un subrango
                            if let rangeT = parser.rangeOfString("</return>") {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.load.hidden = true
                                    let alert = UIAlertView(title: "Atencion!", message: "Ocurrio un error", delegate:nil, cancelButtonTitle: "Aceptar")
                                    alert.show()
                                })
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.load.hidden = true
                                let alert = UIAlertView(title: "Atencion!", message: "DNI incorrecto", delegate:nil, cancelButtonTitle: "Aceptar")
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
            } else {
                var alert = UIAlertView( title: "Atencion!", message: "Las contraseñas no coinciden",delegate: nil,  cancelButtonTitle: "Aceptar")
                alert.show()
            }
        } else {
            var alert = UIAlertView( title: "Atencion!", message: "Por favor complete todos los campos",delegate: nil,  cancelButtonTitle: "Aceptar")
            alert.show()
        }
        
    }
}
