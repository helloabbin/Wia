//
//  WMakePlaceAdditionalPhoneNumberCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakePlaceAdditionalPhoneNumberCellDelegate {
    func additionalPhoneNumberCellAccessoryButtonTapped(cell:WMakePlaceAdditionalPhoneNumberCell)
}

class WMakePlaceAdditionalPhoneNumberCell: UITableViewCell {

    var delegate: WMakePlaceAdditionalPhoneNumberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addbuttonClicked(_ sender: Any) {
        delegate?.additionalPhoneNumberCellAccessoryButtonTapped(cell: self)
    }
}
