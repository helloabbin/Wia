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
    
    @IBOutlet weak var cellTextField: UITextField!
    
    var delegate:WMakeItemNameCellDelegate?
    
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
            cellTextField.text = cellText
        }
    }
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let unwrapped = sender.text {
            delegate?.makeItemNameCellDidChangeEditing(text: unwrapped.cleaned)
        }
    }
    
}
