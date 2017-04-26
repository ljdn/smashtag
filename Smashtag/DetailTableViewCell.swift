//
//  DetailTableViewCell.swift
//  Smashtag
//
//  Created by lduan on 4/25/17.
//  Copyright © 2017 lduan. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var DetailTextLabel: UILabel!
    
    var displayData: Any? { didSet { updateUI() } }
    
    private func updateUI() {
        
        if let media = displayData as? MediaItem {
            if let imageData = try? Data(contentsOf: media.url) {
                DetailImageView.image = UIImage(data: imageData)
                DetailTextLabel.isHidden = true
            }
        } else if let textData = displayData as? Mention {
            DetailTextLabel.text = String(describing: textData)
            DetailImageView.isHidden = true
        }
        
    }

}
