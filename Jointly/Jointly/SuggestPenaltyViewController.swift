//
//  SuggestPenalty.swift
//  Jointly
//
//  Created by Michelle Chan on 7/16/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import UIKit
import AddressBook
import QuartzCore

class SuggestPenaltyViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var name : String?
    var person : ABRecord?
    
    @IBOutlet weak var chosenContact: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var suggestPenaltyBox: UITextView!
    
    var animateDistance = CGFloat()
    
    let PLACEHOLDER_TEXT = "Suggest a penalty for your partner.."
    
    @IBAction func detailsButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Penalties", message:
            "Someone gets “penalized” when they either hit the “give up” button or leave the app for over 5 seconds.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    struct MoveKeyboard {
        static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
        static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
        static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
        static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
        static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenContact.text = name
        
        suggestPenaltyBox.text = "Suggest potential penalty for your partner.."
        
        // Do any additional setup after loading the view.
        
        focusButton.setTitle("Focus on \(name as String!)", forState: .Normal)
        
            if (ABPersonHasImageData(person)) {
                let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
                let image = UIImage(data: imgData)
                contactImage.image = image
            }
        
        // corner radius of SuggestPenaltyBox
        suggestPenaltyBox.layer.cornerRadius = 4
        
        // dismiss keyboard by swiping down
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        
        // resize suggestPenalityBox to size
        let fixedWidth = suggestPenaltyBox.frame.size.width
        suggestPenaltyBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = suggestPenaltyBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = suggestPenaltyBox.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        suggestPenaltyBox.frame = newFrame;
        
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        self.view.frame = viewFrame
        UIView.commitAnimations()
    }

    // swipe to dismiss keyboard
   
    func dismissKeyboard() {
        self.suggestPenaltyBox.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}