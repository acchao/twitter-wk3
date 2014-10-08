//
//  MentionsViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 10/7/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit


class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        view.showActivityViewWithLabel("Loading...")
        reloadTableView()

        // set up pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "reloadTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // Reloads with mentions
    func reloadTableView() {
        var params = ["count": "21"]
        TwitterClient.sharedInstance.mentionsTimelineWithCompletion(params, completion: { (tweets, error) -> () in
            if error != nil {
                println(error)
            } else {
                self.tweets = tweets!
                self.view.hideActivityView()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
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

        cell.tweet = tweets[indexPath.row] as Tweet
        cell.contentView.layoutSubviews()
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showUserSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    @IBAction func onTapUserImage(sender: UITapGestureRecognizer) {
        println("tapped")
        self.performSegueWithIdentifier("showUserSegue", sender: self)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showUserSegue" {
            var indexPath = tableView.indexPathForSelectedRow() as NSIndexPath!
            var vc = (segue.destinationViewController as UINavigationController).topViewController as ProfileViewController
            vc.profileUser = tweets[indexPath.row].user as User!
        }
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
