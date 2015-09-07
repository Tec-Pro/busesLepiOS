//
//  SeatSelectionViewController.swift
//  buseslep
//
//  Created by Agustin on 9/4/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class SeatSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var seatsView: UICollectionView!
    
    var cantPasajes: Int = 0;
    var cantSeatsSelected: Int = 0;
    var horario : Horario?
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?
    var esIda : Int = 0
    var idVenta : Int = 0
    
    let free_seat: UIImage = UIImage(named:"free_seat")!
    let occupied_seat: UIImage = UIImage(named:"occupied_seat")!
    let selected_seat: UIImage = UIImage(named:"selected_seat")!
    let none_seat: UIImage = UIImage(named:"none_seat")!
    
   /* var seats: [Int] = [0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0]*/
    
    var seats = [UIImage](count: 60, repeatedValue: UIImage(named:"none_seat")!)
    var seatsNumbers = [Int](count:60, repeatedValue: 0)
    var butacas: [Butaca]?
    override func viewDidLoad() {
        super.viewDidLoad()
        seatsView.delegate = self
        obtenerButacas()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? CeldaAsiento
        cell?.imageView.image = seats[indexPath.row]
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if seats[indexPath.row] == free_seat{
            if cantSeatsSelected < cantPasajes{
                self.seleccionarButaca(self.seatsNumbers[indexPath.row], esSeleccion: 1, posicion: indexPath.row)
            }
        }
        else{
            if seats[indexPath.row] == selected_seat{
                self.seleccionarButaca(self.seatsNumbers[indexPath.row], esSeleccion: 0, posicion: indexPath.row)
            }
        }
        seatsView.reloadData()
    }
    
    func cargarButacas(){
        if(self.butacas == nil){
            return
        }
        for i in 0...self.butacas!.count-1 {
            
            var col: Int = self.butacas![i].columna!
            var row: Int = self.butacas![i].fila!
            var ocu: Int = self.butacas![i].ocupado!
            var num: Int = self.butacas![i].numButaca!
            var index: Int = 5 * (col - 1) + (row - 1);
            if(index > 59){
                index = 59;
            }
            if (ocu == 0){
                self.seats[index] = self.free_seat
            }
            else{
                self.seats[index] = self.occupied_seat
            }
            
            seatsNumbers[index] = num;
        }
        self.seatsView.reloadData()
    }
    
    func obtenerButacas(){
        //self.loadImage.hidden =  false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:EstadoButacasPlantaHorario id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><id_plataforma i:type='d:int'>\(id_plataforma)</id_plataforma><IdEmpresa i:type='d:int'>\(horario!.Id_Empresa!)</IdEmpresa><IdDestino i:type='d:int'>\(horario!.id_destino!)</IdDestino><CodHorario i:type='d:int'>\(horario!.cod_horario!)</CodHorario><IdLocalidadDesde i:type='d:int'>\(ciudadDestino!.id_localidad_origen!)</IdLocalidadDesde><IdLocalidadHasta i:type='d:int'>\(ciudadDestino!.id_localidad_destino!)</IdLocalidadHasta></n0:EstadoButacasPlantaHorario></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#EstadoButacasPlantaHorario", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeFrom = parser.rangeOfString("{\"Data\":[") { // con esto hago un subrango
                if let rangeTo = parser.rangeOfString(",\"Cols") {
                    var datos: String = parser[rangeFrom.startIndex..<rangeTo.startIndex]
                    datos.extend("}") // le agrego el corchete al ultimo para que quede {"Data":[movidas de data ]}
                   // println(datos)
                    var data: NSData = datos.dataUsingEncoding(NSUTF8StringEncoding)! //parseo a data para serializarlo
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros , error: nil) as! NSDictionary //serializo como un diccionario (map en java)
                    
                    // Move to the UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.butacas = Butaca.fromDictionary(json) // parseo  y obtengo un arreglo de Ciudades
                      //  println(self.butacas?.count)
                        self.cargarButacas()
                       // self.loadImage.hidden = true
                    })
                }
            }
            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.butacas =  nil
                    //self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }

   /* request.addProperty("userWS","UsuarioLep"); //paso los parametros que pide el metodo
    request.addProperty("passWS","Lep1234");
    request.addProperty("NroButaca",NroButaca);
    request.addProperty("IDVenta",IDVenta);
    request.addProperty("EsIda", EsIda);
    request.addProperty("EsSeleccion",EsSeleccion);
    request.addProperty("id_Plataforma",1);*/
    
    
    func seleccionarButaca(num : Int, esSeleccion: Int, posicion: Int){
        //self.loadImage.hidden =  false
        var userWS: String = "UsuarioLep" //paramatros
        var passWS: String = "Lep1234"
        var id_plataforma: Int = 2
        var soapMessage = "<v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://www.w3.org/2003/05/soap-encoding' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><n0:SeleccionarButaca id='o0' c:root='1' xmlns:n0='urn:LepWebServiceIntf-ILepWebService'><userWS i:type='d:string'>\(userWS)</userWS><passWS i:type='d:string'>\(passWS)</passWS><id_Plataforma i:type='d:int'>\(id_plataforma)</id_Plataforma><NroButaca i:type='d:int'>\(num)</NroButaca><IDVenta i:type='d:int'>\(self.idVenta)</IDVenta><EsIda i:type='d:int'>\(self.esIda)</EsIda><EsSeleccion i:type='d:int'>\(esSeleccion)</EsSeleccion></n0:SeleccionarButaca></v:Body></v:Envelope>" //request para el ws, esto es recomendable copiarlo de Android Studio, sino saber que meter bien, los parametros los paso con \(nombre_vairable)
        var is_URL: String = "https://webservices.buseslep.com.ar/WebServices/WebServiceLep.dll/soap/ILepWebService" //url del ws
        var lobj_Request = NSMutableURLRequest(URL: NSURL(string: is_URL)!)
        var session = NSURLSession.sharedSession()
        var err: NSError?
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue("urn:LepWebServiceIntf-ILepWebService#SeleccionarButaca", forHTTPHeaderField: "SOAPAction") //aca cambio LocalidadesDesde por el nombre del ws que llamo
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            var strData : NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            var parser : String = strData as String
            if let rangeF = parser.rangeOfString("<return xsi:type=\"xsd:string\">") { // con esto hago un subrango
                if let rangeT = parser.rangeOfString("</return>") {
                    var resultCode: String = parser[rangeF.endIndex..<rangeT.startIndex]
                    println(resultCode)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if resultCode == "-1"{
                           // let alert = UIAlertView(title: "Atencion!", message: "Error al realizar la reserva", delegate:nil, cancelButtonTitle: "Aceptar")
                            //alert.show()
                        }
                        else{ //si esta todo ok
                            if(esSeleccion == 1){
                                self.cantSeatsSelected++
                                self.seats[posicion] = self.selected_seat
                            }
                            else{
                                self.cantSeatsSelected--
                                self.seats[posicion] = self.free_seat
                            }
                            self.seatsView.reloadData()
                        }
                        //self.loadIcon.hidden = true
                    })
                }
            }


            if error != nil{
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var alert = UIAlertView( title: "Error!", message: "Ud. no posee conexión a internet; acceda a través de una red wi-fi o de su prestadora telefónica",delegate: nil,  cancelButtonTitle: "Entendido")
                    alert.show()
                    self.butacas =  nil
                    //self.loadImage.hidden = true
                })
            }
        })
        task.resume()
    }
    
    
    
}
