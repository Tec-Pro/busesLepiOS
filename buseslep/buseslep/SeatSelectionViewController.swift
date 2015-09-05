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
    
    let free_seat: UIImage = UIImage(named:"free_seat")!
    let occupied_seat: UIImage = UIImage(named:"occupied_seat")!
    let selected_seat: UIImage = UIImage(named:"selected_seat")!
    let none_seat: UIImage = UIImage(named:"none_seat")!
    
   /* var seats: [Int] = [0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0,
                        0,0,0,0,0]*/
    
    var seats = [UIImage](count: 40, repeatedValue: UIImage(named:"free_seat")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seatsView.delegate = self
        seatsView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? CeldaAsiento
        cell?.imageView.image = seats[indexPath.row]
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if seats[indexPath.row] == free_seat{
            seats[indexPath.row] = selected_seat
        }
        else{
            if seats[indexPath.row] == selected_seat{
                seats[indexPath.row] = free_seat
            }
        }
        seatsView.reloadData()
    }
}
