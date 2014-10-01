//
//  Tweet.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/29/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeter: String?
    var status_id: String?
    var retweet_count: Int?
    var favorite_count: Int?
    var favorited: Int?
    var retweeted: Int?
    var entities: NSDictionary?

    init(dictionary: NSDictionary) {
        println(dictionary)
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        status_id = dictionary["id_str"] as? String
        entities = dictionary["entities"] as? NSDictionary
        retweet_count = dictionary["retweet_count"] as? Int
        favorite_count = dictionary["favorite_count"] as? Int
        retweeted = dictionary["retweeted"] as? Int
        favorited = dictionary["favorited"] as? Int

        // TODO: make static and a lazy property
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM DD HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }

    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

    func getTimeSinceTweet() -> String {
        // println(createdAtString)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: createdAt!)
        let hour = components.hour
        let minutes = components.minute

        if hour > 24 {
            return "\(hour/24)d"
        } else if hour > 0 {
            return "\(hour)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "now"
        }
    }
}
