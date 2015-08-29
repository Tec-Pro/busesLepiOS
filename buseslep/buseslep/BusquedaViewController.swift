
//
//  BusquedaViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit


class BusquedaViewController: UIViewController , NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    
    @IBOutlet var lblOrigen: UILabel!
    @IBOutlet weak var lblDestino: UILabel!
    @IBOutlet weak var lblFechaIda: UILabel!
    @IBOutlet weak var lblFechaVuelta: UILabel!
    @IBOutlet weak var lblCantidadPasajes: UILabel!
    @IBOutlet weak var imageCalendarvuelta: UIImageView!
    @IBOutlet weak var chkIdaVuelta: UISwitch!
    
    @IBOutlet weak var btnBusqueda: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    lazy var serviceData =  NSMutableData()
    var ciudadesOrigen: [Ciudad]?
    var ciudadesDestino: [Ciudad]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //le pongo el borde porque no encontre la forma de ponerlo graficamente
        lblDestino.layer.borderColor = UIColor.blackColor().CGColor
        lblDestino.layer.borderWidth = 0.5
        lblFechaIda.layer.borderColor = UIColor.blackColor().CGColor
        lblFechaIda.layer.borderWidth = 0.5
        lblFechaVuelta.layer.borderColor = UIColor.blackColor().CGColor
        lblFechaVuelta.layer.borderWidth = 0.5
        lblCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblCantidadPasajes.layer.borderWidth = 0.5
        lblOrigen.layer.borderColor = UIColor.blackColor().CGColor
        lblOrigen.layer.borderWidth = 0.5
        btnBusqueda.layer.borderColor = UIColor.blackColor().CGColor
        btnBusqueda.layer.borderWidth = 0.5
        btnLogin.layer.borderColor = UIColor.blackColor().CGColor
        btnLogin.layer.borderWidth = 0.5
        
        //si las ciudadesOrigen es vacio o null tengo que conectarme al ws
        if ciudadesOrigen == nil || ciudadesOrigen?.count==0{
            obtenerCiudadesOrigen()
        }

    }
    
    
    func obtenerCiudadesOrigen(){
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2 
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:LocalidadesDesde id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:LocalidadesDesde></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#LocalidadesDesde", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    //println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    self.ciudadesOrigen = Ciudad.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                }
            }
        if error != nil{
                println("Error: " + error.description)
            }
            
        })
        task.resume()
    }

    @IBAction func SetIdaVuelta(sender: UISwitch) {
            lblFechaVuelta.enabled=sender.on
        if(sender.on){
            lblFechaVuelta.text = "  Fecha vuelta"
        }
        else{
            lblFechaVuelta.text =  "  Solo ida"
        }
    }

    @IBAction func clickBusqueda(sender: UIButton) {
        var error: Bool = false
        var msgError: String = "Revise "
        //valido la ciudad de origen
        if(lblOrigen.text == "  Ciudad de origen"){
            error = true
            msgError.extend("Ciudad de origen ")
        }
        //valido la ciudad de destino
        if(lblDestino.text == "  Ciudad de destino"){
            error = true
            msgError.extend(", Ciudad de destino")
        }
        //valido la fecha de ida
        if(lblFechaIda.text == "  Fecha de ida"){
            error = true
            msgError.extend(", Fecha de ida")
        }
        if (chkIdaVuelta.on){
            //valido la ciudad de origen
            if(lblFechaVuelta.text == "  Fecha vuelta"){
                error = true
                msgError.extend(", Fecha de vuelta")
            }
        }
        //valido la cantidad de pasajes
        if(lblCantidadPasajes.text == "  Cantidad de pasajes"){
            error = true
            msgError.extend(", Cantidad de pasajes")
        }
        
        //si error es true largo un aviso
        if (error){
            var alert = UIAlertView( title: "Error!", message: msgError,delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()

        }
    }
}
