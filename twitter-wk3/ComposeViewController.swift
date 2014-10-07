//
//  ComposeViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/30/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate {
    func composeViewControllerTweetButtonClicked(composeViewController: ComposeViewController)
}

class ComposeViewController: UIViewController, UITextViewDelegate {


    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var composeButton: UIButton!


    var mentions: String?

    var delegate: ComposeViewControllerDelegate?

    var tweet: Tweet! {
        didSet {
            let user_mentions = tweet.entities!["user_mentions"] as NSArray
            var mentions = ""
            for user_mention in user_mentions {
                var user = User(dictionary: user_mention as NSDictionary)
                mentions = "@\(user.screenname!) \(mentions)"
            }
            mentions = "@\(tweet.user!.screenname!) \(mentions)"
            self.mentions = mentions
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = User.currentUser!
        profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!));
        nameLabel.text = user.name!
        handleLabel.text = "@\(user.screenname!)"

        tweetTextView.delegate = self
        if mentions != nil {
            tweetTextView.text = mentions
            tweetTextView.textColor = UIColor.blackColor();
        }

    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if mentions == nil {
            tweetTextView.text = "";
            tweetTextView.textColor = UIColor.blackColor();
        }
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
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onTweet(sender: AnyObject) {
        var parameters = ["status": tweetTextView.text]
        if tweet != nil && tweet.status_id != nil {
            parameters["in_reply_to_status_id"] = tweet.status_id
        }

        TwitterClient.sharedInstance.tweet(parameters, completion: { (success, error) -> () in
            if error == nil {
                println("success!")
            }
            self.dismissViewControllerAnimated(true, completion: {})
            self.delegate!.composeViewControllerTweetButtonClicked(self)
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
