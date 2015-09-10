//
//  BackTableVC.swift
//  buseslep
//
//  Created by Agustin on 8/31/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        tableArray = ["Ultimas Busquedas", "Editar Perfil" , "Cambiar Contraseña", "Mis Reservas", "Mis Compras", "Cerrar Sesion"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell
        cell!.textLabel?.text = tableArray[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let opcion = tableArray[indexPath.row]
        println(opcion)
        if(opcion == "Ultimas Busquedas"){
            BusquedaViewController.cargarUltimasBusquedas = true
            //self.performSegueWithIdentifier(<#identifier: String?#>, sender: <#AnyObject?#>)
        }
        if opcion == "Mis Reservas"{
                BusquedaViewController.verReservas = true
        }
        if opcion == "Editar Perfil"{
            BusquedaViewController.editarPerfil = true
        }
        if opcion == "Cerrar Sesion"{
            let preferences = NSUserDefaults.standardUserDefaults()
            preferences.setValue(0, forKey: "login")
            preferences.synchronize()
        }
        if opcion == "Cambiar Contraseña"{
            BusquedaViewController.cambiarContraseña = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVc = segue.destinationViewController as? BusquedaViewController
        
        
    }
}