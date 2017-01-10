//
//  WMakeItemNameCell.swift
//  Wia
//
//  Created by Abbin Varghese on 06/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakeItemNameCellDelegate {
    func makeItemNameCellDidChangeEditing(text: String)
}

class WMakeItemNameCell: UITableViewCell {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var cellTextField: UITextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var delegate:WMakeItemNameCellDelegate?
    
    var cellText: String? {
        didSet {
            cellTextField.text = cellText
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let unwrapped = sender.text {
            delegate?.makeItemNameCellDidChangeEditing(text: unwrapped.cleaned)
        }
    }
    
}
