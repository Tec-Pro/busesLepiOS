//
//  ListarReservasViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ListarReservasViewController: UITableViewController{
    
    var a:[String] = ["hola","chau","capo"]
    var reservas = [Reserva]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var r: Reserva = Reserva(sentido: "ida", fechaReserva: "fecha", salida: "salida", destino: "c a c2", cantidad: 1)
        reservas.append(r)
        self.obtenerReservas()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("gola1")
        return reservas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("c") as? UITableViewCell
        let reserva = reservas[indexPath.row]
        cell?.textLabel?.text = reserva.destino
        println("gola2")
        return cell!
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
                    println("PARSEADO")
                    println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.reservas = Reserva.fromDictionary(json)
                   // self.listar()
                    // })
                    
                }
                
            } else {
                if let rangeF = parser.rangeOfString("<return xsi:type=") { // con esto hago un subrango
                    if let rangeT = parser.rangeOfString("</return>") {
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
                    
                })
                
            }
        })
        task.resume()
    }


}
