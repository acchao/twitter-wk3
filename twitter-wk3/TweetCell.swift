//
//  TweetCell.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/28/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {


    @IBOutlet weak var retweeterLabel: UIView!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var userLabel: UIView!
    @IBOutlet weak var handleLabel: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!

    @IBOutlet weak var replyButton: UIView!
    @IBOutlet weak var retweetButton: UIView!
    @IBOutlet weak var favoriteButton: UIView!

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
