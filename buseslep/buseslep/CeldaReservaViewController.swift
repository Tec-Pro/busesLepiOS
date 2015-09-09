//
//  CeldaReservaViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CeldaReservaViewController: UITableViewCell {
    
    @IBOutlet weak var sentido: UILabel!
    @IBOutlet weak var destino: UILabel!
    @IBOutlet weak var salida: UILabel!
    @IBOutlet weak var cant: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
