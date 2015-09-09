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
    
    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.deleteOldSearches()
        searches = db.getSearches()
        tablaUB.reloadData()
        
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
        var dateGoArr = split(searches![indexPath.row].date_go!) {$0 == "-"}
        cell?.fechaIda.text = dateGoArr[2] + "/" + dateGoArr[1] + "/" + dateGoArr[0]
        if(searches![indexPath.row].is_roundtrip!){
            var dateRetArr = split(searches![indexPath.row].date_return!) {$0 == "-"}
            cell?.fechaVuelta.text = dateRetArr[2] + "/" + dateRetArr[1] + "/" + dateRetArr[0]
        }
        else{
            cell?.fechaVuelta.text = ""
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func btnDeletePressed(sender: UIBarButtonItem) {
        db.delete()
        searches = db.getSearches()
        tablaUB.reloadData()
    }
}