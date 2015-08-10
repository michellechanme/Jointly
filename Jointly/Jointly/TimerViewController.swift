//
//  TimerViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/27/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.

import Foundation
import UIKit
import AddressBook

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel! = nil
    @IBOutlet weak var giveUpButton: UIButton!
    @IBOutlet weak var focusingLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    var name: String!
    var person : ABRecord?
    var punishment : String?
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateText:", name: "update", object: nil)
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
//            timerLabel.text = stringFromTimeInterval(counter)
            NSNotificationCenter.defaultCenter().postNotificationName("update", object: nil)
        } else {
            self.performSegueWithIdentifier("toHappy", sender: self)
            timer.invalidate()
        }
    }
    
    // Displays timer
    func updateText(notification: NSNotification) {
        timerLabel.text = stringFromTimeInterval(counter)
    }
}