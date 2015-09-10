//
//  CeldaReservaIdaVueltaViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 10/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CeldaReservaIdaVueltaViewController: UITableViewCell{
    
    @IBOutlet weak var destinoIda: UILabel!
    @IBOutlet weak var salidaIda: UILabel!
    @IBOutlet weak var cantIda: UILabel!
    
    @IBOutlet weak var destinoVuelta: UILabel!
    @IBOutlet weak var salidaVuelta: UILabel!
    @IBOutlet weak var cantVuelta: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
