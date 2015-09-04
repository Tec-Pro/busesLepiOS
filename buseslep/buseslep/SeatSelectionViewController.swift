//
//  SeatSelectionViewController.swift
//  buseslep
//
//  Created by Agustin on 9/4/15.
//  Copyright (c) 2015 Tec-Pro Software. All rights reserved.
//

import UIKit

class SeatSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var seatsView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seatsView.delegate = self
        seatsView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? CeldaAsiento
        cell?.imageView.image = UIImage(named:"free_seat")
        return cell!
    }
}
