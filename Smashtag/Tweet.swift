//
//  Tweet.swift
//  Smashtag
//
//  Created by lduan on 5/1/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching tweetInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", tweetInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "database inconsistency - this should not happen")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = tweetInfo.identifier
        tweet.text = tweetInfo.text
        
        for mention in (tweetInfo.hashtags + tweetInfo.userMentions) {
            if let mentionInData = try? Mention.findOrCreateMention(matching: mention.keyword, in: context) {
                tweet.addToMentions(mentionInData)
            }
        }
        
        return tweet
    }
    
}
