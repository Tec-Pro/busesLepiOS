//
//  ReserveDetailsViewController.swift
//  buseslep
//
//  Created by Agustin on 9/3/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ReserveDetailsViewController: UIViewController{
    
    @IBOutlet var btnReserve: UIButton!
    @IBOutlet var lblCiudadOrigen: UILabel!
    @IBOutlet var lblCiudadDestino: UILabel!
    @IBOutlet var lblFecha: UILabel!
    @IBOutlet var lblHora: UILabel!
    @IBOutlet var lblCantPasajes: UILabel!
    @IBOutlet var lblCiudadOrigenVuelta: UILabel!
    @IBOutlet var lblCiudadDestinoVuelta: UILabel!
    @IBOutlet var lblFechaVuelta: UILabel!
    @IBOutlet var lblHoraVuelta: UILabel!
    @IBOutlet var lblCantPasajesVuelta: UILabel!
    @IBOutlet var borderView: UIView!
    @IBOutlet var loadIcon: UIActivityIndicatorView!
    
    var dni: String = ""
    var IDEmpresaIda: Int = 0
    var IDDestinoIda: Int = 0
    var CodHorarioIda: Int = 0
    var IdLocalidadDesdeIda: Int = 0
    var IdlocalidadHastaIda: Int = 0
    var CantidadIda: Int = 0
    var IDEmpresaVuelta: Int = 0
    var IDDestinoVuelta: Int = 0
    var CodHorarioVuelta: Int = 0
    var IdLocalidadDesdeVuelta: Int = 0
    var IdlocalidadHastaVuelta: Int = 0
    var EsCompra: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIcon.hidden = true
        btnReserve.layer.borderColor = UIColor.blackColor().CGColor
        btnReserve.layer.borderWidth = 0.5
        borderView.layer.borderWidth = 0.5
    }
    
    @IBAction func reservar(sender: UIButton) {
        self.loadIcon.hidden = false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
   
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AgregarReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IDEmpresaIda i:type='d:int'>\(IDEmpresaIda)</IDEmpresaIda><IDDestinoIda i:type='d:int'>\(IDDestinoIda)</IDDestinoIda><CodHorarioIda i:type='d:int'>\(CodHorarioIda)</CodHorarioIda><IdLocalidadDesdeIda i:type='d:int'>\(IdLocalidadDesdeIda)</IdLocalidadDesdeIda><IdlocalidadHastaIda i:type='d:int'>\(IdlocalidadHastaIda)</IdlocalidadHastaIda><CantidadIda i:type='d:int'>\(CantidadIda)</CantidadIda><IDEmpresaVuelta i:type='d:int'>\(IDEmpresaVuelta)</IDEmpresaVuelta><IDDestinoVuelta i:type='d:int'>\(IDDestinoVuelta)</IDDestinoVuelta><CodHorarioVuelta i:type='d:int'>\(CodHorarioVuelta)</CodHorarioVuelta><IdLocalidadDesdeVuelta i:type='d:int'>\(IdLocalidadDesdeVuelta)</IdLocalidadDesdeVuelta><IdlocalidadHastaVuelta i:type='d:int'>\(IdlocalidadHastaVuelta)</IdlocalidadHastaVuelta><CantidadVuelta i:type='d:int'>\(CantidadIda)</CantidadVuelta><EsCompra i:type='d:int'>\(EsCompra)</EsCompra></n0:AgregarReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        //holaokkkk
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#AgregarReserva", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    println("parseado")
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                }
                self.loadIcon.hidden = true
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                if let rangeF = parser.rangeOfString("<return xsi:type=") { // con esto hago un subrango
                    if let rangeT = parser.rangeOfString("</return>") {
                        let alert = UIAlertView(title: "Atencion!", message: "Datos incorrectos", delegate:nil, cancelButtonTitle: "Aceptar")
                        alert.show()
                        self.loadIcon.hidden = true
                    }
                }
            }
            if error != nil{
                println("Error: " + error.description)
            }
            
            
            
        })
        task.resume()

    }
    
}