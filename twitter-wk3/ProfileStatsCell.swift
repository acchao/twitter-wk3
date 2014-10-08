//
//  ProfileStatsCell.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 10/7/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ProfileStatsCell: UITableViewCell {

    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    var user: User! {
        didSet {
            statusCountLabel.text = "\(user.statusesCount!)"
            followingCountLabel.text = "\(user.friendsCount!)"
            followersCountLabel.text = "\(user.followersCount!)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
