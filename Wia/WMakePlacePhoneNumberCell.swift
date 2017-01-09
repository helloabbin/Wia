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
    func phoneNumberCellDidChange(phoneNumber: (countryCode: String, phoneNumber: String)?)
}

class WMakePlacePhoneNumberCell: UITableViewCell {

    @IBOutlet weak var cellCountryCodeTextField: UITextField!
    @IBOutlet weak var cellTextField: PhoneNumberTextField!
    
    var delegate: WMakePlacePhoneNumberCellDelegate?
    let phoneNumberKit = PhoneNumberKit()
    var defaultCountryCode = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextField.withPrefix = false
        if let unWrapped = phoneNumberKit.countryCode(for: PhoneNumberKit.defaultRegionCode()) {
            defaultCountryCode = "+\(unWrapped)"
            cellCountryCodeTextField.text = "\(defaultCountryCode) "
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFieldEditingChanged(_ sender: PhoneNumberTextField) {
        if let unwrapped = sender.text?.cleaned {
            if unwrapped.length > 0 {
                let number = (countryCode: defaultCountryCode, phoneNumber: unwrapped)
                delegate?.phoneNumberCellDidChange(phoneNumber: number)
            }
            else {
                delegate?.phoneNumberCellDidChange(phoneNumber: nil)
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        delegate?.phoneNumberCellAccessoryButtonTapped(cell: self)
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
