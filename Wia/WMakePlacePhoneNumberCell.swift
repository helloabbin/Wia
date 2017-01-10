//
//  WMakePlacePhoneNumberCell.swift
//  Wia
//
//  Created by Abbin Varghese on 04/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol WMakePlacePhoneNumberCellDelegate {
    func phoneNumberCellAccessoryButtonTapped(cell:WMakePlacePhoneNumberCell)
    func phoneNumberCellDidChange(phoneNumber: String?)
}

class WMakePlacePhoneNumberCell: UITableViewCell, UITextFieldDelegate {

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var cellTextField: PhoneNumberTextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var delegate: WMakePlacePhoneNumberCellDelegate?
    
    let phoneNumberKit = PhoneNumberKit()
    var defaultCountryCode = ""
    
    var cellPhoneNumber: String? {
        didSet {
            cellTextField.text = cellPhoneNumber
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func textFieldEditingChanged(_ sender: PhoneNumberTextField) {
        if sender.text != defaultCountryCode {
            delegate?.phoneNumberCellDidChange(phoneNumber: sender.text?.cleaned)
        }
        else {
            delegate?.phoneNumberCellDidChange(phoneNumber: nil)
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.phoneNumberCellAccessoryButtonTapped(cell: self)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTextField.withPrefix = false
        
        if let code = phoneNumberKit.countryCode(for: PhoneNumberKit.defaultRegionCode()) {
            defaultCountryCode = "+\(code)"
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTextField.text = ""
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = defaultCountryCode
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == defaultCountryCode {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location <= defaultCountryCode.length && range.length >= 1) {
            return false
        }
        else{
            return true
        }
    }
    
}
