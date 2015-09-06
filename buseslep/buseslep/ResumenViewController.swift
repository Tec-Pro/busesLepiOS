//
//  ResumenViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 5/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ResumenViewController: UIViewController {
    
    
    @IBOutlet weak var lblCiudadesIda: UILabel!
    
    @IBOutlet weak var lblCiudadesIdaVuelta: UILabel!
    @IBOutlet weak var lblFechaSaleIda: UILabel!
    @IBOutlet weak var lblFechaLlegaIda: UILabel!
    @IBOutlet weak var lblHoraSaleIda: UILabel!
    @IBOutlet weak var lblHoraLlegaIda: UILabel!
    @IBOutlet weak var lblFechaSaleVuelta: UILabel!
    @IBOutlet weak var lblFechaLlegaVuelta: UILabel!
    @IBOutlet weak var lblHoraSaleVuelta: UILabel!
    @IBOutlet weak var lblHoraLlegaVuelta: UILabel!
    @IBOutlet weak var lblImporte: UILabel!
    @IBOutlet weak var btnComprar: UIButton!
    @IBOutlet weak var btnReservar: UIButton!
    
    @IBOutlet weak var viewVuelta: UIView!
    @IBOutlet weak var viewIda: UIView!
    @IBOutlet weak var lblSeparadorIda: UILabel!
    @IBOutlet weak var lblSeparadorVuelta: UILabel!
    @IBOutlet weak var lblCantidadPasajes: UILabel!
    @IBOutlet weak var lblDescripcionCantidadPasajes: UILabel!
    
    var horarioIda : Horario?
    var horarioVuelta : Horario?
    
    var ciudadOrigen :  CiudadOrigen?
    var ciudadDestino : CiudadDestino?
    
    var precioIda : String?
    var precioIdaVuelta: String?
    
    var esIdaVuelta : Bool?
    
    var cantidadPasajes : Int?
    var precioIdaFloat : CGFloat?
    var precioIdaVueltaFloat : CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precioIdaFloat = CGFloat((self.precioIda! as NSString).floatValue)
        precioIdaVueltaFloat = CGFloat((self.precioIdaVuelta! as NSString).floatValue)

        btnComprar.layer.borderColor = UIColor.blackColor().CGColor
        btnComprar.layer.borderWidth = 0.5
        btnReservar.layer.borderColor = UIColor.blackColor().CGColor
        btnReservar.layer.borderWidth = 0.5
        viewIda.layer.borderColor = UIColor.blackColor().CGColor
        viewIda.layer.borderWidth = 0.5
        viewVuelta.layer.borderColor = UIColor.blackColor().CGColor
        viewVuelta.layer.borderWidth = 0.5
        lblCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblCantidadPasajes.layer.borderWidth = 0.5
        lblDescripcionCantidadPasajes.layer.borderColor = UIColor.blackColor().CGColor
        lblDescripcionCantidadPasajes.layer.borderWidth = 0.5
        lblCiudadesIda.text = "\(ciudadDestino!.desde!)-\(ciudadDestino!.hasta!)"
        lblFechaSaleIda.text = horarioIda?.fecha_sale
        lblHoraSaleIda.text = horarioIda?.hora_sale
        lblFechaLlegaIda.text = horarioIda?.fecha_llega
        lblHoraLlegaIda.text = horarioIda?.hora_llega
        lblCantidadPasajes.text = "\(cantidadPasajes!)"
        if esIdaVuelta! {
            lblCiudadesIdaVuelta.text = "\(ciudadDestino!.hasta!)-\(ciudadDestino!.desde!)"
            lblFechaSaleVuelta.text = horarioVuelta?.fecha_sale
            lblHoraSaleVuelta.text = horarioVuelta?.hora_sale
            lblFechaLlegaVuelta.text = horarioVuelta?.fecha_llega
            lblHoraLlegaVuelta.text = horarioVuelta?.hora_llega
            var precioTotal = CGFloat(cantidadPasajes!) *   CGFloat(cantidadPasajes!)
            lblImporte.text = "\(precioIdaVueltaFloat! * CGFloat(cantidadPasajes!))0"
        }else{
            lblCiudadesIdaVuelta.text = "  "
            lblFechaSaleVuelta.hidden = true
            lblHoraSaleVuelta.hidden = true
            lblFechaLlegaVuelta.hidden = true
            lblHoraLlegaVuelta.hidden = true
            lblSeparadorVuelta.hidden = true
            lblImporte.text = "$\(precioIdaFloat! * CGFloat(cantidadPasajes!))0"
            

        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Reservar"){
            let reserveDetailsViewController = segue.destinationViewController as! ReserveDetailsViewController
            reserveDetailsViewController.EsCompra = 0;
            reserveDetailsViewController.EsIdaVuelta = self.esIdaVuelta!
            reserveDetailsViewController.CantidadIda = self.cantidadPasajes!
            reserveDetailsViewController.horarioIda = self.horarioIda!
            if self.esIdaVuelta! {
                reserveDetailsViewController.horarioVuelta = self.horarioVuelta!
            }
            reserveDetailsViewController.ciudadOrigen = self.ciudadOrigen!
            reserveDetailsViewController.ciudadDestino = self.ciudadDestino!
        }
    }
    
    @IBAction func clickComprar(sender: UIButton) {
        
    }
    
    @IBAction func clickReservar(sender: UIButton) {
         self.performSegueWithIdentifier("Reservar", sender: self);
    }
}
