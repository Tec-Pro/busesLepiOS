//
//  FinalizarCompraViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit


class FinalizarCompraViewController: UIViewController {
    
    @IBOutlet var lblCodImpresion: UILabel!
    @IBOutlet weak var viewGrande: UIView!
    var CodImpresion : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGrande.layer.borderColor = UIColor.blackColor().CGColor
        viewGrande.layer.borderWidth = 0.5
        self.lblCodImpresion.text = self.CodImpresion
    }
    @IBAction func clickFinalizar(sender: UIButton) {
                self.navigationController?.popViewControllerAnimated(true)
    }
}
