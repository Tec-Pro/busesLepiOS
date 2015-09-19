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
        let preferences = NSUserDefaults.standardUserDefaults()
        if (preferences.integerForKey("login") == 1){
            tableArray = ["Ultimas Busquedas", "Editar Perfil" , "Cambiar Contraseña", "Mis Reservas", "Mis Compras", "Cerrar Sesion"]
        }else{
            tableArray = ["Ultimas Busquedas"]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let preferences = NSUserDefaults.standardUserDefaults()

        if (preferences.integerForKey("login") == 1){
            tableArray = ["Ultimas Busquedas", "Editar Perfil" , "Cambiar Contraseña", "Mis Reservas", "Mis Compras", "Cerrar Sesion"]
        }else{
            tableArray = ["Ultimas Busquedas"]
        }
        tableView.reloadData()
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
        if opcion == "Mis Compras"{
            BusquedaViewController.verCompras = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVc = segue.destinationViewController as? BusquedaViewController
        
        
    }
}