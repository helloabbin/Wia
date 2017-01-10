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

    @IBOutlet weak var cellTextField: PhoneNumberTextField!
    
    var cellIndexPath: IndexPath!
    var delegate: WMakePlaceAdditionalPhoneNumberCellDelegate?
    
    let phoneNumberKit = PhoneNumberKit()
    var defaultCountryCode = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTextField.withPrefix = false
        
        if let code = phoneNumberKit.countryCode(for: PhoneNumberKit.defaultRegionCode()) {
            defaultCountryCode = "+\(code)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTextField.text = ""
    }
    
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
    
    var cellText: String? {
        didSet {
            cellTextField.text = cellText
        }
    }
    
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
