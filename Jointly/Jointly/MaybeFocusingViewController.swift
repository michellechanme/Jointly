//
//  MaybeFocusingViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/28/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MaybeFocusViewController: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var targetUser: PFUser?
    
    override func viewDidLoad() {
        yesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        noButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    }
    
}
