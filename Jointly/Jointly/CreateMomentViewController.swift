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
    
//    @IBAction func checkPerson(sender: AnyObject) {
//        if self.addContact
//    }
    
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
    
//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        if identifier == "toSuggestPenality" && person == nil {
//            return false
//        } else {
//            return true
//        }
//    }
    
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