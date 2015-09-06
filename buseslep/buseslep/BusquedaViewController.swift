
//
//  BusquedaViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit


class BusquedaViewController: UIViewController , NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    
    @IBOutlet var Menu: UIBarButtonItem!

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
    var horariosVuelta: [Horario]?
    var indexCiudadOrigen: Int? //guardo el indice de la ciduad elegida, de las ciudades origen
    var indexCiudadDestino: Int? //guardo el indice de la ciduad elegida, de las ciudades destino
    var indexHorarioIda: Int? //guardo el indice del horario elegido
    var indexHorarioVuelta: Int? //guardo el indice del horario elegido
    var precioIda: String? //precio de ida
    var precioIdaVuelta: String? //precio de ida
    var cantidadPasajes: Int = 0 //cantidad de pasajes elegidos
    
    var diaIda: Int = 0
    var mesIda:  Int = 0
    var anioIda: Int = 0
    
    var diaVuelta: Int = 0
    var mesVuelta:  Int = 0
    var anioVuelta: Int = 0
    
    var dniLoggeado: Int?
    
    var db : Sqlite = Sqlite()
    override func viewDidLoad() {
        super.viewDidLoad()
        Menu.target = self.revealViewController() // cosas para activar el menu
        Menu.action = Selector("revealToggle:") // cosas para activar el menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer()) //para abrir el menu arrastrando para el costado
        //le pongo el borde porque no encontre la forma de ponerlo graficamente
        lblOrigen.layer.borderColor = UIColor.blackColor().CGColor
        lblOrigen.layer.borderWidth = 0.5
        lblDestino.layer.borderColor = UIColor.blackColor().CGColor
        lblDestino.layer.borderWidth = 0.5
        lblFechaIda.layer.borderColor = UIColor.blackColor().CGColor
        lblFechaIda.layer.borderWidth = 0.5
        lblFechaVuelta.layer.borderColor = UIColor.blackColor().CGColor
        lblFechaVuelta.layer.borderWidth = 0.5
        lblCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblCantidadPasajes.layer.borderWidth = 0.5
        btnBusqueda.layer.borderColor = UIColor.blackColor().CGColor
        btnBusqueda.layer.borderWidth = 0.5
        btnLogin.layer.borderColor = UIColor.blackColor().CGColor
        btnLogin.layer.borderWidth = 0.5
        
        //si las ciudadesOrigen es vacio o null tengo que conectarme al ws
        if ciudadesOrigen == nil || ciudadesOrigen?.count==0{
            obtenerCiudadesOrigen()
        }
        
        let preferences = NSUserDefaults.standardUserDefaults()
        //me deslogueo cada vez que inicia la app. SACAR ESTO CUANDO ESTE IMPLEMENTADO EL CERRAR SESION
        preferences.setInteger(0, forKey: "login")
        preferences.synchronize()
    
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let preferences = NSUserDefaults.standardUserDefaults()
        if preferences.objectForKey("login") == nil {
            btnLogin.hidden = false
            self.dniLoggeado = nil
        } else {
            let login = preferences.integerForKey("login")
            if login == 0{
                btnLogin.hidden = false
            }else{
                self.dniLoggeado = preferences.integerForKey("dni")

                btnLogin.hidden = true
            }
        }
        
    }
    
    

    @IBAction func SetIdaVuelta(sender: UISwitch) {
       //     lblFechaVuelta.enabled=sender.on
        if(sender.on){
            lblFechaVuelta.setTitle("Fecha de vuelta", forState: UIControlState.Normal);
            lblFechaVuelta.enabled=true
        }
        else{
            lblFechaVuelta.setTitle("Solo ida", forState: UIControlState.Normal);
            lblFechaVuelta.enabled=false
        }
    }


    @IBAction func clickBusqueda(sender: UIButton) {
        var error: Bool = false
        var msgError: String = "Revise "
        //valido la ciudad de origen
        if(indexCiudadOrigen == -1){
            error = true
            msgError.extend("Ciudad de Origen")
        }
        //valido la ciudad de destino
        if(indexCiudadDestino == -1){
            error = true
            msgError.extend(", Ciudad de Destino")
        }
        //valido la fecha de ida
        if(diaIda == 0){
            error = true
            msgError.extend(", Fecha de ida")
        }
        if (chkIdaVuelta.on){
            //valido la ciudad de origen
            if(diaVuelta == 0 || !validateDate(diaIda, month: mesIda, year: anioIda, day2: diaVuelta, month2: mesVuelta, year2: anioVuelta)){
                error = true
                msgError.extend(", Fecha de vuelta")
            }
            
        }
        //valido la cantidad de pasajes
        if(cantidadPasajes == 0){
            error = true
            msgError.extend(", Cantidad de pasajes")
        }
        
        //si error es true largo un aviso
        if (error){ //sacar lo negado
            var alert = UIAlertView( title: "Error!", message: msgError,delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()
            
        }else{
            db.insert(ciudadesDestino![indexCiudadDestino!].desde!, city_destiny: ciudadesDestino![indexCiudadDestino!].hasta!, code_city_origin: ciudadesDestino![indexCiudadDestino!].id_localidad_origen!, code_city_destiny: ciudadesDestino![indexCiudadDestino!].id_localidad_destino!, date_go: "\(anioIda)-\(mesIda)-\(diaIda)", date_return: "\(anioVuelta)-\(mesVuelta)-\(diaVuelta)", number_tickets: self.cantidadPasajes, is_roundtrip: chkIdaVuelta.on)
        obtenerPrecios(ciudadesOrigen![indexCiudadOrigen!].id!, ID_LocalidadDestino: ciudadesDestino![indexCiudadDestino!].id_localidad_destino!)
        obtenerHorarios(ciudadesOrigen![indexCiudadOrigen!].id!, IdLocalidadDestino: ciudadesDestino![indexCiudadDestino!].id_localidad_destino!, Fecha: convertirFecha(diaIda, month: mesIda, year: anioIda), esVuelta: false)
        }
    }
    
    
    /*
    --------
    --------
    --------
    SECCION DONDE OTRAS VISTAS RETORNAN A ESTA
    --------
    --------
    --------
    */
    
     func ciudadOrigenElegida(index : Int){
        self.indexCiudadOrigen = index
        lblOrigen.setTitle(ciudadesOrigen![index].nombre!, forState: UIControlState.Normal)
        indexCiudadDestino = -1 // limpio con -1 para decir que no se eligio destino
        lblDestino.setTitle("Ciudad de destino", forState: UIControlState.Normal)
        obtenerCiudadesDestino(ciudadesOrigen![index].id!)
    }
    
    //guardo el indice del horario elegido
    func horarioIda(index : Int){
        self.indexHorarioIda = index
        if chkIdaVuelta.on {
            obtenerHorarios(ciudadesDestino![indexCiudadDestino!].id_localidad_destino!, IdLocalidadDestino: ciudadesOrigen![indexCiudadOrigen!].id!, Fecha: convertirFecha(diaVuelta, month: mesVuelta, year: anioVuelta), esVuelta: true)
        }
        else{// si no es vuelta largo para elegir reservar o comprar
            self.performSegueWithIdentifier("elegirReservaCompra", sender: self);
        }
    }
    
    //guardo el indice del horario elegido
    func horarioVuelta(index : Int){
        self.indexHorarioVuelta = index
        self.performSegueWithIdentifier("elegirReservaCompra", sender: self);

    }
    
    func ciudadDestinoElegida(index : Int){
        self.indexCiudadDestino = index
        lblDestino.setTitle(ciudadesDestino![index].hasta!, forState: UIControlState.Normal)
    }
    
    func cantidadPasajesElegidos(index : Int){
        self.cantidadPasajes = index
        lblCantidadPasajes.setTitle(cantidadPasajes.description, forState: UIControlState.Normal)
    }
    
    func fechaVuelta(day : Int, month : Int,year : Int){
        self.diaVuelta = day
        self.mesVuelta = month
        self.anioVuelta = year
        lblFechaVuelta.setTitle("\(day)/\(month)/\(year)", forState: UIControlState.Normal)
    }
    
    func fechaIda(day : Int, month : Int,year : Int){
        self.diaIda = day
        self.mesIda = month
        self.anioIda = year
        lblFechaIda.setTitle("\(day)/\(month)/\(year)", forState: UIControlState.Normal)
    }

    //SECCION SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        if identifier == "CiudadesOrigen"{ //largo el segue para elegir la ciudad de origen
            let ciudadesOrigenViewController = segue.destinationViewController as! CiudadesOrigenViewController
            //si las ciudadesOrigen es vacio o null tengo que conectarme al ws
            if ciudadesOrigen == nil || ciudadesOrigen?.count==0{
                obtenerCiudadesOrigen()
            }
            ciudadesOrigenViewController.ciudadesOrigen = self.ciudadesOrigen
            ciudadesOrigenViewController.busquedaViewController = self
        }
        if identifier == "CiudadesDestino"{ //largo el segue para elegir la ciudad de destino
            let ciudadesDestinoViewController = segue.destinationViewController as! CiudadesDestinoViewController
            ciudadesDestinoViewController.ciudadesDestino = self.ciudadesDestino
            ciudadesDestinoViewController.busquedaViewController = self
        }
        if identifier == "elegirHorarioIda"{ //largo el segue para elegir el horario de ida
            let horariosViewController = segue.destinationViewController as! HorarioIdaViewController
            horariosViewController.horarios = self.horariosIda
            horariosViewController.lblDesdeHastaTexto = "\(ciudadesDestino![indexCiudadDestino!].desde!) - \(ciudadesDestino![indexCiudadDestino!].hasta!)"
            horariosViewController.lblPrecioIdaTexto = self.precioIda
            horariosViewController.lblPrecioIdaVueltaTexto = self.precioIdaVuelta
            horariosViewController.busquedaViewController = self
        }
        if identifier == "elegirHorarioVuelta"{ //largo el segue para elegir el horario de vuelta
            let horariosViewController = segue.destinationViewController as! HorarioVueltaViewController
            horariosViewController.horarios = self.horariosVuelta
            horariosViewController.lblDesdeHastaTexto = "\(ciudadesDestino![indexCiudadDestino!].hasta!) - \(ciudadesDestino![indexCiudadDestino!].desde!)"
            horariosViewController.lblPrecioIdaTexto = self.precioIda
            horariosViewController.lblPrecioIdaVueltaTexto = self.precioIdaVuelta
            horariosViewController.busquedaViewController = self
        }
        if identifier == "elegirCantidadPasajes"{ //largo el segue para elegir el horario de vuelta
            let cantidadPasajesViewController = segue.destinationViewController as! PasajesTableViewController
            cantidadPasajesViewController.busquedaViewController = self

        }
        if identifier == "elegirFechaVuelta"{ //largo el segue para elegir fecha de vuelta
            let calendarViewController = segue.destinationViewController as! CalendarViewController
            calendarViewController.busquedaViewController = self
            calendarViewController.esVuelta = true

        }
        if identifier == "elegirFechaIda"{ //largo el segue para elegir fecha de vuelta
            let calendarViewController = segue.destinationViewController as! CalendarViewController
            calendarViewController.busquedaViewController = self
            calendarViewController.esVuelta = false
        }
        
        if identifier == "elegirReservaCompra"{ //largo el segue para ver el detalle de reservas
            let resumenViewController = segue.destinationViewController as! ResumenViewController
            resumenViewController.horarioIda = self.horariosIda![indexHorarioIda!]
            resumenViewController.precioIda = self.precioIda
            resumenViewController.precioIdaVuelta = self.precioIdaVuelta
            resumenViewController.ciudadOrigen = self.ciudadesOrigen![indexCiudadOrigen!]
            resumenViewController.ciudadDestino = self.ciudadesDestino![indexCiudadDestino!]
            resumenViewController.cantidadPasajes = self.cantidadPasajes
            if chkIdaVuelta.on { //es ida y vuelta
                resumenViewController.horarioVuelta = self.horariosVuelta![indexHorarioVuelta!]
                resumenViewController.esIdaVuelta = true
            }
            else{
                resumenViewController.esIdaVuelta = false
            }
        }
    }
    
    
    
    /*
    -----
    -----
    ACA PONGO FUNCIONES AUXILIARES
    -----
    -----
    */
    
    //retorna true si la primer fecha es menor que la segunda
    func validateDate(day: Int, month: Int, year : Int,day2: Int, month2: Int, year2 : Int) -> Bool{
        if(year < year2){
            return true
        }
        if(year > year2){
            return false
        }else{
            if (month < month2){
                return true
            }
            if (month > month2){
                return false
            }else{
                if (day <= day2){
                    return true
                }
                else {
                    return false
                }
            }
        }
    }
    
    func convertirFecha(day: Int, month: Int, year:Int) -> String{
        var result :String = year.description
        if count(month.description) < 2{ // es el dia 1-9
            result.extend("0\(month)")
        }else{
            result.extend("\(month)")
        }
        if count(day.description) < 2{ // es el dia 1-9
            result.extend("0\(day)")
        }else{
            result.extend("\(day)")
        }
        return result
    }
    
    /*
    ------
    ------
    ------
    ------
    ACA ARRANCA LA SECCION DE LAS LLAMADAS A LOS WEB SERVICES
    ------
    ------
    ------
    */
    
    //obtengo las ciudades de origen y las guardo en el arreglo
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
                    
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.ciudadesOrigen = CiudadOrigen.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                        self.loadImage.hidden = true
                    })
                }
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.ciudadesOrigen =  nil
                    self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }

    
    
    func obtenerCiudadesDestino(IdLocalidadOrigen: Int){
        self.loadImage.hidden = false
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
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.ciudadesDestino = CiudadDestino.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                        self.loadImage.hidden = true
                    })
                }
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.ciudadesDestino = nil
                    self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }
    
    
    //obtengo los horarios, esVuelta dice si se esta eligiendo la vuelta para saber que segue largar
    func obtenerHorarios(IdLocalidadOrigen: Int, IdLocalidadDestino: Int, Fecha: String, esVuelta: Bool){
        self.loadImage.hidden = false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var auxDni : String = "" // para usarlo si el dni esta logeado o no
        if dniLoggeado != nil {
            auxDni = "<DNI i:type='d:int'>\(dniLoggeado!)</DNI>"
        }
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:ListarHorarios id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS>\(auxDni)<Fecha i:type='d:string'>\(Fecha)</Fecha><IdLocalidadOrigen i:type='d:int'>\(IdLocalidadOrigen)</IdLocalidadOrigen><IdLocalidadDestino i:type='d:int'>\(IdLocalidadDestino)</IdLocalidadDestino><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:ListarHorarios></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
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
            //println(strData)
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                   // println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadImage.hidden = true
                        if esVuelta {
                            self.horariosVuelta = Horario.fromDictionary(json) // parseo  y obtengo un arreglo de horarios
                            self.performSegueWithIdentifier("elegirHorarioVuelta", sender: self);
                        }else{
                            self.horariosIda = Horario.fromDictionary(json) // parseo  y obtengo un arreglo de horarios
                            self.performSegueWithIdentifier("elegirHorarioIda", sender: self);
                        }
                    })
                }
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.horariosVuelta = nil
                    self.horariosIda = nil
                    self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }


    
    //calculo los precios y se guardan en las variables precioIda y precioIdaVuelta
    func obtenerPrecios(ID_LocalidadOrigen: Int, ID_LocalidadDestino: Int){
        self.loadImage.hidden = false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:ObtenerTarifaTramo id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><ID_LocalidadOrigen i:type='d:int'>\(ID_LocalidadOrigen)</ID_LocalidadOrigen><ID_LocalidadDestino i:type='d:int'>\(ID_LocalidadDestino)</ID_LocalidadDestino><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma></n0:ObtenerTarifaTramo></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#ObtenerTarifaTramo", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
      //      println(strData)
            var parser : String = strData as String
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var rangeFrom = parser.rangeOfString("TarIda:")
                var rangeTo = parser.rangeOfString(" - Tar")
                if (rangeFrom == nil){
                    self.precioIda = "0,00"
                    self.precioIdaVuelta = "0,00"
                }else{
                    self.precioIda = parser[rangeFrom!.endIndex..<rangeTo!.startIndex]
                    rangeFrom = parser.rangeOfString("TarIdAVuelta:")
                    rangeTo = parser.rangeOfString("</return>")
                    self.precioIdaVuelta = parser[rangeFrom!.endIndex..<rangeTo!.startIndex]
                    if((self.precioIda!.rangeOfString(",")) == nil){
                        self.precioIda?.extend(",00")
                    }
                    if((self.precioIdaVuelta!.rangeOfString(",")) == nil){
                        self.precioIdaVuelta?.extend(",00")
                    }
                }
                self.loadImage.hidden = true
            })
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.precioIda = nil
                    self.precioIdaVuelta = nil
                    self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }
}

