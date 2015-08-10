//
//  CreateMomentViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/14/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import UIKit
import AddressBookUI
import AddressBook
import Parse
import Foundation
import QuartzCore

class CreateMomentViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func unwindToCreateMoment(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            println("Identifier \(identifier)")
        }
    }
    
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addContact: UIButton!
    @IBOutlet weak var countdownTimer: UIDatePicker!    
    @IBOutlet weak var nextButton: UIButton!
    
    var primaryPhoneNumber : String?
    var firstNameContact: String?
    var selectedPerson : String?
    var navBar:UINavigationBar = UINavigationBar()
    
    // Checking if a contact was selected
    var person: ABRecord? {
        didSet {
//            nextButton.userInteractionEnabled = (person != nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        person = nil
        
        navBar.tintColor = UIColor.whiteColor()
        setupBarStyle()
        
        // part of return keyboard
        self.contactTextField.delegate = self
        
        // dismiss keyboard by swiping down
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    }
    
    // MARK: nav bar style
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         var nav = self.navigationController?.navigationBar
         nav?.tintColor = UIColor.whiteColor()
        
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
    
    // MARK: contacts picker
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        if addContact.selected == false {
            let picker = ABPeoplePickerNavigationController()
            picker.peoplePickerDelegate = self
            presentViewController(picker, animated: true, completion: nil)
        } else {
            addContact.selected = false
            contactTextField.text = "Who would you like to focus on?"
            person = nil
        }
    }
    
    // MARK: predict contact
    var predicate: NSPredicate = NSPredicate { (AnyObject person, NSDictionary bindings) -> Bool in
        var firstName: String? = ABRecordCopyValue(person as ABRecordRef, kABPersonFirstNameProperty).takeRetainedValue() as? String
        var lastName: String? = ABRecordCopyValue(person as ABRecordRef, kABPersonLastNameProperty).takeRetainedValue() as? String
        
        return firstName != nil || lastName != nil
    }
        
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: converts Apple's contact to Parse's phone number format :|
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        
        if let phoneNumbers: AnyObject = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            if ABMultiValueGetCount(phoneNumbers) > 0 {
                if let primaryPhone: AnyObject = ABMultiValueCopyValueAtIndex(phoneNumbers, 0)?.takeRetainedValue() {
                    println("Local contact has phone number \(primaryPhone)")
                    primaryPhoneNumber = primaryPhone as? String
                    
                    if let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String{
                    }
                } else {
                    println("Could not retrieve user's primary phone number")
                }
            } else {
                println("Contact has no phone numbers")
            }
        } else {
            println("Contact has no phone property")
        }
        
        if person != nil {
            performSegueWithIdentifier("toSuggestPenality", sender: nil)
        } else {
            let bounds = self.addContact.bounds
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
                self.addContact.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 20, width: bounds.size.width, height: bounds.size.height + 60)
                //                self.addContact.enabled = false
                }, completion: nil)
        }
    }
    
    // MARK: get timer value
    
    var timer: NSTimer?
    var timerStart: NSDate?
    
    func startTimer() {
        // get current system time
        self.timerStart = NSDate()
        
        // start the timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    // MARK: carrying contact's name to toSuggestPenlity's VC + other VCs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let countdownDurationMinutes = Int64(countdownTimer.countDownDuration) / 60
        var timerDuration = Double(countdownDurationMinutes) * 60
        println(timerDuration)
        
        if (segue.identifier == "toSuggestPenality") {
            var destinationViewController = segue.destinationViewController as! SuggestPenaltyViewController
            destinationViewController.name = selectedPerson
            destinationViewController.person = person
            destinationViewController.timerDuration = countdownTimer.countDownDuration
            destinationViewController.primaryPhone = primaryPhoneNumber
        }
        
        if (segue.identifier == "MaybeFocusViewController") {
            var destinationViewController = segue.destinationViewController as! MaybeFocusViewController
            destinationViewController.name = selectedPerson
            destinationViewController.person = person
        }
    }
}

func sanitizePhoneNumber(unfilteredNum: String) -> String {
    let acceptedChars = NSCharacterSet(charactersInString: "+1234567890")
    var filteredNum = String()
    for char in unfilteredNum.utf16 {
        if acceptedChars.characterIsMember(char) {
            filteredNum.append(UnicodeScalar(char))
        }
    }
    return filteredNum
}

// MARK: getting contact's name

extension CreateMomentViewController: ABPeoplePickerNavigationControllerDelegate {
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        println(person)
        
        let nameCFString: CFString = ABRecordCopyCompositeName(person).takeRetainedValue()
        let name: NSString = nameCFString as NSString
        selectedPerson = name as? String
        contactTextField.text = name as String
        
        self.person = person
        
        addContact.selected = true
    }
}