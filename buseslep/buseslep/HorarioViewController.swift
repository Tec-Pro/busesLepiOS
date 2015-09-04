//
//  HorarioViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class HorarioIdaViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tablaHorario: UITableView!
    
    @IBOutlet weak var lblDesdeHasta: UILabel!
    
    @IBOutlet weak var lblPrecioIda: UILabel!
    @IBOutlet weak var lblPrecioIdaVuelta: UILabel!
    
    var horarios: [Horario]?
    var indexHorarioElegido: Int?
    var busquedaViewController: BusquedaViewController?
    var lblDesdeHastaTexto: String?
    var lblPrecioIdaTexto: String?
    var lblPrecioIdaVueltaTexto: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDesdeHasta.text = lblDesdeHastaTexto
        self.lblPrecioIda.text = "Ida $\(lblPrecioIdaTexto!) "
        self.lblPrecioIdaVuelta.text = "Ida vuelta  $\(lblPrecioIdaVueltaTexto!) "
        tablaHorario.delegate =  self
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
        if(horario.ServicioPrestado == "disponible"){
            cell?.lblHoraSale.textColor = UIColor.blueColor()
            cell?.lblEstado.textColor = UIColor.blueColor()
        }else{
            cell?.lblHoraSale.textColor = UIColor(red:249.0, green:0.0,blue:8.0,alpha:1.0)
            cell?.lblEstado.textColor = UIColor(red:249.0, green:0.0,blue:8.0,alpha:1.0)
        }
        return cell!
    }
    

    
      func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let horario = horarios![indexPath.row]
        busquedaViewController?.horarioIda(indexPath.row)
        navigationController?.popViewControllerAnimated(true)

        
}
    
}

class HorarioVueltaViewController: UIViewController ,UITableViewDelegate{
    
    @IBOutlet weak var tablaHorario: UITableView!
    
    @IBOutlet weak var lblDesdeHasta: UILabel!
    var lblPrecioIdaTexto: String?
    var lblPrecioIdaVueltaTexto: String?
    var lblDesdeHastaTexto: String?
    @IBOutlet weak var lblPrecioIda: UILabel!
    @IBOutlet weak var lblPrecioIdaVuelta: UILabel!

    var horarios: [Horario]?
    var indexHorarioElegido: Int?
    var busquedaViewController: BusquedaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDesdeHasta.text = lblDesdeHastaTexto
        self.lblPrecioIda.text = "Ida $\(lblPrecioIdaTexto)"
        self.lblPrecioIdaVuelta.text = "Ida $\(lblPrecioIdaVueltaTexto)"
        tablaHorario.delegate = self
        
   //     tablaHorario.reloadData()

    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (horarios == nil ) ? 0 : horarios!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaHorarioVuelta") as? CeldaHorarioViewController
        let horario = horarios![indexPath.row]
        cell?.lblFechaSale.text = horario.fecha_sale
        cell?.lblHoraSale.text = horario.hora_sale
        cell?.lblFechaLlega.text = horario.fecha_llega
        cell?.lblHoraLlega.text = horario.hora_llega
        cell?.lblEstado.text = horario.ServicioPrestado
        if(horario.ServicioPrestado == "disponible"){
            cell?.lblHoraSale.textColor = UIColor(red:0.0, green:0.0,blue:255.0,alpha:1.0)
            cell?.lblEstado.textColor = UIColor(red:0.0, green:0.0,blue:255.0,alpha:1.0)
        }else{
            cell?.lblHoraSale.textColor = UIColor(red:249.0, green:0.0,blue:8.0,alpha:1.0)
            cell?.lblEstado.textColor = UIColor(red:249.0, green:0.0,blue:8.0,alpha:1.0)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let horario = horarios![indexPath.row]
        busquedaViewController?.horarioVuelta(indexPath.row)
        navigationController?.popViewControllerAnimated(true)
        
        
    }
}
