//
//  TweetCell.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/28/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit


protocol TweetCellDelegate {
    func tweetCellReplyButtonClicked(tweetCell: TweetCell)
}


class TweetCell: UITableViewCell {


    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var delegate: TweetCellDelegate?

    var tweet: Tweet! {
        didSet {
            let user = tweet.user!
            tweetLabel.text = tweet.text
            userLabel.text = user.name
            dateLabel.text = tweet.getTimeSinceTweet()
            handleLabel.text = "@\(user.screenname!)"
            if tweet.retweeter == nil || tweet.retweeter == "" {
                retweetIcon.hidden = true
                retweeterLabel.hidden = true
            }
            profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
            // Round the image corners
            profileImage.layer.cornerRadius = 5
            profileImage.clipsToBounds = true
            favoriteButton.selected = (tweet.favorited! == 1)
            retweetButton.selected = (tweet.retweeted! == 1)
        }
    }

    @IBAction func onReply(sender: AnyObject) {
        delegate!.tweetCellReplyButtonClicked(self)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        profileImage.backgroundColor = UIColor.blueColor()
        retweetIcon.backgroundColor = UIColor.blackColor()

        // TODO(Andrew): Play around with visual formatting another day
//        var viewsDict = [
//            "retweetIcon" : retweetIcon,
//            "retweetLabel" : retweetLabel,
//            "profileImage" : profileImage,
//            "userLabel" : userLabel,
//            "handle" : handle,
//            "dateTime" : dateTime,
//            "tweet" : tweet,
//            "replyButton" : replyButton,
//            "retweetButton" : retweetButton,
//            "favoriteButton" : favoriteButton,
//        ]
//
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image(10)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[labTime]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-[message]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-[image(10)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
