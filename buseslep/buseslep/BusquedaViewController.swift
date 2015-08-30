
//
//  BusquedaViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit


class BusquedaViewController: UIViewController , NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    

    @IBOutlet weak var lblOrigen: UIButton!
    @IBOutlet weak var lblDestino: UIButton!
    @IBOutlet weak var lblFechaIda: UIButton!
    @IBOutlet weak var lblFechaVuelta: UIButton!
    @IBOutlet weak var lblCantidadPasajes: UIButton!
    @IBOutlet weak var chkIdaVuelta: UISwitch!
    
    @IBOutlet weak var btnBusqueda: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var loadImage: UIActivityIndicatorView!
    lazy var serviceData =  NSMutableData()
    var ciudadesOrigen: [CiudadOrigen]?
    var ciudadesDestino: [CiudadDestino]?
    var horariosIda: [Horario]?
    
    var indexCiudadOrigen: Int? //guardo el indice de la ciduad elegida, de las ciudades origen
    var indexCiudadDestino: Int? //guardo el indice de la ciduad elegida, de las ciudades destino
    var indexHorarioIda: Int? //guardo el indice del horario elegido
    
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
        self.loadImage.hidden =  false
        
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
                    self.ciudadesOrigen = CiudadOrigen.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                }
            }
        if error != nil{
                println("Error: " + error.description)
            }
            

            
        })
        task.resume()
        self.loadImage.hidden = true
    }

    @IBAction func SetIdaVuelta(sender: UISwitch) {
       //     lblFechaVuelta.enabled=sender.on
        if(sender.on){
            lblFechaVuelta.setTitle("  Fecha ida", forState: UIControlState.Normal);
            lblFechaVuelta.enabled=true
        }
        else{
            lblFechaVuelta.setTitle("  Solo ida", forState: UIControlState.Normal);
            lblFechaVuelta.enabled=false
        }
    }


    @IBAction func clickBusqueda(sender: UIButton) {
        var error: Bool = false
        var msgError: String = "Revise "
        //valido la ciudad de origen
        if(lblOrigen.titleLabel?.text == "  Ciudad de Origen"){
            error = true
            msgError.extend("Ciudad de Origen ")
        }
        //valido la ciudad de destino
        if(lblDestino.titleLabel?.text == "  Ciudad de Destino"){
            error = true
            msgError.extend(", Ciudad de Destino")
        }
        //valido la fecha de ida
        if(lblFechaIda.titleLabel?.text == "  Fecha ida"){
            error = true
            msgError.extend(", Fecha ida")
        }
        if (chkIdaVuelta.on){
            //valido la ciudad de origen
            if(lblFechaVuelta.titleLabel?.text == "  Fecha vuelta"){
                error = true
                msgError.extend(", Fecha de vuelta")
            }
        }
        //valido la cantidad de pasajes
        if(lblCantidadPasajes.titleLabel?.text == "  Cantidad de pasajes"){
            error = true
            msgError.extend(", Cantidad de pasajes")
        }
        
        //si error es true largo un aviso
        if (!error){ //sacar lo negado
            var alert = UIAlertView( title: "Error!", message: msgError,delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()
            
        }//aca va el else
        self.loadImage.hidden = false
        obtenerHorarios(ciudadesOrigen![indexCiudadOrigen!].id!, IdLocalidadDestino: ciudadesDestino![indexCiudadDestino!].id_localidad_destino!, Fecha: "20150906")


    }
    
     @IBAction func ciudadOrigenElegida(index : Int){
        self.indexCiudadOrigen = index
        lblOrigen.setTitle("  "+ciudadesOrigen![index].nombre!, forState: UIControlState.Normal)
        indexCiudadDestino = -1 // limpio con -1 para decir que no se eligio destino
        lblDestino.setTitle("  Ciudad de Destino", forState: UIControlState.Normal)
        
        obtenerCiudadesDestino(ciudadesOrigen![index].id!)
    }
    
    
    @IBAction func horarioIda(index : Int){
        self.indexHorarioIda = index

    }
    
    @IBAction func ciudadDestinoElegida(index : Int){
        self.indexCiudadDestino = index
        lblDestino.setTitle("  "+ciudadesDestino![index].hasta!, forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        if identifier == "CiudadesOrigen"{ //nombre del segue
            let ciudadesOrigenViewController = segue.destinationViewController as! CiudadesOrigenViewController
            ciudadesOrigenViewController.ciudadesOrigen = self.ciudadesOrigen
            ciudadesOrigenViewController.busquedaViewController = self
        }
        if identifier == "CiudadesDestino"{ //nombre del segue
            let ciudadesDestinoViewController = segue.destinationViewController as! CiudadesDestinoViewController
            ciudadesDestinoViewController.ciudadesDestino = self.ciudadesDestino
            ciudadesDestinoViewController.busquedaViewController = self
        }
        
        if identifier == "elegirHorarioIda"{ //nombre del segue
            let horariosViewController = segue.destinationViewController as! HorarioViewController
            horariosViewController.horarios = self.horariosIda
            horariosViewController.busquedaViewController = self
            self.loadImage.hidden = true

        }
        
        
        
    }
    
    
    func obtenerCiudadesDestino(IdLocalidadOrigen: Int){
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:LocalidadesHasta id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><IdLocalidadOrigen i:type='d:int'>\(IdLocalidadOrigen)</IdLocalidadOrigen><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:LocalidadesHasta></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#LocalidadesHasta", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
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
                    self.ciudadesDestino = CiudadDestino.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                    
                }
            }
            if error != nil{
                println("Error: " + error.description)
            }
            
        })
        task.resume()
    }
    
    
    func obtenerHorarios(IdLocalidadOrigen: Int, IdLocalidadDestino: Int, Fecha: String){
        

        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:ListarHorarios id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><Fecha i:type='d:string'>\(Fecha)</Fecha><IdLocalidadOrigen i:type='d:int'>\(IdLocalidadOrigen)</IdLocalidadOrigen><IdLocalidadDestino i:type='d:int'>\(IdLocalidadDestino)</IdLocalidadDestino><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:ListarHorarios></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#ListarHorarios", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println(strData)
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    self.horariosIda = Horario.fromDictionary(json) // parseo  y obtengo un arreglo de horarios
                    self.performSegueWithIdentifier("elegirHorarioIda", sender: self);

                }
            }
            if error != nil{
                println("Error: " + error.description)
            }

        })
        task.resume()
    }
}
