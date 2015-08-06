//
//  PunishmentViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 8/3/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit

class PunishmentViewController: UIViewController {
    @IBOutlet weak var punishmentLabel: UILabel!
    @IBOutlet weak var punishmentButton: UIButton!
    var punishment : String?
    @IBAction func acceptPenalty(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punishmentButton.layer.cornerRadius = 5
        punishmentLabel.text = punishment
    }
}
