//
//  Mention.swift
//  Smashtag
//
//  Created by lduan on 5/3/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Mention: NSManagedObject {
    
    class func findOrCreateMention(matching mentionInfo: String, in context: NSManagedObjectContext) throws -> Mention {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "text = %@", mentionInfo)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "database inconsistency - this should not happen")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = Mention(context: context)
        mention.text = mentionInfo
        return mention
    }
}
