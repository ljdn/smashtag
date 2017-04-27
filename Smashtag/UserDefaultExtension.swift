//
//  RecentSearches.swift
//  Smashtag
//
//  Created by lduan on 4/27/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func getSearches() -> [String] {
        return UserDefaults.standard.object(forKey: "recentSearches") as! [String]
    }
    
    func saveSearch(text: String) {
        if UserDefaults.standard.object(forKey: "recentSearches") == nil {
            let recentSearches = [text]
            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        } else if var recentSearches = UserDefaults.standard.object(forKey: "recentSearches") as? [String] {
            if recentSearches.count >= 100 {
                recentSearches.removeFirst()
            }
            recentSearches.append(text)
            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        }
    }
    
}
