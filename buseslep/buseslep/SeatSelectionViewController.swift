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
    @IBOutlet weak var btnSiguiente: UIBarButtonItem!
    var resumenViewController : ResumenViewController?
    
    var cantPasajes: Int = 0;
    var cantSeatsSelected: Int = 0;
    var horario : Horario?
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?
    var esIda : Int = 0
    var idVenta : Int = 0
    var driverAdded : Bool = false
    
    @IBOutlet weak var lblSeatsSelection: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    let free_seat: UIImage = UIImage(named:"free_seat")!
    let occupied_seat: UIImage = UIImage(named:"occupied_seat")!
    let selected_seat: UIImage = UIImage(named:"selected_seat")!
    let none_seat: UIImage = UIImage(named:"none_seat")!
    let driver_seat: UIImage = UIImage(named:"driver_seat")!
    
   /* var seats: [Int] = [0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0]*/
    
    var seats = [UIImage](count: 60, repeatedValue: UIImage(named:"none_seat")!)
    var seatsNumbers = [Int](count:60, repeatedValue: 0)
    var seatsSelected = Set<Int>()
    var butacas: [Butaca]?
    override func viewDidLoad() {
        super.viewDidLoad()
        seatsView.delegate = self
        cantSeatsSelected = 0
        obtenerButacas()
        seatsView.layer.borderColor = UIColor.blackColor().CGColor
        seatsView.layer.borderWidth = 0.5
        if(esIda == 0){
            lblSeatsSelection.text = "Seleccione butacas para vuelta"
        }
        else{
            lblSeatsSelection.text = "Seleccione butacas para ida"
        }
        
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
    
    @IBAction func btnSiguientePressed(sender: UIBarButtonItem) {
        if(cantSeatsSelected < cantPasajes){
            var asientosRestantes = cantPasajes - cantSeatsSelected
            if(asientosRestantes > 1){
                let alert = UIAlertView(title: "Faltan Asientos por Seleccionar!", message: "Quedan " + asientosRestantes.description + " asientos por seleccionar", delegate:nil, cancelButtonTitle: "Aceptar")
                alert.show()
            }
            else{
                let alert2 = UIAlertView(title: "Faltan Asientos por Seleccionar!", message: "Queda " + asientosRestantes.description + " asiento por seleccionar", delegate:nil, cancelButtonTitle: "Aceptar")
                alert2.show()
            }
        }
        else{
            navigationController?.popViewControllerAnimated(true)
            resumenViewController?.guardarAsientos(self.seatsSelected, esIda: self.esIda)
        }

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
        if(self.seats[59] != self.none_seat && self.seats[58] == self.none_seat && self.seats[54] == self.none_seat && self.seats[53] == self.none_seat && self.seats[48] == self.none_seat){ //un temita
            self.seats[58] = self.seats[59];
            self.seatsNumbers[58] = self.seatsNumbers[59];
            self.seats[59] = self.none_seat;
            self.seats[55] = self.driver_seat;
            driverAdded = true;
        }
        
        for var i = 0; i<self.seats.count;i += 5{ //hago el espejo de la "matriz"
            var aux1 : UIImage = UIImage(named:"none_seat")!;
            var aux2 : Int = 0;
            var ind : Int = i;
            for( var j = i+4; j > i+2; j-- ){
                aux1 =  self.seats[j];
                aux2 = self.seatsNumbers[j];
                self.seats[j] = self.seats[ind];
                self.seatsNumbers[j] = self.seatsNumbers[ind];
                self.seats[ind] = aux1;
                self.seatsNumbers[ind] = aux2;
                ind++;
            }
        }
        var noneCount :Int = 0;
        while (self.seats[noneCount] == self.none_seat) { // cuenta la cantidad de lugares vacios de atras
            noneCount++;
        }
        noneCount = noneCount / 5;
        if (noneCount > 0){
            var i :Int = 0;
            for (i = 0; i < self.seats.count - noneCount * 5; i++) { //corre los asientos hacia atras, asi no queda nada en blanco
                self.seats[i] = self.seats[noneCount * 5 + i];
                self.seatsNumbers[i] = self.seatsNumbers[noneCount * 5 + i];
                self.seats[noneCount * 5 + i] = self.none_seat;
            }
            //Integer[][] auxArr = new Integer[i][2];
            var auxArr  = [UIImage](count:i, repeatedValue:  UIImage(named:"none_seat")!)
            var auxArrSnum = [Int](count: i, repeatedValue: 0)
            for(var j = 0; j < auxArr.count; j++){ //achico el arreglo para sacarle los lugares de adelante que quedaron vacios
                auxArr[j] = self.seats[j];
                auxArrSnum[j] = self.seatsNumbers[j];
            }
            self.seats = auxArr; //estaba el .clone() no se como funcionara aca
            self.seatsNumbers = auxArrSnum
        }
        var n :Bool = true;
        for(var i = self.seats.count - 1; i > self.seats.count - 6; i--){ //me fijo si la ultima fila es nula
            n = n && self.seats[i] == self.none_seat;
        }
        if(n){
            var auxArr  = [UIImage](count:self.seats.count - 5, repeatedValue:  UIImage(named:"none_seat")!)
            var auxArrSnum = [Int](count: self.seats.count - 5, repeatedValue: 0)
          //  Integer[][] auxArr = new Integer[seatsArr.length - 5][2]; //le saco la ultima fila
            for(var i = 0 ; i < self.seats.count - 5; i++){
                auxArr[i] = self.seats[i];
                auxArrSnum[i] = self.seatsNumbers[i];
                
            }
            self.seats = auxArr //.clone();
            self.seatsNumbers = auxArrSnum
        }
        var noneCol :Bool = true
        var noneColCount :Int = 0
        for(var i = 0; i < self.seats.count ; i += 5){ //se fija si la columna de la izq esta vacia
            noneCol = noneCol && self.seats[i] == self.none_seat;
            noneColCount++;
        }
        var numcols :Int = 5;
        if(noneCol){
            //Integer[][] auxArr = new Integer[self.seats.count - noneColCount][2]; //muevo los asientos para sacar la columna vacia
            var auxArr  = [UIImage](count:self.seats.count - noneColCount, repeatedValue:  UIImage(named:"none_seat")!)
            var auxArrSnum = [Int](count: self.seats.count - noneColCount, repeatedValue: 0)

            var colcount :Int = 5;
            var i2 :Int = 0;
            for(var i = 0; i < self.seats.count; i++){
                if(colcount == 5){
                    colcount = 1;
                }
                else {
                    auxArr[i2] = self.seats[i];
                    auxArrSnum[i2] = self.seatsNumbers[i];
                    i2++;
                    colcount++;
                }
            }
            self.seats = auxArr //.clone();
            self.seatsNumbers = auxArrSnum
           
            self.widthConstraint.constant = 250
            
           /* gridView.setNumColumns(4);
            ViewGroup.LayoutParams layoutParams = gridView.getLayoutParams();
            layoutParams.width = convertDpToPixels(200,mContext); //this is in pixels
            gridView.setLayoutParams(layoutParams);*/
            numcols = 4;
        }
        /* ---- aca va lo de achicar las columnas ----*/
        
        if(!driverAdded) {
            var z :Bool = true;
            for (var i = self.seats.count - 1; i > self.seats.count - numcols - 1; i--) { //me fijo si la ultima fila es nula
                z = z && self.seats[i] == self.none_seat;
            }
            if (!z) {
                //Integer[][] auxArr2 = new Integer[seatsArr.length + numcols][2]; //agrega una fila al ultimo
                var auxArr2  = [UIImage](count:self.seats.count + numcols, repeatedValue:  UIImage(named:"none_seat")!)
                var auxArrSnum = [Int](count: self.seats.count + numcols, repeatedValue: 0)

                for (var i = 0; i < self.seats.count; i++) {
                    auxArr2[i] = self.seats[i];
                    auxArrSnum[i] = self.seatsNumbers[i];
                }
                for (var i = self.seats.count; i < auxArr2.count - 1; i++) {
                    auxArr2[i] = self.none_seat;
                    auxArrSnum[i] = 0;
                }
                auxArr2[auxArr2.count - 1] = self.driver_seat; //agrego el conductor a la ultima fila
                auxArrSnum[auxArr2.count - 1] = 0;
                
                self.seats = auxArr2 //.clone();
                self.seatsNumbers = auxArrSnum
            } else {
                self.seats[self.seats.count - 1] = self.driver_seat;
                self.seatsNumbers[self.seatsNumbers.count - 1] = 0;
            }
        }
        
       // Integer[][] aux= seatsArr.clone();
        var aux  = self.seats
        var auxArrSnum = self.seatsNumbers
        var  iAux: Int = self.seats.count-1;
        for(var i = 0; i < self.seats.count; i++){
            aux[iAux] = self.seats[i];
            auxArrSnum[iAux] = self.seatsNumbers[i]
            iAux--
        }
        self.seats = aux //.clone();
        self.seatsNumbers = auxArrSnum
        
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
                    //println(resultCode)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if resultCode == "-1"{
                           // let alert = UIAlertView(title: "Atencion!", message: "Error al realizar la reserva", delegate:nil, cancelButtonTitle: "Aceptar")
                            //alert.show()
                        }
                        else{ //si esta todo ok
                            if(esSeleccion == 1){
                                self.cantSeatsSelected++
                                self.seats[posicion] = self.selected_seat
                                self.seatsSelected.insert(num)
                                println(num)
                            }
                            else{
                                self.cantSeatsSelected--
                                self.seats[posicion] = self.free_seat
                                self.seatsSelected.remove(num)
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
