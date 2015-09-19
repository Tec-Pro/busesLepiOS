//
//  ReserveDetailsViewController.swift
//  buseslep
//
//  Created by Agustin on 9/3/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class ReserveDetailsViewController: UIViewController{
    
    @IBOutlet weak var btnConfirm: UIBarButtonItem!
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
    
    @IBOutlet weak var boxHeight: NSLayoutConstraint!
    var dni: String = ""
    var mail: String = ""
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
    var totalPrice: Double = 0
    var butacasIda: Set<Int>?
    var butacasVuelta: Set<Int>?
    var idVenta: Int = -1
    
    var CodImpresion: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = NSUserDefaults.standardUserDefaults()
        dni = preferences.objectForKey("dni")!.description
        mail = preferences.objectForKey("email")!.description
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
            btnConfirm.enabled = false
            btnConfirm.title = ""
            btnReserve.setTitle("Reservar", forState: UIControlState.Normal)
        }
        else{
            btnConfirm.enabled = true
            btnConfirm.title = "Confirmar"

            btnReserve.hidden = true
            viewTotal.hidden = false
            lblButacaIdaText.text = "Butaca"
            lblButacaVueltaText.text = "Butaca"
            btnReserve.setTitle("Confirmar", forState: UIControlState.Normal)
            lblCantButacaIda.text = butacasIda!.description
            lblTotal.text = "$\(round(totalPrice).description)0"
            if(butacasVuelta != nil){
                lblCantButacaVuelta.text  = butacasVuelta!.description
            }
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
            boxHeight.constant = 105
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier
        if identifier == "finalizarCompra"{ //largo el segue para elegir la ciudad de origen
            let finalizarCompra = segue.destinationViewController as! FinalizarCompraViewController
            finalizarCompra.CodImpresion = self.CodImpresion!

        }
    }

    
    @IBAction func confirmarCompra(sender: UIBarButtonItem) {
        println("Cargar cosas de mercadopago")
        self.showViewController(ExamplesUtils.startAdvancedVaultActivity(ExamplesUtils.MERCHANT_PUBLIC_KEY, amount: totalPrice, supportedPaymentTypes: ["credit_card", "debit_card", "prepaid_card"], callback: {(paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int) -> Void in
            self.createPayment(token, paymentMethod: paymentMethod, installments: installments, idSell: self.idVenta,transactionAmount: self.totalPrice, discount: nil)
        }), sender: self)
    }
    
    func createPayment(token: String?, paymentMethod: PaymentMethod, installments: Int,idSell: Int ,transactionAmount: Double, discount: Discount?) {
        if token != nil {
            ExamplesUtils.createPayment(token!, installments: installments, idSell: idSell,transactionAmount: transactionAmount, paymentMethod: paymentMethod, callback: { (payment: Payment,  codImpresion: String) -> Void in
                self.showViewController(MercadoPago.startCongratsViewController(payment, paymentMethod: paymentMethod), sender: self)
                var messageError : String = "ERROR"
                var exito: Bool = false;
                self.CodImpresion = codImpresion
                //payment.statusDetail = "accredited"
                switch (payment.statusDetail){
                case "accredited": //Pago aprobado
                    exito = true;
                    self.performSegueWithIdentifier("finalizarCompra", sender: self);
                case "pending_contingency": //Pago pendiente
                    messageError = "ERROR: Pago pendiente";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                case "cc_rejected_call_for_authorize": //Pago rechazado, llamar para autorizar.
                    messageError = "ERROR: Pago rechazado, llamar para autorizar.";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                case "cc_rejected_insufficient_amount": //Pago rechazado, saldo insuficiente.
                    messageError = "ERROR: Pago rechazado, saldo insuficiente.";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                case "cc_rejected_bad_filled_security_code": //Pago rechazado por código de seguridad.
                    messageError = "ERROR: Pago rechazado por código de seguridad.";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                case "cc_rejected_bad_filled_date": //Pago rechazado por fecha de expiración.
                    messageError = "ERROR: Pago rechazado por fecha de expiración.";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                case "cc_rejected_bad_filled_other": //Pago rechazado por error en el formulario
                    messageError = "ERROR: Pago rechazado por error en el formulario";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                default: //Pago rechazado
                    messageError = "ERROR";
                    var alert = UIAlertView( title: "Error!", message: messageError,delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                }
            })
        } else {
            println("no tengo token")
        }
    }
    
    @IBAction func reservar(sender: UIButton) {
        self.loadIcon.hidden = false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
   
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:AgregarReserva id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><DNI i:type='d:string'>\(dni)</DNI><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IDEmpresaIda i:type='d:int'>\(IDEmpresaIda)</IDEmpresaIda><IDDestinoIda i:type='d:int'>\(IDDestinoIda)</IDDestinoIda><CodHorarioIda i:type='d:int'>\(CodHorarioIda)</CodHorarioIda><IdLocalidadDesdeIda i:type='d:int'>\(IdLocalidadDesdeIda)</IdLocalidadDesdeIda><IdlocalidadHastaIda i:type='d:int'>\(IdlocalidadHastaIda)</IdlocalidadHastaIda><CantidadIda i:type='d:int'>\(CantidadIda)</CantidadIda><IDEmpresaVuelta i:type='d:int'>\(IDEmpresaVuelta)</IDEmpresaVuelta><IDDestinoVuelta i:type='d:int'>\(IDDestinoVuelta)</IDDestinoVuelta><CodHorarioVuelta i:type='d:int'>\(CodHorarioVuelta)</CodHorarioVuelta><IdLocalidadDesdeVuelta i:type='d:int'>\(IdLocalidadDesdeVuelta)</IdLocalidadDesdeVuelta><IdlocalidadHastaVuelta i:type='d:int'>\(IdlocalidadHastaVuelta)</IdlocalidadHastaVuelta><CantidadVuelta i:type='d:int'>\(self.CantidadVuelta)</CantidadVuelta><EsCompra i:type='d:int'>\(0)</EsCompra></n0:AgregarReserva></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
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
                                let alert2 = UIAlertView(title: "Tu Reserva Ha Sido Exitosa!", message: "Le enviamos un email a \n " + self.mail + "\n con los detalles de la reserva. \n \n Puede comprar el pasaje en el menu \"mis reservas\" o ir a la boleteria para abonar y obtener su boleto.", delegate:nil, cancelButtonTitle: "FINALIZAR")
                                alert2.show()
                                self.performSegueWithIdentifier("BackToMain", sender: self);
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