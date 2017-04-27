//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by lduan on 4/27/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {
    var recentSearches = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.getSearches().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearch", for: indexPath)

        cell.textLabel?.text = recentSearches.getSearches()[indexPath.row]

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = tableView.indexPathForSelectedRow
        
        if segue.identifier == "searchRecentTerm" {
            var destination = segue.destination
            if let tabBarController = destination as? UITabBarController {
                destination = (tabBarController.viewControllers?[0] ?? destination)!
                tabBarController.selectedIndex = 0
                print("set destination to nav controller")
            }
            if let navController = destination as? UINavigationController {
                destination = navController.visibleViewController ?? destination
            }
            if let tweetTableVC = destination as? TweetTableViewController {
                print(recentSearches.getSearches())
                tweetTableVC.searchText = recentSearches.getSearches()[(selected?.row)!]
            }
        }
    }

}
