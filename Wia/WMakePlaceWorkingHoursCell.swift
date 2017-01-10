//
//  WMakePlaceWorkingHoursCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakePlaceWorkingHoursCellDelegate {
    func workingHoursCellAccessoryButtonTapped(cell:WMakePlaceWorkingHoursCell)
}

class WMakePlaceWorkingHoursCell: UITableViewCell {

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var tillTextField: UITextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var delegate: WMakePlaceWorkingHoursCellDelegate?
    
    var cellFromInputView: UIView? {
        didSet {
            fromTextField.inputView = cellFromInputView
        }
    }
    
    var cellTillInputView: UIView? {
        didSet {
            tillTextField.inputView = cellTillInputView
        }
    }
    
    var cellFromText: String? {
        didSet {
            fromTextField.text = cellFromText
        }
    }
    
    var cellTillText: String? {
        didSet {
            tillTextField.text = cellTillText
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction

    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.workingHoursCellAccessoryButtonTapped(cell: self)
    }
    
}
