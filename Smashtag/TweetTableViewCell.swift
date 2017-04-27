//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by lduan on 4/20/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() }}
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetUserLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            formatText()
            
            tweetUserLabel?.text = tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            } else {
                tweetProfileImageView?.image = nil
            }
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24 * 60 * 60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private func formatText() {
        if let text = tweetTextLabel.attributedText as? NSMutableAttributedString {
            for userMention in tweet!.userMentions {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: userMention.nsrange)
            }
            for hashtag in tweet!.hashtags {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.magenta, range: hashtag.nsrange)
            }
            for url in tweet!.urls {
                text.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: url.nsrange)
            }
            
            tweetTextLabel.attributedText = text
        }
    }
    
}
