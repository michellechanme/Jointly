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
    var timerDuration: Double = 0.0 {
        // enabling updating of timer
        didSet {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            counter = timerDuration
        }
    }
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
    var counter = 100.0
    
    var timer: NSTimer!
    
    let currentUserName = PFUser.currentUser()?.valueForKey("name") as? String ?? "Someone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        focusingLabel.text = "Focusing on " + name!
        
        if (ABPersonHasImageData(person)) {
            let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
            let image = UIImage(data: imgData)
            contactImage.image = image
            setPictureDesign(contactImage)
        }
    }
    
    // Create circular image
    
    func setPictureDesign(image: UIImageView){
        image.layer.cornerRadius = image.frame.size.height/2
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0;
    }
    
    func update() {
        if (counter > 0) {
            counter--
            timerLabel.text = "\(counter)"
        }
        
    }
}