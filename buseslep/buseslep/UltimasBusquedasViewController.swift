//
//  UltimasBusquedasViewController.swift
//  buseslep
//
//  Created by Agustin on 9/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class UltimasBusquedasViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tablaUB: UITableView!
    

    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("wwwwwwwwwwwwwwwwwwwwww")
        tablaUB.reloadData()
    }
    
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaUltimaBusqueda") as? CeldaUltimaBusqueda
      //  cell?.ciudades.text = "Rio Cuarto - Ciudad de los Niños"
       // cell?.fechaIda.text = "20/08/2015"
        //cell?.fechaVuelta.text = "13/11/2015"
        println("asdasdasd2")
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let ciudad = ciudadesOrigen![indexPath.row]
        //busquedaViewController?.ciudadOrigenElegida(indexPath.row)
        //navigationController?.popViewControllerAnimated(true)
    }
}