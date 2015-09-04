//
//  PasajesTableViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 4/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class PasajesTableViewController: UITableViewController{
    
    var busquedaViewController: BusquedaViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        busquedaViewController?.cantidadPasajesElegidos(indexPath.row+1)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
