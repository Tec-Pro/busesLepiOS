//
//  UltimasBusquedasViewController.swift
//  buseslep
//
//  Created by Agustin on 9/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class UltimasBusquedasViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var tablaUB: UITableView!
    var db : Sqlite = Sqlite()
    var searches : [BusquedasModel]?
    
    var dateGoArr : [String]?
    var dateReturnArr : [String]?
    var idCityOrigin : Int?
    var idCityDestiny : Int?
    var cityOriginText : String = ""
    var cityDestinText : String = ""
    var isRoundTrip : Bool = false
    var cantPasajes : Int?
    
    //var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.deleteOldSearches()
        searches = db.getSearches()
        //tablaUB.reloadData()
        
    }
    
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searches != nil){
            return searches!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaUltimaBusqueda") as? CeldaUltimaBusqueda
        cell?.ciudades.text = searches![indexPath.row].city_origin! + " - " + searches![indexPath.row].city_destiny!
        var dateGArr = split(searches![indexPath.row].date_go!) {$0 == "-"}
        cell?.fechaIda.text = dateGArr[2] + "/" + dateGArr[1] + "/" + dateGArr[0]
        if(searches![indexPath.row].is_roundtrip!){
            var dateRArr = split(searches![indexPath.row].date_return!) {$0 == "-"}
            cell?.fechaVuelta.text = dateRArr[2] + "/" + dateRArr[1] + "/" + dateRArr[0]
        }
        else{
            cell?.fechaVuelta.text = ""
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dateGoArr = split(searches![indexPath.row].date_go!) {$0 == "-"}
        self.idCityOrigin = searches![indexPath.row].code_city_origin!
        self.idCityDestiny = searches![indexPath.row].code_city_destiny!
        self.isRoundTrip = searches![indexPath.row].is_roundtrip!
        self.cantPasajes = searches![indexPath.row].number_tickets!
        self.cityOriginText = searches![indexPath.row].city_origin!
        self.cityDestinText = searches![indexPath.row].city_destiny!
        if(searches![indexPath.row].is_roundtrip!){
            self.dateReturnArr = split(searches![indexPath.row].date_return!) {$0 == "-"}

        }
        self.performSegueWithIdentifier("goToBusquedas", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let busquedaViewController = segue.destinationViewController as! BusquedaViewController
        busquedaViewController.diaIda = self.dateGoArr![2].toInt()!
        busquedaViewController.mesIda = self.dateGoArr![1].toInt()!
        busquedaViewController.anioIda = self.dateGoArr![0].toInt()!
        busquedaViewController.idCityOrigen = self.idCityOrigin
        busquedaViewController.idCityDestiny = self.idCityDestiny
        busquedaViewController.cantidadPasajes = self.cantPasajes!
        busquedaViewController.cityOrigenText = self.cityOriginText
        busquedaViewController.cityDestinyText = self.cityDestinText
        busquedaViewController.isRoundTrip = false
      //  busquedaViewController.chkIdaVuelta.setOn(false, animated: false)
        if(self.isRoundTrip){
            //busquedaViewController.chkIdaVuelta.setOn(true, animated: false)
             busquedaViewController.isRoundTrip = true
            busquedaViewController.diaVuelta = self.dateReturnArr![2].toInt()!
            busquedaViewController.mesVuelta = self.dateReturnArr![1].toInt()!
            busquedaViewController.anioVuelta = self.dateReturnArr![0].toInt()!
            
        }
        busquedaViewController.fromUltimasBusquedas = true;
    }
    
    @IBAction func btnDeletePressed(sender: UIBarButtonItem) {
        db.delete()
        searches = db.getSearches()
        tablaUB.reloadData()
    }
}