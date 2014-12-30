//
//  ItemViewController.swift
//  iRogue
//
//  Created by Adina Rubinoff on 12/29/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import UIKit

class ItemViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var items : [Item] = []
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell", forIndexPath: indexPath) as ItemViewCell
        
        let item = items[indexPath.row]
        
        cell.ItemLabel.text = "\(item.adjective) \(item.name)"
        switch(item.type){
        case .Food:
            cell.ItemLabel.textColor = UIColor.brownColor()
            break
        case .Potion:
            cell.ItemLabel.textColor = UIColor.purpleColor()
            break
        case .Weapon:
            cell.ItemLabel.textColor = UIColor.grayColor()
            break
        case .Scroll:
            cell.ItemLabel.textColor = UIColor.whiteColor()
            break
        case .Clothing:
            cell.ItemLabel.textColor = UIColor.redColor()
            break
        case .Ring:
            cell.ItemLabel.textColor = UIColor.yellowColor()
            break
        case .Amulet:
            cell.ItemLabel.textColor = UIColor.yellowColor()
            break
        default:
            break
        }
        
        return cell
    }
    
    @IBOutlet weak var ItemCollection: UICollectionView!
    @IBOutlet weak var InteractButton: UIButton!
    @IBOutlet weak var DropButton: UIButton!
    @IBOutlet weak var DetailsButton: UIButton!
    @IBOutlet weak var DoneButton: UIButton!

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        InteractButton.setTitle(items[indexPath.row].useString, forState: .Normal)
        InteractButton.enabled = true
    }
    
    @IBAction func InteractClicked(sender: AnyObject) {
        if let ind = ItemCollection.indexPathsForSelectedItems().first as? NSIndexPath {
            let item = items[ind.row]
            Game.sharedInstance.takeTurnWithAction(UseAction(interactWith: item))
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func DropClicked(sender: AnyObject) {
    }
    @IBAction func DetailsClicked(sender: AnyObject) {
    }
    @IBAction func DoneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class ItemViewCell : UICollectionViewCell {
    
    @IBOutlet weak var ItemLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        var background = UIView()
        background.layer.borderColor = UIColor.whiteColor().CGColor
        background.layer.borderWidth = 1
        selectedBackgroundView = background
    }
    
}

















