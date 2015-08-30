//
//  CeldaHorarioViewController.swift
//  buseslep
//
//  Created by Nicolas Pereyra Orcasitas on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CeldaHorarioViewController: UITableViewCell {
    
    
    @IBOutlet weak var lblFechaSale: UILabel!

    @IBOutlet weak var lblFechaLlega: UILabel!
   
    @IBOutlet weak var lblHoraSale: UILabel!

    
    @IBOutlet weak var lblHoraLlega: UILabel!
 

    @IBOutlet weak var lblEstado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
