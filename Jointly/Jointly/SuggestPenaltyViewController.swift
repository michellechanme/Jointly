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

class SuggestPenaltyViewController: UIViewController, UITextFieldDelegate {
    
    var name : String?
    var person : ABRecord?
    
    @IBOutlet weak var chosenContact: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var suggestPenaltyBox: UITextView!
    
    
    @IBAction func detailsButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Penalties", message:
            "Someone gets “penalized” when they either hit the “give up” button or leave the app for over 5 seconds.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    enum VerticalAlignment: Int {
        case Top = 0, Middle, Bottom
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
        
//        self.suggestPenaltyBox.delegate = self
        
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
        
        // circular image
//        self.roundingUIView(self.myUIImageView, cornerRadiusParam: 10)
//        self.roundingUIView(self.myUIViewBackground, cornerRadiusParam: 20)
        
        func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
            var contactImage: UIImageView = UIImageView(image: image)
            var layer: CALayer = CALayer()
            layer = contactImage.layer
            
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat(radius)
            
            UIGraphicsBeginImageContext(contactImage.bounds.size)
            layer.renderInContext(UIGraphicsGetCurrentContext())
            var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return roundedImage
        }
        
        // moves text view when keyboard appears
        self.suggestPenaltyBox = UITextView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func dismissKeyboard() {
        self.suggestPenaltyBox.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // press enter to dismiss keyboard
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
}