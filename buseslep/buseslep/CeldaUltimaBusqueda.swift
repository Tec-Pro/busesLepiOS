//
//  CeldaUltimaBusqueda.swift
//  buseslep
//
//  Created by Agustin on 9/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class CeldaUltimaBusqueda: UITableViewCell {
    
    @IBOutlet weak var ciudades: UILabel!
    @IBOutlet weak var fechaIda: UILabel!
    @IBOutlet weak var fechaVuelta: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

