//
//  HomeViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 10/7/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var menuViewController: UIViewController!
    var tweetsNavigationController: UINavigationController!
    var profileNavigationController: UINavigationController!
    var mentionsNavigationController: UINavigationController!

    @IBOutlet weak var contentViewXConstraint: NSLayoutConstraint!

    @IBOutlet weak var mentionsButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as UINavigationController
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UINavigationController
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController") as UINavigationController

        self.contentViewXConstraint.constant = 0
        self.activeViewController = tweetsNavigationController
        
    }

    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }

    @IBAction func didTapSideBarButton(sender: UIButton) {
        if sender == profileButton {
            println("profileButton")
            activeViewController = profileNavigationController
        } else if sender == homeButton {
            println("homeButton")
            activeViewController = tweetsNavigationController
        } else if sender == mentionsButton {
            println("mentionsButton")
            activeViewController = mentionsNavigationController
        }
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.contentViewXConstraint.constant = 0
            self.view.layoutIfNeeded()
        })

    }

    @IBAction func didSwipeRight(sender: UISwipeGestureRecognizer) {
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.contentViewXConstraint.constant = -160
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBAction func didSwipeLeft(sender: UISwipeGestureRecognizer) {
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.contentViewXConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }

//    @IBAction func didPan(sender: UIPanGestureRecognizer) {
//        var location = sender.locationInView(view)
//        var translation = sender.translationInView(view)
//        println("location \(location.x)")
//        println("translation \(translation.x)")
//        if sender.state == .Changed {
//            let x = translation.x
//            println(x)
//            if x <= 160 && x >= 0{
//                self.contentView.frame.origin.x = x
//            } else if x > 160 {
//                self.contentView.frame.origin.x = 160
//            } else if x < 0 {
//                self.contentView.frame.origin.x = 0
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
