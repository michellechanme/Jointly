//
//  HappyViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 8/7/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit

class HappyViewController: UIViewController {
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var happyImage: UIImageView!
    @IBOutlet weak var happyLabel: UILabel!
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toHomeButton.layer.cornerRadius = 5

    }
}