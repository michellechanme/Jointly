//
//  LoginViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/9/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import UIKit
import DigitsKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let digits = Digits.sharedInstance()
        digits.logOut()
        
        PFUser.loginWithDigitsInBackground {(user: PFUser!, error: NSError!) -> () in
            if (error == nil) {
                
                let installation = PFInstallation.currentInstallation()
                
                if let user = PFUser.currentUser() {
                    installation["user"] = user
                }
                
                installation.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print(error)
                    }
                    print("Installation Success: \(success)")
                })
                
                self.performSegueWithIdentifier("namePrompt", sender: self)
            } else {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
