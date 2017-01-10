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

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var delegate:WMakePlaceAddressCellDelegate?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let unwrapped = sender.text {
            delegate?.makePlaceAddressCellDidChangeEditing(text: unwrapped.cleaned)
        }
    }
    
}
