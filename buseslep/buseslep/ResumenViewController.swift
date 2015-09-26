//
//  ResumenViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 5/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ResumenViewController: UIViewController {
    
    
    @IBOutlet weak var lblCiudadesIda: UILabel!
    
    @IBOutlet weak var lblCiudadesIdaVuelta: UILabel!
    @IBOutlet weak var lblFechaSaleIda: UILabel!
    @IBOutlet weak var lblFechaLlegaIda: UILabel!
    @IBOutlet weak var lblHoraSaleIda: UILabel!
    @IBOutlet weak var lblHoraLlegaIda: UILabel!
    @IBOutlet weak var lblFechaSaleVuelta: UILabel!
    @IBOutlet weak var lblFechaLlegaVuelta: UILabel!
    @IBOutlet weak var lblHoraSaleVuelta: UILabel!
    @IBOutlet weak var lblHoraLlegaVuelta: UILabel!
    @IBOutlet weak var lblImporte: UILabel!
    @IBOutlet weak var btnComprar: UIButton!
    @IBOutlet weak var btnReservar: UIButton!
    
    @IBOutlet weak var viewVuelta: UIView!
    @IBOutlet weak var viewIda: UIView!
    @IBOutlet weak var lblSeparadorIda: UILabel!
    @IBOutlet weak var lblSeparadorVuelta: UILabel!
    @IBOutlet weak var lblCantidadPasajes: UILabel!
    @IBOutlet weak var lblDescripcionCantidadPasajes: UILabel!
    
    var horarioIda : Horario?
    var horarioVuelta : Horario?
    
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?
    
    var precioIda : String?
    var precioIdaVuelta: String?
    
    var esIdaVuelta : Bool?
    
    var cantidadPasajes : Int?
    var precioIdaFloat : CGFloat?
    var precioIdaVueltaFloat : CGFloat?
    var idVenta: Int = 0
    var asientosIda : Set<Int>?
    var asientosVuelta :Set<Int>?
    var seleccionarAsientosVuelta :Bool = false
    var pasarSeleccionarAsientos: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precioIdaFloat = CGFloat((self.precioIda! as NSString).floatValue)
        precioIdaVueltaFloat = CGFloat((self.precioIdaVuelta! as NSString).floatValue)

        btnComprar.layer.borderColor = UIColor.blackColor().CGColor
        btnComprar.layer.borderWidth = 0.5
        btnReservar.layer.borderColor = UIColor.blackColor().CGColor
        btnReservar.layer.borderWidth = 0.5
        viewIda.layer.borderColor = UIColor.blackColor().CGColor
        viewIda.layer.borderWidth = 0.5
        viewVuelta.layer.borderColor = UIColor.blackColor().CGColor
        viewVuelta.layer.borderWidth = 0.5
        lblCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblCantidadPasajes.layer.borderWidth = 0.5
        lblDescripcionCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblDescripcionCantidadPasajes.layer.borderWidth = 0.5
        lblCiudadesIda.text = "\(ciudadDestino!.desde!)-\(ciudadDestino!.hasta!)"
        lblFechaSaleIda.text = horarioIda?.fecha_sale
        lblHoraSaleIda.text = horarioIda?.hora_sale
        lblFechaLlegaIda.text = horarioIda?.fecha_llega
        lblHoraLlegaIda.text = horarioIda?.hora_llega
        lblCantidadPasajes.text = "\(cantidadPasajes!)"
        if esIdaVuelta! {
            lblCiudadesIdaVuelta.text = "\(ciudadDestino!.hasta!)-\(ciudadDestino!.desde!)"
            lblFechaSaleVuelta.text = horarioVuelta?.fecha_sale
            lblHoraSaleVuelta.text = horarioVuelta?.hora_sale
            lblFechaLlegaVuelta.text = horarioVuelta?.fecha_llega
            lblHoraLlegaVuelta.text = horarioVuelta?.hora_llega
            var precioTotal = CGFloat(cantidadPasajes!) *   CGFloat(cantidadPasajes!)
            lblImporte.text = "\(precioIdaVueltaFloat! * CGFloat(cantidadPasajes!))0"
        }else{
            lblCiudadesIdaVuelta.text = "  "
            lblFechaSaleVuelta.hidden = true
            lblHoraSaleVuelta.hidden = true
            lblFechaLlegaVuelta.hidden = true
            lblHoraLlegaVuelta.hidden = true
            lblSeparadorVuelta.hidden = true
            lblImporte.text = "$\(precioIdaFloat! * CGFloat(cantidadPasajes!))0"
            

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if pasarSeleccionarAsientos{
            pasarSeleccionarAsientos = false
            println("paso de largo capo")
            println(self.idVenta)
            println(self.cantidadPasajes)
            self.performSegueWithIdentifier("Comprar", sender: self);
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Reservar"){
            let reserveDetailsViewController = segue.destinationViewController as! ReserveDetailsViewController
            reserveDetailsViewController.EsCompra = 0;
            reserveDetailsViewController.EsIdaVuelta = self.esIdaVuelta!
            reserveDetailsViewController.CantidadIda = self.cantidadPasajes!
            reserveDetailsViewController.horarioIda = self.horarioIda!
            if self.esIdaVuelta! {
                reserveDetailsViewController.horarioVuelta = self.horarioVuelta!
            }
            reserveDetailsViewController.ciudadOrigen = self.ciudadOrigen!
            reserveDetailsViewController.ciudadDestino = self.ciudadDestino!
        }
        if(segue.identifier == "DetallesCompra"){
            let reserveDetailsViewController = segue.destinationViewController as! ReserveDetailsViewController
            reserveDetailsViewController.EsCompra = 1;
            reserveDetailsViewController.EsIdaVuelta = self.esIdaVuelta!
            reserveDetailsViewController.CantidadIda = self.cantidadPasajes!
            reserveDetailsViewController.horarioIda = self.horarioIda!
            reserveDetailsViewController.butacasIda = self.asientosIda!
            reserveDetailsViewController.idVenta = self.idVenta
            var precio = self.precioIdaFloat! * CGFloat(cantidadPasajes!)
            reserveDetailsViewController.totalPrice = Double(precio)
            if self.esIdaVuelta! {
                var precio2 = self.precioIdaVueltaFloat! * CGFloat(cantidadPasajes!)
                reserveDetailsViewController.totalPrice = Double(precio2)
                reserveDetailsViewController.horarioVuelta = self.horarioVuelta!
                reserveDetailsViewController.butacasVuelta = self.asientosVuelta!
            }
            reserveDetailsViewController.ciudadOrigen = self.ciudadOrigen!
            reserveDetailsViewController.ciudadDestino = self.ciudadDestino!
        }
        if(segue.identifier == "Comprar"){
            let seatSelectionViewController = segue.destinationViewController as! SeatSelectionViewController
            seatSelectionViewController.idVenta = self.idVenta
            seatSelectionViewController.resumenViewController = self;
            if(!seleccionarAsientosVuelta){
                seatSelectionViewController.esIda = 1
                seatSelectionViewController.cantPasajes = self.cantidadPasajes!
                seatSelectionViewController.horario = self.horarioIda!
                seatSelectionViewController.ciudadDestino = self.ciudadDestino!
            }
            else{
                seatSelectionViewController.esIda = 0
                seatSelectionViewController.cantPasajes = self.cantidadPasajes!
                seatSelectionViewController.horario = self.horarioVuelta!
                seatSelectionViewController.ciudadDestino = self.ciudadDestino!
            }
        }
    }
    
    func guardarAsientos(asientos: Set<Int>, esIda :Int){ //este metodo se llama desde La seleccion de asientos antes de retornar
        if(esIda == 1){
            asientosIda = asientos
            if(esIdaVuelta!){
                 seleccionarAsientosVuelta = true
                 self.performSegueWithIdentifier("Comprar", sender: self);
            }
            else{
                 self.performSegueWithIdentifier("DetallesCompra", sender: self);
            }
        }
        else{
            asientosVuelta = asientos
            self.performSegueWithIdentifier("DetallesCompra", sender: self);
        }
    }
    
    
    
    @IBAction func clickComprar(sender: UIButton) {
        let preferences = NSUserDefaults.standardUserDefaults()
        if ( preferences.objectForKey("login") != nil && preferences.integerForKey("login") != 0 ) {
            reservaParaCompra()
        }
        else{
            self.performSegueWithIdentifier("Login", sender: self);
        }

    }
    
    @IBAction func clickReservar(sender: UIButton) {
        let preferences = NSUserDefaults.standardUserDefaults()
        if preferences.objectForKey("login") != nil && preferences.integerForKey("login") != 0 {
            self.performSegueWithIdentifier("Reservar", sender: self);
        }
        else{
            self.performSegueWithIdentifier("Login", sender: self);
        }
    }
    
    func reservaParaCompra(){
        //self.loadIcon.hidden = false
        let preferences = NSUserDefaults.standardUserDefaults()
        let dni = preferences.objectForKey("dni")!.description
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage : String = ""
        if(self.esIdaVuelta!){
            soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AgregarReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IDEmpresaIda i:type='d:int'>\(self.horarioIda!.Id_Empresa!)</IDEmpresaIda><IDDestinoIda i:type='d:int'>\(self.horarioIda!.id_destino!)</IDDestinoIda><CodHorarioIda i:type='d:int'>\(self.horarioIda!.cod_horario!)</CodHorarioIda><IdLocalidadDesdeIda i:type='d:int'>\(self.ciudadDestino!.id_localidad_origen!)</IdLocalidadDesdeIda><IdlocalidadHastaIda i:type='d:int'>\(self.ciudadDestino!.id_localidad_destino!)</IdlocalidadHastaIda><CantidadIda i:type='d:int'>\(self.cantidadPasajes!)</CantidadIda><IDEmpresaVuelta i:type='d:int'>\(self.horarioVuelta!.Id_Empresa!)</IDEmpresaVuelta><IDDestinoVuelta i:type='d:int'>\(self.horarioVuelta!.id_destino!)</IDDestinoVuelta><CodHorarioVuelta i:type='d:int'>\(self.horarioVuelta!.cod_horario!)</CodHorarioVuelta><IdLocalidadDesdeVuelta i:type='d:int'>\(self.ciudadDestino!.id_localidad_destino!)</IdLocalidadDesdeVuelta><IdlocalidadHastaVuelta i:type='d:int'>\(self.ciudadDestino!.id_localidad_origen!)</IdlocalidadHastaVuelta><CantidadVuelta i:type='d:int'>\(self.cantidadPasajes!)</CantidadVuelta><EsCompra i:type='d:int'>\(1)</EsCompra></n0:AgregarReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        }
        else{
            soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AgregarReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IDEmpresaIda i:type='d:int'>\(self.horarioIda!.Id_Empresa!)</IDEmpresaIda><IDDestinoIda i:type='d:int'>\(self.horarioIda!.id_destino!)</IDDestinoIda><CodHorarioIda i:type='d:int'>\(self.horarioIda!.cod_horario!)</CodHorarioIda><IdLocalidadDesdeIda i:type='d:int'>\(self.ciudadDestino!.id_localidad_origen!)</IdLocalidadDesdeIda><IdlocalidadHastaIda i:type='d:int'>\(self.ciudadDestino!.id_localidad_destino!)</IdlocalidadHastaIda><CantidadIda i:type='d:int'>\(self.cantidadPasajes!)</CantidadIda><IDEmpresaVuelta i:type='d:int'>\(0)</IDEmpresaVuelta><IDDestinoVuelta i:type='d:int'>\(0)</IDDestinoVuelta><CodHorarioVuelta i:type='d:int'>\(0)</CodHorarioVuelta><IdLocalidadDesdeVuelta i:type='d:int'>\(0)</IdLocalidadDesdeVuelta><IdlocalidadHastaVuelta i:type='d:int'>\(0)</IdlocalidadHastaVuelta><CantidadVuelta i:type='d:int'>\(0)</CantidadVuelta><EsCompra i:type='d:int'>\(1)</EsCompra></n0:AgregarReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        }
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
                //self.loadIcon.hidden = true
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                if let rangeF = parser.rangeOfString("<return xsi:type=\"xsd:string\">") { // con esto hago un subrango
                    if let rangeT = parser.rangeOfString("</return>") {
                        var resultCode: String = parser[rangeF.endIndex..<rangeT.startIndex]
                        println(resultCode)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println(resultCode)
                            var r : Int = resultCode.toInt()!
                            if (r >= 0){
                                //let alert = UIAlertView(title: "Atencion!", message: "Error al realizar la reserva", delegate:nil, cancelButtonTitle: "Aceptar")
                                //alert.show()
                            //}
                            //else{
                                self.idVenta = r
                                self.performSegueWithIdentifier("Comprar", sender: self);
                            //}
                            //self.loadIcon.hidden = true
                            }
                        })
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
