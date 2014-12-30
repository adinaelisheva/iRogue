//
//  DescriptionViewController.swift
//  iRogue
//
//  Created by Adina Rubinoff on 12/30/14.
//  Copyright (c) 2014 Adinex Inc. All rights reserved.
//

import UIKit

class DescriptionViewController : UIViewController {
    @IBOutlet weak var DescLabel: UILabel!
    
    @IBAction func DoneClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}