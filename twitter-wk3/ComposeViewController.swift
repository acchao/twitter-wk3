//
//  ComposeViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/30/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {


    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!

    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = User.currentUser!
        profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!));
        nameLabel.text = user.name!
        handleLabel.text = "@\(user.screenname!)"

        tweetTextView.delegate = self
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        tweetTextView.text = "";
        tweetTextView.textColor = UIColor.blackColor();

        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let characterCount = countElements(textView.text) - range.length + countElements(text)
        charCountLabel.text = "\(140-characterCount)"
        if characterCount >= 140 {
            return false
        }
        return true
    }

    func textViewDidChange(textView: UITextView) {
        var tweetText = textView.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        println("why not cancel?")
//        navigationController!.popViewControllerAnimated(true)
//        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(tweetTextView.text, completion: { (success, error) -> () in
            if error == nil {
                println("success!")
            }
            self.dismissViewControllerAnimated(true, completion: {})
        })

    }

//    func getTweetText() -> String {
//        var text = tweetTextView.text
//        let index: String.Index = advance(text.startIndex, 140)
//        return text.substringToIndex(index)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
