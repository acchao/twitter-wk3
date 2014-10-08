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

    //Get the my user timeline
    //         https://api.twitter.com/1.1/users/lookup.json?screen_name=
//    func userProfileWithCompletion(params: NSDictionary?, completion: (user: User?, error: NSError?) -> ()) {
//        let screenname = User.currentUser?.screenname
//        params?.setValue(screenname, forKey: "screenname")
//        GET("1.1/users/lookup.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//
//            var users = [User]()
//            for dictionary in array {
//                tweets.append(Tweet(dictionary: dictionary))
//            }
//
//
//            var user = User.userWithArray(response as [NSDictionary])
//            completion(user: user, error: nil)
//
//            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println("error getting timeline")
//                completion(user: nil, error: error)
//        })
//    }

    // Get the home timeline
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {

        params?.setValue(21, forKey: "count")
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)

        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting timeline")
            completion(tweets: nil, error: error)
        })
    }

    func mentionsTimelineWithCompletion(params: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting timeline")
                completion(tweets: nil, error: error)
        })
    }

    func userTimelineWithCompletion(params: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting timeline")
                completion(tweets: nil, error: error)
        })
    }

    func suggestedFunnyFollowsWithCompletion(completion: (users: [User]?, error: NSError?) -> ()) {
        GET("1.1/users/suggestions/funny/members.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in

            var users = User.usersWithArray(response as [NSDictionary])
            completion(users: users, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting suggestions")
                completion(users: nil, error: error)
        })
    }

    // Post a new tweet or a reply
    func tweet(parameters: NSDictionary, completion: (success: AnyObject?, error: NSError?)->()) {
        POST("1.1/statuses/update.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("\(response)")
            completion(success:response, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in

                println("failed to post status: \(error)")
                completion(success:nil, error: error)
        })
    }


    // Favorite a tweet
    func favorite(status_id: String, completion: (response: AnyObject?, error: NSError?)->()) {
        var parameters = ["id": status_id]

        POST("1.1/favorites/create.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(response:response, error: nil)

        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in

            println("failed to favorite post: \(error)")
            completion(response:nil, error: error)
        })
    }

    // Retweet
    func retweet(status_id: String, completion: (response: AnyObject?, error: NSError?)->()) {
        var parameters = ["id": status_id]

        POST("1.1/statuses/retweet/\(status_id).json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("\(response)")
            completion(response:response, error: nil)

            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in

                println("failed to retweet post: \(error)")
                completion(response:nil, error: error)
        })
    }

    // Login
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
