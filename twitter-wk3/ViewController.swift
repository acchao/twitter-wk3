//
//  ViewController.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/28/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tweetTableView.delegate = self
        tweetTableView.dataSource = self



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell

        return cell
    }
}

