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
    
    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var focusImage: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var name: String?
    var targetUser: PFUser?
    var toPass: String!

    
    override func viewDidLoad() {
        let name = self.name ?? " a friend"
        focusLabel.text = "Would you like to focus on \(name)?"
    }
}