//
//  ViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/28/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit



class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate , ComposeViewControllerDelegate{

    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tweetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tweetTableView.delegate = self
        tweetTableView.dataSource = self

        view.showActivityViewWithLabel("Loading...")
        reloadTableView()

        // set up pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "reloadTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tweetTableView.addSubview(refreshControl)

        tweetTableView.estimatedRowHeight = 100
        tweetTableView.rowHeight = UITableViewAutomaticDimension
    }

    // Reloads with tweets
    func reloadTableView() {
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil, completion: { (tweets, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.tweets = tweets!
                self.view.hideActivityView()
                self.refreshControl.endRefreshing()
                self.tweetTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {



        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell

        cell.delegate = self
        cell.tweet = tweets[indexPath.row] as Tweet
        cell.contentView.layoutSubviews()
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        composeButtonTitle = "Tweet"
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }

    // attributes of the compose view controller
    var composeButtonTitle = ""
    var tweet:Tweet?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tweetDetailsSegue" {
            var indexPath = tweetTableView.indexPathForSelectedRow() as NSIndexPath!
            var vc = (segue.destinationViewController as UINavigationController).topViewController as TweetDetailsViewController
            vc.tweet = tweets[indexPath.row] as Tweet
        } else if segue.identifier == "composeSegue" {
            var indexPath = tweetTableView.indexPathForSelectedRow() as NSIndexPath!
            var vc = (segue.destinationViewController as UINavigationController).topViewController as ComposeViewController
            vc.delegate = self
            vc.composeButton.title = composeButtonTitle
            if tweet != nil {
                vc.tweet = tweet
            }
        }
    }

    func tweetCellReplyButtonClicked(tweetCell: TweetCell) {
        composeButtonTitle = "Reply"
        tweet = tweetCell.tweet
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }

    func composeViewControllerTweetButtonClicked(composeViewController: ComposeViewController) {
        // TODO: do this without refetching. 
        // grab a tweet representation and insert it into self.tweets.
        reloadTableView()
    }

}

