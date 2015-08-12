//
//  TimerViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/27/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.

import Foundation
import UIKit
import AddressBook
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel! = nil
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var focusingLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    var gracePeriodStart : NSDate?
    var name: String!
    var person : ABRecord?
    var punishment : String?
    var screenBrightness = UIScreen.mainScreen().brightness
    private var counter = 100.00
    var timer: NSTimer!
    var timerDuration: Double? = 0.0 {
        // Enabling update of timer
        didSet {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            counter = timerDuration!
        }
    }
    
    // Give up button alert
    @IBAction func giveUpButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Giving up?", message:
            "Are you sure you want to give up? :(", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: {
            action in
            self.performSegueWithIdentifier("toPunish", sender: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    let currentUserName = PFUser.currentUser()?.valueForKey("name") as? String ?? "Someone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        focusingLabel.text = "Focusing on " + name!
        
        // Creates contact image, heart default
        if (ABPersonHasImageData(person)) {
            let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
            let image = UIImage(data: imgData)
            contactImage.image = image
            setPictureDesign(contactImage)
        } else {
            let defaultImage = UIImage(named: "default")
            contactImage.image = defaultImage
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didBecomeActive:",
            name: "didBecomeActive",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didEnterBackground:",
            name: "didEnterBackground",
            object: nil)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
    }
    
    @objc func didEnterBackground(notification: NSNotification){
        println("Enter background")
        println(screenBrightness)

        gracePeriodStart = NSDate()
        let inTimer = NSUserDefaults.standardUserDefaults().boolForKey("inTimer")
        
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"gracePeriod")
        
        if inTimer && screenBrightness >= 0 {
            var date = NSDate()
            var dateComp = NSDateComponents()
            dateComp.second = 1
            var cal = NSCalendar.currentCalendar()
            var fireDate: NSDate = cal.dateByAddingComponents(dateComp, toDate: date, options: NSCalendarOptions.allZeros)!
            
            let startGracePeriod: NSDate
            
            var promptUser: UILocalNotification = UILocalNotification()
            promptUser.alertBody = "Return to Jointly promptly to prevent yourself from being penalized!"
            promptUser.fireDate = fireDate
            UIApplication.sharedApplication().scheduleLocalNotification(promptUser)
        }
    }

    @objc func didBecomeActive(notification: NSNotification) {
        println("Become active")
        if let gracePeriodStart = gracePeriodStart {
            let gracePeriodEnd = gracePeriodStart.dateByAddingTimeInterval(10)
            if gracePeriodEnd.compare(NSDate()) == .OrderedAscending {
                if screenBrightness >= 0 {
                    // Penalize!
                    performSegueWithIdentifier("toPunish", sender: nil)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateText:", name: "update", object: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "inTimer")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "inTimer")
    }
    
    // Moves punishment from TimerVC to PunishmentVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toPunish") {
            let destination = segue.destinationViewController as! PunishmentViewController
            destination.punishment = punishment
        }
    }
    
    // Create circular image
    func setPictureDesign(image: UIImageView){
        image.layer.cornerRadius = image.frame.size.height/2
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0;
    }
    
    // Formats timer into hh:mm:ss
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Updates timer
    func update() {
        if (counter > 0) {
            counter--
            NSNotificationCenter.defaultCenter().postNotificationName("update", object: nil)
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            timer.invalidate()
            self.performSegueWithIdentifier("toHappy", sender: self)
        }
    }
    
    // Displays timer
    func updateText(notification: NSNotification) {
        timerLabel.text = stringFromTimeInterval(counter)
    }
}