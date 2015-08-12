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
    var primaryPhone : String?
    var animateDistance = CGFloat()
    var timerDuration: Double = 0.0
    
    @IBOutlet weak var chosenContact: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var suggestPenaltyBox: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func unwindToCreateMoment(sender: AnyObject) {
    }
    
    let PLACEHOLDER_TEXT = "i.e. Pay the next food bill"
    
    @IBAction func focusButtonPressed(sender: AnyObject) {
        if suggestPenaltyBox.text != PLACEHOLDER_TEXT {
            performSegueWithIdentifier("focusing", sender: nil)
        } else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(suggestPenaltyBox.center.x - 10, suggestPenaltyBox.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(suggestPenaltyBox.center.x + 10, suggestPenaltyBox.center.y))
            suggestPenaltyBox.layer.addAnimation(animation, forKey: "position")
        }
    }
    
    // Details button alert
    @IBAction func detailsButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Penalties", message:
            "Penalties occur by “giving up” or attempting to leave the app during the 'focusing' time.", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        chosenContact.text = name
        
        focusButton.setTitle("Focus on \(name as String!)", forState: .Normal)
        
        if (ABPersonHasImageData(person)) {
            let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
            let image = UIImage(data: imgData)
            contactImage.image = image
            setPictureDesign(contactImage)
        } else {
            let defaultImage = UIImage(named: "default")
            contactImage.image = defaultImage
        }
        
        // corner radius of SuggestPenaltyBox
        suggestPenaltyBox.layer.cornerRadius = 5
        
        applyPlaceholderStyle(suggestPenaltyBox!, placeholderText: PLACEHOLDER_TEXT)
        
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
        
        suggestPenaltyBox?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.detailsButton.rotate360Degrees()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPictureDesign(contactImage)
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String) {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightTextColor()
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView) {
        aTextview.textColor = UIColor.whiteColor()
        aTextview.alpha = 1.0
    }
    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool {
        if aTextView == suggestPenaltyBox && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            moveCursorToStart(aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView) {
        dispatch_async(dispatch_get_main_queue(), {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = count("textView.text".utf16) + count(text.utf16) - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            if textView == suggestPenaltyBox && textView.text == PLACEHOLDER_TEXT
            {
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(textView)
            return false
        }
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
    
    // Create circular image
    func setPictureDesign(image: UIImageView){
        image.layer.cornerRadius = image.frame.size.height/2
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "focusing") {
            var destinationViewController = segue.destinationViewController as! TimerViewController
            destinationViewController.timerDuration = timerDuration
            destinationViewController.person = person
            destinationViewController.name = name
            destinationViewController.punishment = suggestPenaltyBox.text
            
            let currentUserName = PFUser.currentUser()?.valueForKey("name") as? String ?? "Someone"
            let data = [
                "alert" : currentUserName + " would like to focus on you",
                "userid" : PFUser.currentUser()?.objectId ?? "",
                "punishment" : suggestPenaltyBox.text,
                "counter" : timerDuration
            ] as [NSObject: AnyObject]
            let installationQuery = PFInstallation.query()
            let userQuery = PFUser.query()!
            
            println(primaryPhone)

            userQuery.whereKey("phone", equalTo: sanitizePhoneNumber(primaryPhone ?? "")) // primaryPhone
            
            installationQuery?.whereKey("user", matchesQuery: userQuery)
            let push = PFPush()
            push.setQuery(installationQuery);
            push.setData(data)
            push.sendPushInBackgroundWithBlock({ (success, error) -> Void in
                
                println("Well, at least the push completed. Success? \(success)")
                println(error)
            })

        }
    }
}

// Rotates object
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}