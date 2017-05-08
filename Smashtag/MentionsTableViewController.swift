//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by lduan on 5/3/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import CoreData

class MentionsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Tweet>?
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var mention: String? { didSet { updateUI() } }
    var popularMentionsDict = [String: Int]()
    var popularMentions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController?.delegate = self
    }
    
    func getPopularMentions() -> [String] {
        if let mention = mention, let context = container?.viewContext {

            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            request.predicate = NSPredicate(format: "any text contains[c] %@", mention)
            request.sortDescriptors = [NSSortDescriptor(key: "unique", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController<Tweet>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            try? fetchedResultsController?.performFetch()
            let tweets = fetchedResultsController?.fetchedObjects ?? []
            
            for tweet in tweets {
                for popularMention in tweet.mentions! {
                    let popularMention = popularMention as! Mention
                    if let popularity = popularMentionsDict[popularMention.text!] {
                        popularMentionsDict[popularMention.text!] = popularity + 1
                    } else {
                        popularMentionsDict[popularMention.text!] = 1
                    }
                }
            }
            if !(popularMentionsDict.isEmpty) {
                popularMentions = Array((popularMentionsDict.keys)).filter( {(popularMentionsDict[$0]!) > 1} )
            }
            popularMentions.sort{ (mention1: String, mention2: String) -> Bool in
                if popularMentionsDict[mention1] == popularMentionsDict[mention2] {
                    return mention1 < mention2
                } else {
                    return (popularMentionsDict[mention1])! > (popularMentionsDict[mention2])!
                }
            }
        }
        return popularMentions
    }
    
    private func updateUI() {
        popularMentions = getPopularMentions()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMentions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularMention", for: indexPath)
        cell.textLabel?.text = popularMentions[indexPath.row]
        cell.detailTextLabel?.text = ("Mentioned \((popularMentionsDict[popularMentions[indexPath.row]])!) times")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = sender as! UITableViewCell
        
        if segue.identifier == "searchMention" {
            var destination = segue.destination
            if let tabBarController = destination as? UITabBarController {
                destination = (tabBarController.viewControllers?[0] ?? destination)!
                tabBarController.selectedIndex = 0
            }
            if let navController = destination as? UINavigationController {
                destination = navController.visibleViewController ?? destination
            }
            if let tweetTableVC = destination as? TweetTableViewController {
                tweetTableVC.searchText = selected.textLabel?.text
            }
        }
    }
}
