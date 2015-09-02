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
    var person: ABRecord?
//        didSet {
////            nextButton.userInteractionEnabled = (person != nil)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = nil
        
        setupBarStyle()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navBar.tintColor = UIColor.whiteColor()
        
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
//        navigationController?.setNavigationBarHidden(false, animated: false)
        
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

//            // display only numbers
//            let number: AnyObject = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
//            if (ABMultiValueGetCount(person) > 0) {
//                let index = 0 as CFIndex
//            }
            
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
        
        if let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String {
        }
        
        if person != nil {
            performSegueWithIdentifier("toSuggestPenality", sender: nil)
            
            let query = PFQuery(className: "_User")
            query.whereKey("phone", equalTo: primaryPhoneNumber!)
            query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]?, error: NSError?) -> Void in
                if let error = error {
                    println(error.description)
                } else {
                    if let users = results as? [PFUser] {
                        for user in users {
                            println(user.username)
                        }
                    }
                }
            })
        } else {
            let bounds = self.addContact.bounds
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
                self.addContact.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 20, width: bounds.size.width, height: bounds.size.height + 60)
                }, completion: nil)
        }
    }
    
    // MARK: get timer value
    
    var timer: NSTimer?
    var timerStart: NSDate?
    
    // MARK: carrying contact's name to toSuggestPenlity's VC + other VCs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let countdownDurationMinutes = Int64(countdownTimer.countDownDuration) / 60
        var timerDuration = Double(countdownDurationMinutes) * 60
        println(timerDuration)
        
        if (segue.identifier == "toSuggestPenality") {
            var destinationViewController = segue.destinationViewController as! SuggestPenaltyViewController
            destinationViewController.name = selectedPerson
            destinationViewController.person = person
            destinationViewController.timerDuration = timerDuration
            destinationViewController.primaryPhone = primaryPhoneNumber
        }
        
        if (segue.identifier == "MaybeFocusViewController") {
            var destinationViewController = segue.destinationViewController as! MaybeFocusViewController
            destinationViewController.name = selectedPerson
            destinationViewController.person = person
        }
    }
}

func sanitizePhone(number: String) ->String {
    var phone = number
    var final = ""
    let phoneUtil = NBPhoneNumberUtil()
    
    if (phone as NSString).substringToIndex(2) == "00" {
        phone = "+" + (phone as NSString).substringFromIndex(2)
    }
    
    if phone.rangeOfString("+") != nil {
        
        //there is a plus in the number
        let countryCode = phoneUtil.extractCountryCode(phone, nationalNumber: nil)
        var region = phoneUtil.getRegionCodeForCountryCode(countryCode)
        var parsedNumber = phoneUtil.parse(phone, defaultRegion: region, error: nil)
        
        final = phoneUtil.format(parsedNumber, numberFormat: NBEPhoneNumberFormatE164, error: nil)
        
    } else {
        
        var location = phoneUtil.countryCodeByCarrier()
        
        //            location = "IL"
        //            let location = phoneUtil.getCountryCodeForRegion("IL")
        
        let exampleNumber =  phoneUtil.getExampleNumber(location, error: nil)
        let nationalPhone = phoneUtil.format(exampleNumber, numberFormat: NBEPhoneNumberFormatNATIONAL, error: nil)
        println(nationalPhone)
        
        let normalizedExample = phoneUtil.normalizeDigitsOnly(nationalPhone)
        let exampleCount = count(normalizedExample)
        println(exampleCount)
        
        let normalizedPhone = phoneUtil.normalizeDigitsOnly(phone)
        println(normalizedPhone)
        
        if phoneUtil.isValidNumberForRegion(phoneUtil.parse(phone, defaultRegion: location, error: nil), regionCode: location){
            //this is just a normal number
            //in this country
            //for example (415) 419-1510
            // let parsedPhone = phoneUtil.parseWithPhoneCarrierRegion(phone, error: nil)
            
            let parsedPhone = phoneUtil.parse(phone, defaultRegion: location, error: nil)
            final = phoneUtil.format(parsedPhone, numberFormat: NBEPhoneNumberFormatE164, error: nil)
            
        } else {
            //this is a foreign number
            //and they forgot the +
            //or its just a random number
            
            phone = "+" + phone
            
            let countryCode = phoneUtil.extractCountryCode(phone, nationalNumber: nil)
            let region = phoneUtil.getRegionCodeForCountryCode(countryCode)
            let parsedPhone = phoneUtil.parse(phone, defaultRegion: region, error: nil)
            
            final = phoneUtil.format(parsedPhone, numberFormat: NBEPhoneNumberFormatE164, error: nil)
        }
    }
    println("FINAL " + final)
    return final
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
        
        if let phoneNumbers: AnyObject = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            if ABMultiValueGetCount(phoneNumbers) > 0 {
                if let primaryPhone: AnyObject = ABMultiValueCopyValueAtIndex(phoneNumbers, 0)?.takeRetainedValue() {
                    println("Local contact has phone number \(primaryPhone)")
                    primaryPhoneNumber = primaryPhone as? String
                    
                    primaryPhoneNumber = sanitizePhone(primaryPhoneNumber!)
                } else {
                    println("Could not retrieve user's primary phone number")
                }
            } else {
                println("Contact has no phone numbers")
            }
        } else {
            println("Contact has no phone property")
        }
        
        addContact.selected = true
    }
}