//
//  RegisterViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 30/8/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController{
    
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtRepetirPass: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegistrar.layer.borderColor = UIColor.blackColor().CGColor
        btnRegistrar.layer.borderWidth = 0.5
    }
}
