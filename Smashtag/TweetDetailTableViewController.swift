//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by lduan on 4/24/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    var tweet: Tweet?
    var sections = Dictionary<String, [Any]>()
    var sectionTitles = [String]()
    
    private func populateSections() {
        if (tweet?.media.count)! as Int > 0 {
            sections["Media"] = tweet?.media
            sectionTitles.append("Media")
        }
        if (tweet?.userMentions.count)! as Int > 0 {
            sections["User Mentions"] = tweet?.userMentions
            sectionTitles.append("User Mentions")
        }
        if (tweet?.hashtags.count)! as Int > 0 {
            sections["Hashtags"] = tweet?.hashtags
            sectionTitles.append("Hashtags")
        }
        if (tweet?.urls.count)! as Int > 0 {
            sections["URLS"] = tweet?.urls
            sectionTitles.append("URLS")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        populateSections()
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return (sections[sectionTitle]?.count)! as Int
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetails", for: indexPath)

        let sectionTitle = sectionTitles[indexPath.section]

        if let detailCell = cell as? DetailTableViewCell, let displayData = sections[sectionTitle]?[indexPath.row]{
            detailCell.displayData = displayData
        }

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sectionTitles[indexPath.section] == "Media", let image = sections[sectionTitles[indexPath.section]]?[indexPath.row] as? Twitter.MediaItem {
            let rowHeight = 1 / (CGFloat(image.aspectRatio) / view.frame.width)
            print(image.aspectRatio)
            print(view.frame.width)
            print(rowHeight)
            return rowHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sectionTitles[indexPath.section] == "Media" {
            self.performSegue(withIdentifier: "showImageScrollView", sender: nil)
        } else if sectionTitles[indexPath.section] == "URLS" {
            let mention = sections[sectionTitles[indexPath.section]]?[indexPath.row] as! Twitter.Mention
            let url = URL(string: mention.keyword)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!)
            } else {
                UIApplication.shared.openURL(url!)
            }
        } else {
            self.performSegue(withIdentifier: "searchForTerm", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showImageScrollView" {
            if let imageScrollVC = segue.destination as?ImageScrollViewController, let mediaItem = sections[sectionTitles[selected.section]]?[selected.row] as? Twitter.MediaItem {
                imageScrollVC.imageURL = mediaItem.url
            }
        } else if segue.identifier == "searchForTerm" {
            var destinationVC = segue.destination
            if let navController = destinationVC as? UINavigationController {
                destinationVC = navController.visibleViewController ?? destinationVC
            }
            if let tweetTableVC = destinationVC as? TweetTableViewController, let mention = sections[sectionTitles[selected.section]]?[selected.row] as? Twitter.Mention {
                print(mention.keyword)
                tweetTableVC.searchText = mention.keyword
            }
        }
    }

}
