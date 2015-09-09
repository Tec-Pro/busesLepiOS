//
//  ListarReservasViewController.swift
//  buseslep
//
//  Created by Alan Gonzalez on 9/9/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class ListarReservasViewController: UITableViewController{
    
    var a:[String] = ["hola","chau","capo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("gola1")
        return a.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("c") as? UITableViewCell
        let reserva = a[indexPath.row]
        cell?.textLabel?.text = reserva
        println("gola2")
        return cell!
    }

}
