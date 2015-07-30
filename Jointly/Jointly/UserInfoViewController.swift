//
//  UserInfoViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/30/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController {
    @IBOutlet weak var namePrompt: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    
    @IBAction func goPressed(sender: AnyObject) {
//        self.performSegueWithIdentifier("showMoments", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Onboarded")
        
        // MARK: User Interface
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        // corner radius of goButton
        goButton.layer.cornerRadius = 4
        
        nameTextField.becomeFirstResponder()
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
    }
}