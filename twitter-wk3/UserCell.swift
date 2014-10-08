//
//  UserCell.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 10/7/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var verifiedLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!


    var user: User! {
        didSet {
            nameLabel.text = user.name
            screennameLabel.text = "@\(user.screenname!)"
            profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
            // Round the image corners
            profileImage.layer.cornerRadius = 5
            profileImage.clipsToBounds = true
            if user.verified! {
                verifiedLabel.text = "verified"
            } else {
                verifiedLabel.text = ""
            }
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
