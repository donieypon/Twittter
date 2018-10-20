//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Donie Ypon on 10/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var usernameLabel: TTTAttributedLabel!
    @IBOutlet weak var handleLabel: TTTAttributedLabel!
    @IBOutlet weak var dateLabel: TTTAttributedLabel!
    @IBOutlet weak var tweetLabel: TTTAttributedLabel!
    
    @IBOutlet weak var replyAmountLabel: TTTAttributedLabel!
    @IBOutlet weak var rtAmountLabel: TTTAttributedLabel!
    @IBOutlet weak var favAmountLabel: TTTAttributedLabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var favorited: Bool?
    var retweeted: Bool?
    var imageString: String = ""
    
    var tweet: Tweet! {
        didSet {
            // User objects on the view
            usernameLabel.setText(tweet.user.name)
            usernameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            handleLabel.setText("@" + tweet.user.screenName!)
            usernameLabel.textColor = .gray
            imageString = tweet.user.profileImageUrl!
            let imageURL = URL(string: self.imageString)!
            profilePictureImage.af_setImage(withURL: imageURL)
            
            // Tweet objects on the view
            tweetLabel.text = tweet.text
            favorited = tweet.favorited!
            retweeted = tweet.retweeted
            //tweetTimeLabel.setText("• " + tweet.timeAgoSinceNow)
            tweetLabel.textColor = .gray
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        // TODO: Update the local tweet model (Done via functions below)
        if tweet.favorited == false {
            tweet.favorited = true
            favorite()
            
        } else {
            tweet.favorited = false
            unfavorite()
        }
        // TODO: Update cell UI
        updateUI()
    }
    
    @IBAction func didTapRt(_ sender: Any) {
        
        // TODO: Update the local tweet model (Done via functions below)
        if tweet.retweeted == false {
            tweet.retweeted = true
            retweet()
        } else {
            tweet.retweeted = false
            unretweet()
        }
        // TODO: Update cell UI
        updateUI()
    }
    
    func updateUI() {
        //Tweets Liked:
        if tweet.favorited == true {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        } else {
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        //Tweets Retweeted:
        if tweet.retweeted == true {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
        if tweet.retweetCount > 0 {
            rtAmountLabel.text = "\(tweet.retweetCount)"
        } else {
            rtAmountLabel.text = ""
        }
        if tweet.favoriteCount! > 0 {
            favAmountLabel.text = "\(tweet.favoriteCount!)"
        } else {
            favAmountLabel.text = ""
        }
    }
    
    func favorite() {
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text)")
                
                //Updating the count in this function
                tweet.favoriteCount! += 1
                self.favAmountLabel.text = "\(tweet.favoriteCount! + 1)"
                self.updateUI()
            }
        }
    }
    
    func unfavorite() {
        APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                tweet.favorited = false
                
                //Updating the count in this function
                tweet.favoriteCount! -= 1
                self.favAmountLabel.text = "\(tweet.favoriteCount! - 1)"
                self.updateUI()
            }
        }
    }
    
    func retweet() {
        APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error retweeting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                tweet.retweetCount += 1
                self.updateUI()
            }
        }
    }
    
    func unretweet() {
        APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error untweeting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                tweet.retweeted = false
                tweet.retweetCount -= 1
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
        }
    }
    

}
