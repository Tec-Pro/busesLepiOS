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
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblButacaIdaText: UILabel!
    @IBOutlet var lblButacaVueltaText: UILabel!
    @IBOutlet var lblCantButacaIda: UILabel!
    @IBOutlet var lblCantButacaVuelta: UILabel!
    @IBOutlet var borderView: UIView!
    @IBOutlet var loadIcon: UIActivityIndicatorView!
    @IBOutlet var viewDestVuelta: UIView!
    @IBOutlet var viewDestVuelta2: UIView!
    @IBOutlet var viewLugarDeAbordoVuelta: UIView!
    @IBOutlet var viewSalidaVuelta: UIView!
    @IBOutlet var viewPlataformaVuelta: UIView!
    @IBOutlet var viewCantPasajesVuelta: UIView!
    @IBOutlet var viewGreyBar: UIView!
    @IBOutlet var viewTotal: UIView!
    
    var dni: String = ""
    var horarioIda : Horario?
    var horarioVuelta : Horario?
    
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?

    var IDEmpresaIda: Int = 0
    var IDDestinoIda: Int = 0
    var CodHorarioIda: Int = 0
    var IdLocalidadDesdeIda: Int = 0
    var IdlocalidadHastaIda: Int = 0
    var CantidadIda: Int = 0
    var CantidadVuelta: Int = 0
    var IDEmpresaVuelta: Int = 0
    var IDDestinoVuelta: Int = 0
    var CodHorarioVuelta: Int = 0
    var IdLocalidadDesdeVuelta: Int = 0
    var IdlocalidadHastaVuelta: Int = 0
    var EsCompra: Int = 0
    var EsIdaVuelta: Bool = true
    var totalPrice: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = NSUserDefaults.standardUserDefaults()
        //dni = preferences.objectForKey("dni") as! String
        //dni = "37128116"
        loadIcon.hidden = true
        btnReserve.layer.borderColor = UIColor.blackColor().CGColor
        btnReserve.layer.borderWidth = 0.5
        borderView.layer.borderWidth = 0.5
        if(EsCompra == 0){
            viewTotal.hidden = true
            lblButacaIdaText.text = "Plataforma"
            lblButacaVueltaText.text = "Plataforma"
            lblCantButacaIda.text = ""
            lblCantButacaVuelta.text = ""
            btnReserve.setTitle("Reservar", forState: UIControlState.Normal)
        }
        else{
            viewTotal.hidden = false
            lblButacaIdaText.text = "Butaca"
            lblButacaVueltaText.text = "Butaca"
            lblCantButacaIda.text = "1"
            lblCantButacaVuelta.text = "1"
            btnReserve.setTitle("Confirmar", forState: UIControlState.Normal)
        }
        lblCiudadOrigen.text = self.ciudadOrigen!.nombre!
        lblCiudadDestino.text = self.ciudadDestino!.hasta!
        lblCiudadOrigenVuelta.text = self.ciudadDestino!.hasta!
        lblCiudadDestinoVuelta.text = self.ciudadOrigen!.nombre!
        lblHora.text = self.horarioIda!.hora_sale!
        lblFecha.text = self.horarioIda!.fecha_sale!
        lblCantPasajes.text = String(self.CantidadIda)
        lblCantPasajesVuelta.text = String(self.CantidadIda)
        IDEmpresaIda = horarioIda!.Id_Empresa!
        IdLocalidadDesdeIda = self.ciudadDestino!.id_localidad_origen!
        IdlocalidadHastaIda = self.ciudadDestino!.id_localidad_destino!
        IdLocalidadDesdeVuelta = self.ciudadDestino!.id_localidad_destino!
        IdlocalidadHastaVuelta = self.ciudadDestino!.id_localidad_origen!
        IDDestinoIda = self.horarioIda!.id_destino!
        CantidadVuelta = CantidadIda
        CodHorarioIda = horarioIda!.cod_horario!
        if horarioVuelta != nil{
            IDEmpresaVuelta = horarioVuelta!.Id_Empresa!
            CodHorarioVuelta = horarioVuelta!.cod_horario!
            IDDestinoVuelta = self.horarioVuelta!.id_destino!
            lblHoraVuelta.text = self.horarioVuelta!.hora_sale!
            lblFechaVuelta.text = self.horarioVuelta!.fecha_sale!
        }
        if(!EsIdaVuelta){
            CantidadVuelta = 0
            IDEmpresaVuelta = 0
            IDDestinoVuelta = 0
            CodHorarioVuelta = 0
            IdLocalidadDesdeVuelta = 0
            IdlocalidadHastaVuelta = 0
            viewDestVuelta.hidden = true
            viewDestVuelta2.hidden = true
            viewLugarDeAbordoVuelta.hidden = true
            viewSalidaVuelta.hidden = true
            viewPlataformaVuelta.hidden = true
            viewCantPasajesVuelta.hidden = true
            viewGreyBar.hidden = true
        }
    }
    
    @IBAction func reservar(sender: UIButton) {
        self.loadIcon.hidden = false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
   
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AgregarReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IDEmpresaIda i:type='d:int'>\(IDEmpresaIda)</IDEmpresaIda><IDDestinoIda i:type='d:int'>\(IDDestinoIda)</IDDestinoIda><CodHorarioIda i:type='d:int'>\(CodHorarioIda)</CodHorarioIda><IdLocalidadDesdeIda i:type='d:int'>\(IdLocalidadDesdeIda)</IdLocalidadDesdeIda><IdlocalidadHastaIda i:type='d:int'>\(IdlocalidadHastaIda)</IdlocalidadHastaIda><CantidadIda i:type='d:int'>\(CantidadIda)</CantidadIda><IDEmpresaVuelta i:type='d:int'>\(IDEmpresaVuelta)</IDEmpresaVuelta><IDDestinoVuelta i:type='d:int'>\(IDDestinoVuelta)</IDDestinoVuelta><CodHorarioVuelta i:type='d:int'>\(CodHorarioVuelta)</CodHorarioVuelta><IdLocalidadDesdeVuelta i:type='d:int'>\(IdLocalidadDesdeVuelta)</IdLocalidadDesdeVuelta><IdlocalidadHastaVuelta i:type='d:int'>\(IdlocalidadHastaVuelta)</IdlocalidadHastaVuelta><CantidadVuelta i:type='d:int'>\(0)</CantidadVuelta><EsCompra i:type='d:int'>\(EsCompra)</EsCompra></n0:AgregarReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
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
                if let rangeF = parser.rangeOfString("<return xsi:type=\"xsd:string\">") { // con esto hago un subrango
                    if let rangeT = parser.rangeOfString("</return>") {
                        var resultCode: String = parser[rangeF.endIndex..<rangeT.startIndex]
                        println(resultCode)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if resultCode != "0"{
                                let alert = UIAlertView(title: "Atencion!", message: "Error al realizar la reserva", delegate:nil, cancelButtonTitle: "Aceptar")
                                alert.show()
                            }
                            else{
                                let alert2 = UIAlertView(title: "Tu Reserva Ha Sido Exitosa!", message: "Te enviamos un mail con los detalles", delegate:nil, cancelButtonTitle: "Aceptar")
                                alert2.show()
                            }
                            self.loadIcon.hidden = true
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