//
//  RecentSearches.swift
//  Smashtag
//
//  Created by lduan on 4/27/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import Foundation

class RecentSearches {
    
    let defaults = UserDefaults.standard
    var recentSearches: [String]
    
    init() {
        recentSearches = [String]()
        defaults.set(recentSearches, forKey: "recentSearches")
    }
    
    func saveSearch(searchText: String) {
        if recentSearches.count >= 100 {
            recentSearches.removeFirst()
        }
        recentSearches.append(searchText)
        defaults.set(recentSearches, forKey: "recentSearches")
    }
    
    func getSearches() -> [String] {
        return defaults.object(forKey: "recentSearches") as! [String]
    }
}
