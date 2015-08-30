//
//  HorarioViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class HorarioViewController: UIViewController ,UITableViewDataSource{
    
    @IBOutlet weak var tablaHorario: UITableView!
    
    
    var horarios: [Horario]?
    var indexHorarioElegido: Int?
    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaHorario.reloadData()
    }
    
    

    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (horarios == nil ) ? 0 : horarios!.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaHorarioIda") as? CeldaHorarioViewController
        let horario = horarios![indexPath.row]
        cell?.lblFechaSale.text = horario.fecha_sale
        cell?.lblHoraSale.text = horario.hora_sale
        cell?.lblFechaLlega.text = horario.fecha_llega
        cell?.lblHoraLlega.text = horario.hora_llega

        cell?.lblEstado.text = horario.ServicioPrestado
        
        return cell!
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let horario = horarios![indexPath.row]
        busquedaViewController?.horarioIda(indexPath.row)
        navigationController?.popViewControllerAnimated(true)

        
}
}
