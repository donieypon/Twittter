//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class User: NSObject {
    var dictionary: [String: Any]? // For user persistance
    var name: String?
    var screenName: String?
    var followersCount: Int
    var followingCount: Int
    var tweetsCount: Int
    
    var profilePictureString: String //String of the profile picture
    var profilePictureURL: URL // URL conversion from string above of the profile picture of tweet
    
    var profileImageUrl: String?
    var profileBackgroundString: String? // String of profile background image
    var profileBackgroundURL: URL? // URL conversion from profileBackroundURL
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    
    init(dictionary: [String : Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        
        profilePictureString = dictionary["profile_image_url"] as! String
        profilePictureURL = URL(string: profilePictureString)!
        
        followersCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        tweetsCount = dictionary["statuses_count"] as! Int
    }
}
