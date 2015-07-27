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
    @IBOutlet weak var timePicker: UIDatePicker!

    var selectedPerson : String?
    var navBar:UINavigationBar = UINavigationBar()
    
    // checking if a contact was selected
    var person: ABRecord? {
        didSet {
            nextButton.enabled = (person != nil)
        }
    }
    
    func vibrate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(addContact.center.x - 2.0, addContact.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(addContact.center.x + 2.0, addContact.center.y))
        addContact.layer.addAnimation(animation, forKey: "position")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        person = nil
        
        navBar.tintColor = UIColor.whiteColor()
        
        // part of return keyboard
        self.contactTextField.delegate = self
        
        setupBarStyle()
        
        // dismiss keyboard by swiping down
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
    }
    
    override func viewDidAppear(animated: Bool) {
         var nav = self.navigationController?.navigationBar
         nav?.tintColor = UIColor.whiteColor()
        
        let customFont = UIFont(name: "Avenir", size: 17.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: customFont!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
    }
    
    // MARK: nav bar style
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: press enter to dismiss keyboard
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func dismissKeyboard() {
        self.contactTextField.resignFirstResponder()
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func timerDuration() {
        countdownTimer.countDownDuration = 180
    }
    
    func getTime() {
        var timer = NSTimer()
        var counter = 0
        
    }
    
    // MARK: carrying contact's name to toSuggestPenlity's VC
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toSuggestPenality") {
            var destinationViewController = segue.destinationViewController as! SuggestPenaltyViewController
            destinationViewController.name = selectedPerson
            destinationViewController.person = person
        }
    }
    
    // MARK: converts Apple's contact to Parse's phone number format :|
    
    func getUser() {

        if let phoneNumbers: AnyObject = ABRecordCopyValue(person, kABPersonPhoneProperty)?.takeRetainedValue() {
            if ABMultiValueGetCount(phoneNumbers) > 0 {
                if let primaryPhone: AnyObject = ABMultiValueCopyValueAtIndex(phoneNumbers, 0)?.takeRetainedValue() {
                    let userQuery = PFUser.query()!
                    
                    // manipulate strings of phone numbers..
                    
                    
                    userQuery.whereKey("phone", equalTo: sanitizePhoneNumber(primaryPhone as! String)) // primaryPhone
                    
                    println("Local contact has phone number \(primaryPhone)")
                    
                    let installationQuery = PFInstallation.query()
                    installationQuery?.whereKey("user", matchesQuery: userQuery)
                    let push = PFPush()
                    push.setQuery(installationQuery);
                    push.setMessage("Someone would like to focus on you :-)")
                    push.sendPushInBackgroundWithBlock({ (success, error) -> Void in
                        println("Well, at least the push completed. Success? \(success)")
                    })
                } else {
                    println("Could not retrieve user's primary phone number")
                }
            } else {
                println("Contact has no phone numbers")
            }
        } else {
            println("Contact has no phone property")
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
        
        getUser()
        
    }
}