//
//  WItemMakeDescriptionCell.swift
//  Wia
//
//  Created by Abbin Varghese on 02/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WItemMakeDescriptionCellDelegate {
    func itemMakeDescriptionCellDidChangeEditing(text: String)
}

class WItemMakeDescriptionCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var cellTextView: UITextView!
    
    var delegate: WItemMakeDescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "type here" {
            textView.text = ""
            textView.textColor = UIColor.darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "type here"
            textView.textColor = UIColor(white: 0, alpha: 0.25)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let unWrapped = textView.text {
            delegate?.itemMakeDescriptionCellDidChangeEditing(text: unWrapped.cleaned)
        }
    }

}
