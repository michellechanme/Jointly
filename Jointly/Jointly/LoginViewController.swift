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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let digits = Digits.sharedInstance()
        digits.logOut()
        digits.authenticateWithCompletion { (session, error) in
            println("\(session)")
            
        }
        
        let digitsAppearance = DGTAppearance()
        
        digitsAppearance.backgroundColor = UIColor.darkGrayColor()
        digitsAppearance.accentColor = UIColor.greenColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
