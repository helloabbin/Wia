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

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var delegate: WMakePlaceAdditionalWorkingHoursCellDelegate?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction

    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.additionalWorkingHoursCellAccessoryButtonTapped(cell: self)
    }
    
}
