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
    func additionalPhoneNumberCellDidChange(phoneNumber: (countryCode: String, phoneNumber: String)?, at indexPath: IndexPath)
}

class WMakePlaceAdditionalPhoneNumberCell: UITableViewCell {

    @IBOutlet weak var cellCountryCodeTextField: UITextField!
    @IBOutlet weak var cellTextField: PhoneNumberTextField!
    
    var cellIndexPath: IndexPath!
    var delegate: WMakePlaceAdditionalPhoneNumberCellDelegate?
    
    let phoneNumberKit = PhoneNumberKit()
    var defaultCountryCode = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.withPrefix = false
        if let unWrapped = phoneNumberKit.countryCode(for: PhoneNumberKit.defaultRegionCode()) {
            defaultCountryCode = "+\(unWrapped)"
            cellCountryCodeTextField.text = "\(defaultCountryCode)"
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
        if let unwrapped = sender.text?.cleaned {
            if unwrapped.length > 0 {
                let number = (countryCode: defaultCountryCode, phoneNumber: unwrapped)
                delegate?.additionalPhoneNumberCellDidChange(phoneNumber: number, at: cellIndexPath)
            }
            else {
                delegate?.additionalPhoneNumberCellDidChange(phoneNumber: nil, at: cellIndexPath)
            }
        }
    }

    @IBAction func addbuttonClicked(_ sender: UIButton) {
        delegate?.additionalPhoneNumberCellAccessoryButtonTapped(at: cellIndexPath)
    }
    
    var cellPhoneNumber: String? {
        didSet {
            cellTextField.text = cellPhoneNumber
        }
    }
    
    var cellCountryCode: String? {
        didSet {
            cellCountryCodeTextField.text = cellCountryCode
        }
    }
    
}
