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
        println(ciudad.nombre!)
        busquedaViewController?.ciudadOrigenElegida(indexPath.row)
        navigationController?.popViewControllerAnimated(true)
    }
    
    

}
