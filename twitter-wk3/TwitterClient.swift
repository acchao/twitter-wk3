//
//  TwitterClient.swift
//  twitter-wk3
//
//  Created by Andrew Chao on 9/29/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

let twitterConsumerKey = "6jKgkn4KO1Yz6zfqLEwY4WIia"
let twitterConsumerSecret = "hmLjUuJjqL89r4XC6jn1NFKhH8jiXuIPcF1uYenmiquPNc5wTI"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {

        var parameters = ["count": 21]
        GET("1.1/statuses/home_timeline.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)

        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting timeline")
            completion(tweets: nil, error: error)
        })
    }

    func tweet(status: String, completion: (success: AnyObject?, error: NSError?)->()) {
        var parameters = ["status": status]

        POST("1.1/statuses/update.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("\(response)")
            completion(success:response, error: nil)

        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in

            println("failed to post status: \(error)")
            completion(success:nil, error: error)
        })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion

        // Fetch request token & redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in

            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)

            }) { (error: NSError!) -> Void in
                println("Error getting the request token: \(error)")
                self.loginCompletion?(user:nil, error: error)
        }
    }

    func openURL(url: NSURL) {

        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken (queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            println("got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)

            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user:nil, error: error)
            })



        }) { (error: NSError!) -> Void in
            println("Failed to gett the access token!")
            self.loginCompletion?(user:nil, error: error)
        }

    }
}
