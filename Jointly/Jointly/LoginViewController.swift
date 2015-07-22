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
        let digitsAppearance = DGTAppearance()
        
        func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        digitsAppearance.backgroundColor = UIColor.whiteColor()
        digitsAppearance.accentColor = UIColorFromRGB(0x6B94C8)
        
        digits.authenticateWithDigitsAppearance(digitsAppearance, viewController: nil, title: nil) { (session, error) in
            // Inspect session/error objects
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Onboarded")
            self.performSegueWithIdentifier("showMoments", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
