//
//  CiudadesViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CiudadesDestinoViewController: UITableViewController {
    
    var ciudadesDestino: [CiudadDestino]?
    var indexCiudadElegida: Int?
    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        if (ciudadesDestino?.count == 0 || ciudadesDestino == nil){
            navigationController?.popViewControllerAnimated(true)
            var alert = UIAlertView( title: "Error!", message: "Seleccione una ciudad de origen",delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ciudadesDestino == nil ) ? 0 : ciudadesDestino!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CiudadCell") as? UITableViewCell
        let ciudad = ciudadesDestino![indexPath.row]
        
        cell?.textLabel?.text = ciudad.hasta!
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ciudad = ciudadesDestino![indexPath.row]
        //println(ciudad.hasta!)
        busquedaViewController?.ciudadDestinoElegida(indexPath.row)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
