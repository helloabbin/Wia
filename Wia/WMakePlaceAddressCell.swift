//
//  WMakePlaceAddressCell.swift
//  Wia
//
//  Created by Abbin Varghese on 03/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakePlaceAddressCellDelegate {
    func makePlaceAddressCellDidChangeEditing(text: String)
}

class WMakePlaceAddressCell: UITableViewCell {

    var delegate:WMakePlaceAddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let unwrapped = sender.text {
            delegate?.makePlaceAddressCellDidChangeEditing(text: unwrapped.cleaned)
        }
    }

}
