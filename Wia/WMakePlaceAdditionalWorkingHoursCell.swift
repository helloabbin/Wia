//
//  WMakePlaceAdditionalWorkingHoursCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakePlaceAdditionalWorkingHoursCellDelegate {
    func additionalWorkingHoursCellAccessoryButtonTapped(cell:WMakePlaceAdditionalWorkingHoursCell)
}

class WMakePlaceAdditionalWorkingHoursCell: UITableViewCell {

    var delegate: WMakePlaceAdditionalWorkingHoursCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.additionalWorkingHoursCellAccessoryButtonTapped(cell: self)
    }
    
}