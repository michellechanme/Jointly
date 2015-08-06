//
//  UserInfoViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/30/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var namePrompt: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBAction func goPressed(sender: AnyObject) {
        
        // checking if we have current user. if so, save them!
        if let user = PFUser.currentUser() {
            user.setValue(nameTextField.text, forKey: "name")
            user.saveInBackground()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Onboarded")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        textValueChanged(nameTextField)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func textValueChanged(sender: AnyObject) {
        // checking if text field has a value
        if nameTextField.text.isEmpty {
            goButton.enabled = false
        } else {
            goButton.enabled = true
        }
    }
    
    
}