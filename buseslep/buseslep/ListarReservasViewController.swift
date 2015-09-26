//
//  ListarReservasViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ListarReservasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var reservas = [Reserva]()
    var fechaReserva: String = ""
    
    var idVenta: Int = 0
    var cantidadPasajes: Int = 0
    var horarioIda : Horario?
    var horarioVuelta : Horario?
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?
    var esIda: Bool = true
    var precio: String = ""
    var precioIdaVuelta: String=""
    var fechaSaleIda: String?
    var horaSaleIda: String?
    var fechaSaleVuelta: String?
    var horaSaleVuelta: String?
    var ciudadDesdeIda: String?
    var ciudadHastaIda: String?
    var ciudadDesdeVuelta: String?
    var ciudadHastaVuelta: String?
    var control: Int = 0
    override func viewDidLoad() {
        self.obtenerReservas()
        super.viewDidLoad()
        println("RESERVAS")
        println(reservas.count)
        tableView.delegate = self
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        tableView.tableFooterView = UIView()
        self.control = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = UITableViewCell()
        let reserva = reservas[indexPath.row]
        if reserva.sentidoVuelta != ""{
            
            
            let cellIdaVuelta = tableView.dequeueReusableCellWithIdentifier("celdaIdaVuelta") as?CeldaReservaIdaVueltaViewController
            cellIdaVuelta?.salidaIda.text = reserva.salidaIda
            cellIdaVuelta?.cantIda.text = reserva.cantidadIda.description
            cellIdaVuelta?.destinoIda.text = reserva.destinoIda
            cellIdaVuelta?.salidaVuelta.text = reserva.salidaVuelta
            cellIdaVuelta?.cantVuelta.text = reserva.cantidadVuelta.description
            cellIdaVuelta?.destinoVuelta.text = reserva.destinoVuelta
            println("entre a celda uda y vuelta")
            
            return cellIdaVuelta!
            
        }else{
            let cellIda = tableView.dequeueReusableCellWithIdentifier("c") as? CeldaReservaViewController
            cellIda?.sentido.text = reserva.sentidoIda
            cellIda?.salida.text = reserva.salidaIda
            cellIda?.cant.text = reserva.cantidadIda.description
            cellIda?.destino.text = reserva.destinoIda
            return cellIda!
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        fechaReserva = reservas[indexPath.row].fechaReservaIda!
        println(fechaReserva)
        println(reservas[indexPath.row].destinoIda)
        var reserva = reservas[indexPath.row]
        if reservas[indexPath.row].sentidoVuelta == ""{
            self.esIda = true
        }else{
            self.esIda = false
            //vuela
            var f = reservas[indexPath.row].salidaVuelta!.substringFromIndex(reservas[indexPath.row].salidaVuelta!.indexAt(0))
            var t = f.substringToIndex(f.indexAt(10))
            self.fechaSaleVuelta = t
            var hi = reservas[indexPath.row].salidaVuelta!.substringFromIndex(reservas[indexPath.row].salidaVuelta!.indexAt(11))
            self.horaSaleVuelta = hi
            //
            //vuelta
            var p : String = reserva.destinoVuelta!
            var ciudadesV = p.componentsSeparatedByString(" a ")
            self.ciudadDesdeVuelta = ciudadesV[0]
            self.ciudadHastaVuelta = ciudadesV[1]
        }
        var from = reservas[indexPath.row].salidaIda!.substringFromIndex(reservas[indexPath.row].salidaIda!.indexAt(0))
        var to = from.substringToIndex(from.indexAt(10))
        self.fechaSaleIda = to
        var horaInicio = reservas[indexPath.row].salidaIda!.substringFromIndex(reservas[indexPath.row].salidaIda!.indexAt(11))
        self.horaSaleIda = horaInicio
        
        
        
        var parser : String = reserva.destinoIda!
        var ciudades = parser.componentsSeparatedByString(" a ")
        self.ciudadDesdeIda = ciudades[0]
        self.ciudadHastaIda = ciudades[1]
        
        
        
        mostrarAlerta()
        
    }
    
    func mostrarAlerta() {
        var alerta = UIAlertController(title: "Seleccione una opcion", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Realizar compra", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.PasarReservasaPrepago()
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar reserva", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.cancelarReserva()
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alerta.addAction(UIAlertAction(title: "Salir", style: UIAlertActionStyle.Default, handler: { alertAction in
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    func obtenerReservas(){
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        let preferences = NSUserDefaults.standardUserDefaults()
        var dni = preferences.valueForKey("dni")!.description
        //var dni = dniInt.description
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:ListarMisReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><Dni i:type='d:string'>\(dni)</Dni><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:ListarMisReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        //holaokkkk
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#ListarMisReserva", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    println("datos reserva")
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.reservas = Reserva.fromDictionary(json)
                        if self.reservas.count == 0{
                            self.navigationController?.popViewControllerAnimated(true)
                            let alert = UIAlertView(title: "Atencion!", message: "No tiene reservas", delegate:nil, cancelButtonTitle: "Aceptar")
                            alert.show()
                            
                        }
                        self.tableView.reloadData()
                    })
                    
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertView(title: "Atencion!", message: "No se ha podido iniciar sesión", delegate:nil, cancelButtonTitle: "Aceptar")
                    alert.show()
                })
                
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    
                })
                
            }
        })
        task.resume()
    }
    
    func cancelarReserva(){
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        let preferences = NSUserDefaults.standardUserDefaults()
        var dni = preferences.valueForKey("dni")!.description
        //var dni = dniInt.description
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AnularReservas id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><FechaHoraReserva i:type='d:string'>\(fechaReserva)</FechaHoraReserva><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:AnularReservas></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        //holaokkkk
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#AnularReservas", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println("RETORNOOOOO")
            println(strData)
            var parser : String = strData as String
            if let rangeF = parser.rangeOfString("<return xsi:type=") { // con esto hago un subrango
                if let rangeT = parser.rangeOfString(">1</return>") {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertView(title: "Atencion!", message: "Reserva cancelada correctamente", delegate:nil, cancelButtonTitle: "Aceptar")
                        alert.show()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    
                })
                
            }
        })
        task.resume()
    }
    
    func PasarReservasaPrepago(){
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        let preferences = NSUserDefaults.standardUserDefaults()
        var dni = preferences.valueForKey("dni")!.description
        //var dni = dniInt.description
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:PasarReservasaPrepago id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><FechaHoraReserva i:type='d:string'>\(fechaReserva)</FechaHoraReserva><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma></n0:PasarReservasaPrepago></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        //holaokkkk
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#PasarReservasaPrepago", forHTTPHeaderField: "SOAPAction") //aca cambio login por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                    println("PARSEADO")
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let list = json["Data"] as? NSArray // obtengo el Data del json que retornan, dentro estan los datos
                        list?.enumerateObjectsWithOptions(NSEnumerationOptions.allZeros, usingBlock:{ (item, index, stop) -> Void in
                            
                            self.idVenta = item["Id_Venta"] as! Int
                            self.cantidadPasajes = item["cantidad"] as! Int
                            var rangeFromm = datos.rangeOfString("[{")
                            var rangeToo = datos.rangeOfString("},")
                            if (rangeToo == nil){//es solo ida
                                println("ES SOLO IDA")
                                self.horarioIda = Horario(ServicioPrestado: "", fecha_llega: "", hora_llega: "", fecha_sale: self.fechaSaleIda!, hora_sale: self.horaSaleIda!, cod_horario: item["Cod_Horario"] as! Int, Id_Empresa: item["Id_Empresa"] as! Int, id_destino: item["Id_Destino"] as! Int)
                                self.ciudadDestino = CiudadDestino(id_localidad_origen: item["ID_Localidad_Origen"] as! Int, id_localidad_destino: item["ID_Localidad_Destino"] as! Int, hasta: self.ciudadHastaIda!, desde: self.ciudadDesdeIda!)
                                self.ciudadOrigen = CiudadOrigen(id: item["ID_Localidad_Origen"] as! Int, nombre: self.ciudadDesdeIda!)
                                self.precio = item["Importe"] as! String
                            }else{
                                println("ES TAMBIEN VUELTA")
                                var primer: String = datos.substringToIndex(rangeToo!.startIndex)
                                var rf = primer.rangeOfString("Importe\":\"")
                                var imp1: String = primer.substringFromIndex(rf!.endIndex)
                                var rt = imp1.rangeOfString("\",\"cant")
                                var importe: String = imp1.substringToIndex(rt!.startIndex)
                                self.precio = importe
                                
                                
                                var seg: String = datos.substringFromIndex(rangeToo!.startIndex)
                                var rf2 = seg.rangeOfString("Importe\":\"")
                                var imp2: String = seg.substringFromIndex(rf2!.endIndex)
                                var rt2 = imp2.rangeOfString("\",\"cant")
                                var importe2: String = imp2.substringToIndex(rt2!.startIndex)
                                self.precioIdaVuelta = importe2
                                println(self.precio)
                                println(self.precioIdaVuelta)
                                
                                self.horarioIda = Horario(ServicioPrestado: "", fecha_llega: "", hora_llega: "", fecha_sale: self.fechaSaleIda!, hora_sale: self.horaSaleIda!, cod_horario: item["Cod_Horario"] as! Int, Id_Empresa: item["Id_Empresa"] as! Int, id_destino: item["Id_Destino"] as! Int)
                                
                                self.horarioVuelta = Horario(ServicioPrestado: "", fecha_llega: "", hora_llega: "", fecha_sale: self.fechaSaleVuelta!, hora_sale: self.horaSaleVuelta!, cod_horario: item["Cod_Horario"] as! Int, Id_Empresa: item["Id_Empresa"] as! Int, id_destino: item["Id_Destino"] as! Int)
                                
                                
                                self.ciudadDestino = CiudadDestino(id_localidad_origen: item["ID_Localidad_Origen"] as! Int, id_localidad_destino: item["ID_Localidad_Destino"] as! Int, hasta: self.ciudadHastaVuelta!, desde: self.ciudadDesdeVuelta!)
                                self.ciudadOrigen = CiudadOrigen(id: item["ID_Localidad_Origen"] as! Int, nombre: self.ciudadDesdeVuelta!)
                            }
                            self.control = self.control + 1
                            if self.control == 1{
                                self.performSegueWithIdentifier("Resumen", sender: self)
                            }
                            
                        })
                    })
                    
                }
                
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    
                })
                
            }
        })
        task.resume()

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Resumen"){
            let res = segue.destinationViewController as! ResumenViewController
            res.pasarSeleccionarAsientos = true
            res.idVenta = self.idVenta
            res.cantidadPasajes = self.cantidadPasajes
            if esIda {
                res.esIdaVuelta = false
            }else{
                res.esIdaVuelta = true
            }
            res.precioIda = self.precio
            var importeIdaFloat = CGFloat((self.precio as NSString).floatValue)
            var importeIdaVueltaFloat = CGFloat((self.precioIdaVuelta as NSString).floatValue)
            var importFinal = importeIdaFloat + importeIdaVueltaFloat
            res.precioIdaVuelta = importFinal.description
            res.ciudadDestino = self.ciudadDestino!
            res.ciudadOrigen = self.ciudadOrigen!
            res.horarioIda = self.horarioIda!
            res.horarioVuelta = self.horarioVuelta
            
        }
    }
    
}
