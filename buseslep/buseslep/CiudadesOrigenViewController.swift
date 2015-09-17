//
//  CiudadesViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 29/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CiudadesOrigenViewController: UITableViewController {
    
    var ciudadesOrigen: [CiudadOrigen]?
    var indexCiudadElegida: Int?
    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        if (ciudadesOrigen?.count == 0 || ciudadesOrigen == nil){
            navigationController?.popViewControllerAnimated(true)
            var alert = UIAlertView( title: "Error!", message: "No se encontraron ciudades, intente nuevamente",delegate: nil,  cancelButtonTitle: "Entendido")
            alert.show()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ciudadesOrigen == nil ) ? 0 : ciudadesOrigen!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CiudadCell") as? UITableViewCell
        let ciudad = ciudadesOrigen![indexPath.row]
        
        cell?.textLabel?.text = ciudad.nombre!
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ciudad = ciudadesOrigen![indexPath.row]
        busquedaViewController?.ciudadOrigenElegida(indexPath.row)
        navigationController?.popViewControllerAnimated(true)
    }
    
    

}
