//
//  OnBoardViewController.swift
//  Jointly
//
//  Created by Michelle Chan on 7/9/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
        
    var titles = ["Focus", "Time", "Penalize", "Be Present"]
    var descriptions = ["Whenever you want to focus on each other, create a moment.",
                        "Set a clock for quality time together, without devices.",
                        "'Penalize' your partner whenever they're distracted by their device.",
                        "Use Jointly and be present with the one who matters most."]
    var icons = ["focus", "time", "penalize", "BePresent"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OnBoardPageController") as! UIPageViewController
        
        pageViewController.dataSource = self
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        setupPageControl()
        
        pageViewController.setViewControllers([getItemController(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
//    func isBoarded() -> Bool {
//        var settings = NSUserDefaults.standardUserDefaults()
//        return settings.boolForKey("boardingSetting")
//    }
//    
//    func setBoardedTrue() {
//        var settings = NSUserDefaults.standardUserDefaults()
//        settings.setBool(true, forKey: "boardingSetting")
//        settings.synchronize()
//    }
    
    func getItemController(index: Int) -> OnBoardDetailsViewController {
        let detailsController = self.storyboard!.instantiateViewControllerWithIdentifier("OnBoardDetailsViewController") as! OnBoardDetailsViewController
        
        detailsController.titleText = titles[index]
        detailsController.descriptionText = descriptions[index]

        detailsController.indexInController = index
        
        detailsController.image = UIImage(named: icons[index])
        
        if index == titles.count - 1 {
            detailsController.isGetStartedButtonHideen = false
        }
        
        
        return detailsController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return titles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let detailsController = viewController as! OnBoardDetailsViewController
        
        let index = detailsController.indexInController + 1
        
        if index <= titles.count - 1 {
            return getItemController(index)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let detailsController = viewController as! OnBoardDetailsViewController
        
        let index = detailsController.indexInController - 1
        
        if index >= 0 {
            return getItemController(index)
        }
        
        return nil
    }
    
    private func setupPageControl() {
        let apparance = UIPageControl.appearance()
        apparance.pageIndicatorTintColor = UIColor.lightGrayColor()
        apparance.currentPageIndicatorTintColor = UIColor.whiteColor()
        apparance.backgroundColor = UIColor.clearColor()        
        
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
