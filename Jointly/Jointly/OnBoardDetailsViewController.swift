//
//  OnBoardDetailsViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/9/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import UIKit

class OnBoardDetailsViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var titleText = ""
    var descriptionText = ""
    var indexInController = 0
    var iconView = 0
    var isGetStartedButtonHideen = true
    var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        getStartedButton.hidden = isGetStartedButtonHideen
        imageview.image = image
        
         self.edgesForExtendedLayout = UIRectEdge.None
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
