//
//  TweetDetailsViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/30/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var tweet: Tweet!
    var composeButtonTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = tweet.user!.name!
        handleLabel.text = tweet.user!.screenname!
        tweetTextLabel.text = tweet.text!
        favoriteCountLabel.text = "\(tweet.favorite_count!)"
        retweetCountLabel.text = "\(tweet.retweet_count!)"
        profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let str = dateFormatter.stringFromDate(tweet.createdAt!)
        dateLabel.text = str

        retweetIcon.hidden = true
        retweeterLabel.hidden = true

        favoriteButton.selected = (tweet.favorited! == 1)
        retweetButton.selected = (tweet.retweeted! == 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReply(sender: AnyObject) {
        composeButtonTitle = "Reply"
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }

    @IBAction func onRetweet(sender: UIButton) {
        sender.selected = true
        TwitterClient.sharedInstance.retweet(tweet.status_id!, completion: { (response, error) -> () in
            if error != nil {
                println(error)
                sender.selected = false
            } else {
                println(response)
            }
        })
    }

    @IBAction func onFavorite(sender: UIButton) {
        // set to true until undo is enabled
        sender.selected = true
        TwitterClient.sharedInstance.favorite(tweet.status_id!, completion: { (response, error) -> () in
            if error != nil {
                println(error)
                sender.selected = false
            } else {
                println(response)
            }
        })
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "composeSegue" {
            var vc = (segue.destinationViewController as UINavigationController).topViewController as ComposeViewController
            vc.composeButton.title = composeButtonTitle
            if tweet != nil {
                vc.tweet = tweet
            }
        }
    }


}
