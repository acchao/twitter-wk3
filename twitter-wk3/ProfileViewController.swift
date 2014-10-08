//
//  ProfileViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 10/7/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!


    enum SectionType {
        case Header
        case Stats
        case Settings
        case Navigation
        case Tweets
        case Users
    }

    class Section{
        var type: SectionType!
        var title: String!
        var rows: [String]!

        init (type: SectionType, title: String, rows: [String]) {
            self.type = type
            self.title = title
            self.rows = rows
        }

        convenience init() {
            self.init(type: SectionType.Navigation, title: "blank", rows: [""])
        }

        convenience init(type: SectionType, title: String) {
            self.init(type: type, title: title, rows: [""])
        }
    }

    var sections = [
        Section(type: SectionType.Header, title:"", rows:[" "]), // banner
        Section(type: SectionType.Stats, title:"", rows:[" "]),
        Section(type: SectionType.Settings, title:"", rows:[" "]),
        Section(type: SectionType.Tweets, title:" "), //user_timeline
        Section(type: SectionType.Navigation, title:"", rows:["More Tweets"]),
        Section(
            type: SectionType.Navigation,
            title:" ",
            rows: ["Following", "Followers", "Favorites", "Lists"]
        ), // lists
        Section(type: SectionType.Navigation, title:" ", rows: ["Drafts"]), // drafts
        Section(type: SectionType.Users, title:"Who to follow"),
        Section(type: SectionType.Navigation, title:"", rows:["More"]),
        ]

    var tweets: [Tweet] = []
    var users: [User] = []
    var profileUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        if profileUser == nil {
            profileUser = User.currentUser
        }
        reloadTableView()
    }

    // Reloads with tweets
    func reloadTableView() {
        // get my tweets
        var params = ["count": "4"]
        params["screen_name"] = profileUser.screenname
        TwitterClient.sharedInstance.userTimelineWithCompletion(params, completion: { (tweets, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.tweets = tweets!
                self.tableView.reloadData()
            }
        })

        // get funny suggestions
        TwitterClient.sharedInstance.suggestedFunnyFollowsWithCompletion { (users, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.users = users!
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SectionType.Tweets == sections[section].type {
            if 3 > tweets.count {
                return tweets.count
            }
            return 3
        } else if SectionType.Users == sections[section].type {
            if 3 > users.count {
                return users.count
            }
            return 3
        }
        return sections[section].rows.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as NavigationCell
        if sections[indexPath.section].type == SectionType.Tweets {
            var tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
            tweetCell.tweet = tweets[indexPath.row]
            tweetCell.contentView.layoutSubviews()
            return tweetCell
        } else if sections[indexPath.section].type == SectionType.Users {
            var userCell = tableView.dequeueReusableCellWithIdentifier("UserCell") as UserCell
            userCell.user = users[indexPath.row]
            userCell.contentView.layoutSubviews()
            return userCell
        } else if sections[indexPath.section].type == SectionType.Header {
            var headerCell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell") as ProfileHeaderCell
            headerCell.user = profileUser
            headerCell.contentView.layoutSubviews()
            return headerCell
        } else if sections[indexPath.section].type == SectionType.Stats {
            var statsCell = tableView.dequeueReusableCellWithIdentifier("ProfileStatsCell") as ProfileStatsCell
            statsCell.user = profileUser
            statsCell.contentView.layoutSubviews()
            return statsCell
        } else if sections[indexPath.section].type == SectionType.Settings {
            var settingsCell = tableView.dequeueReusableCellWithIdentifier("ProfileSettingsCell") as ProfileSettingsCell
            settingsCell.contentView.layoutSubviews()
            return settingsCell
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
            cell.titleLabel.text = sections[indexPath.section].rows[indexPath.row]
        }
        cell.contentView.layoutSubviews()
        return cell
    }

    // Change the color of the label
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var label : UILabel = UILabel()
//
//        let title = sections[section].title
//        if title == " " {
//            label.frame.size = CGSize(width: view.frame.size.width, height: 5)
//        }
//
//        label.backgroundColor = UIColor.lightGrayColor()
//        label.textColor = UIColor.grayColor()
//        label.text = sections[section].title
//        label.layoutMargins = UIEdgeInsets(
//            top: 0,
//            left: 40,
//            bottom: 0,
//            right: 0)
//        return label
//    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        view.layoutSubviews()
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
