//
//  WMakePlaceAdditionalPhoneNumberCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol WMakePlaceAdditionalPhoneNumberCellDelegate {
    func additionalPhoneNumberCellAccessoryButtonTapped(at indexPath: IndexPath)
    func additionalPhoneNumberCellDidChange(phoneNumber: String?, at indexPath: IndexPath)
}

class WMakePlaceAdditionalPhoneNumberCell: UITableViewCell, UITextFieldDelegate {

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var cellTextField: PhoneNumberTextField!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var cellIndexPath: IndexPath!
    var delegate: WMakePlaceAdditionalPhoneNumberCellDelegate?
    
    let phoneNumberKit = PhoneNumberKit()
    var defaultCountryCode = ""
    
    var cellText: String? {
        didSet {
            cellTextField.text = cellText
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func textFieldEditingChanged(_ sender: PhoneNumberTextField) {
        if sender.text != defaultCountryCode {
            delegate?.additionalPhoneNumberCellDidChange(phoneNumber: sender.text?.cleaned, at: cellIndexPath)
        }
        else {
            delegate?.additionalPhoneNumberCellDidChange(phoneNumber: nil, at: cellIndexPath)
        }
    }
    
    @IBAction func addbuttonClicked(_ sender: UIButton) {
        delegate?.additionalPhoneNumberCellAccessoryButtonTapped(at: cellIndexPath)
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
        if (range.location <= 2 && range.length >= 1) {
            return false
        }
        else{
            return true
        }
    }
    
}
