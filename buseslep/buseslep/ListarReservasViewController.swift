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
        mostrarAlerta()
        
    }
    
    func mostrarAlerta() {
        var alerta = UIAlertController(title: "Seleccione una opcion", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Realizar compra", style: UIAlertActionStyle.Default, handler: { alertAction in
            println("compra")
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar reserva", style: UIAlertActionStyle.Default, handler: { alertAction in
            println("cancelar")
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
            
            println(strData)
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
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
    
    
}
