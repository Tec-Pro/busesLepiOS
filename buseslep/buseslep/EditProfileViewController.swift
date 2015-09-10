//
//  EditProfileViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController{
    
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGuardar.layer.borderColor = UIColor.blackColor().CGColor
        btnGuardar.layer.borderWidth = 0.5
    }
}
