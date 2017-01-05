//
//  WMakePlacePhoneNumberCell.swift
//  Wia
//
//  Created by Abbin Varghese on 04/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakePlacePhoneNumberCellDelegate {
    func phoneNumberCellAccessoryButtonTapped(cell:WMakePlacePhoneNumberCell)
}

class WMakePlacePhoneNumberCell: UITableViewCell {

    var delegate: WMakePlacePhoneNumberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.phoneNumberCellAccessoryButtonTapped(cell: self)
    }
}
