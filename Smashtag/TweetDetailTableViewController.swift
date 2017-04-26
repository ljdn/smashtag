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
//            if sectionTitle == "Media" {
//                detailCell.DetailTextLabel.isHidden = true
//            } else {
//                detailCell.DetailImageView.isHidden = true
//            }
        }

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
