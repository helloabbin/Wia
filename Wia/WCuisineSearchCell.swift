//
//  WCuisineSearchCell.swift
//  Wia
//
//  Created by Abbin Varghese on 06/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

class WCuisineSearchCell: UITableViewCell {

    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var cellText: String? {
        didSet {
            cellTextLabel.text = cellText
        }
    }
    
    func startAnimating() {
        cellActivityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        cellActivityIndicator.stopAnimating()
    }

}
