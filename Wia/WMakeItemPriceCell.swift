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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var cellTextField: UITextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var delegate: WMakeItemPriceCellDelegate?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func textFieldDidChangeEditing(_ sender: UITextField) {
        if let price = sender.text?.priceValue {
            delegate?.makeItemPriceCellDidChange(price: price)
        }
        else{
            delegate?.makeItemPriceCellDidChange(price: 0.0)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITextFieldDelegate
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && range.length == 1) || (range.location > 6 && range.length == 0) {
            return false
        }
        else{
            return true
        }
    }
}
