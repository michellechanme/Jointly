//
//  ReceiveSuggestPenaltyViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/31/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit
import AddressBook
import AddressBookUI
import QuartzCore

class ReceiveSuggestPenaltyViewController: UIViewController {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var receiveSuggestPenaltyBox: UITextView!
    @IBOutlet weak var receiveFocusButton: UIButton!
    
    var navBar:UINavigationBar = UINavigationBar()
    
    @IBAction func detailsButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Penalties", message:
            "Someone gets “penalized” when they either hit the “give up” button or leave the app for over 5 seconds.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // For moving text view up when keyboard selected
    
    struct MoveKeyboard {
        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navBar.tintColor = UIColor.whiteColor()
        setupBarStyle()
        
        // corner radius of SuggestPenaltyBox
        receiveSuggestPenaltyBox.layer.cornerRadius = 5
        
        // dismiss keyboard by swiping down
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        
        // resize suggestPenalityBox to size
        let fixedWidth = receiveSuggestPenaltyBox.frame.size.width
        receiveSuggestPenaltyBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = receiveSuggestPenaltyBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = receiveSuggestPenaltyBox.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        receiveSuggestPenaltyBox.frame = newFrame;
        
        // moves keyboard up when text view selected
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    // MARK: keyboard
    
    // moves keyboard up when text view selected
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    // swipe to dismiss keyboard
    
    func dismissKeyboard() {
        self.receiveSuggestPenaltyBox.resignFirstResponder()
    }
    
    // MARK: nav bar style
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.blackColor()
        
        let customFont = UIFont(name: "Avenir", size: 17.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: customFont!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
    }
    
    private func setupBarStyle() {
        if let font = UIFont(name: "Avenir", size: 18) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
        
        navigationController?.navigationBar.barTintColor = UIColorFromRGB(0x6D97CC)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Avenir", size: 20)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Suggest a Penalty"
    }

}