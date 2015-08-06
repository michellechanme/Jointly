//
//  MaybeFocusingViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/28/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import Foundation
import UIKit
import Parse
import AddressBookUI
import AddressBook

class MaybeFocusViewController: UIViewController {
    
    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var focusImage: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var name: String?
    var person: ABRecord?
    var targetUser: PFUser?
    var toPass: String!
    
    //let currentUserName = PFUser.currentUser()?.valueForKey("name") as? String ?? "Someone"
    
    override func viewDidLoad() {
        let name = self.name ?? "a friend"
        focusLabel.text = "Would you like to focus on " + name + "?"
        
        
        if (ABPersonHasImageData(person)) {
            let imgData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue()
            let image = UIImage(data: imgData)
            focusImage.image = image
            setPictureDesign(focusImage)
        } else {
            
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Create circular image
    
    func setPictureDesign(image: UIImageView){
        image.layer.cornerRadius = image.frame.size.height/2
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toReceiveSuggestPenalty") {
            var destinationViewController = segue.destinationViewController as! ReceiveSuggestPenaltyViewController
            destinationViewController.person = person
            destinationViewController.name = name
        }
    }
}