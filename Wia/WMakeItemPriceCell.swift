//
//  WMakeItemPriceCell.swift
//  Wia
//
//  Created by Abbin Varghese on 02/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WMakeItemPriceCellDelegate {
    func makeItemPriceCellDidChange(price: Double)
}

class WMakeItemPriceCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var cellTextField: UITextField!
    
    var delegate: WMakeItemPriceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = NSLocale.current.currencySymbol
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == NSLocale.current.currencySymbol {
            textField.text = ""
        }
    }
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let price = sender.text?.priceValue {
            delegate?.makeItemPriceCellDidChange(price: price)
        }
        else{
            delegate?.makeItemPriceCellDidChange(price: 0.0)
        }
    }

}
