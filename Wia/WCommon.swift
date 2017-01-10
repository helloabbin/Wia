//
//  WCommon.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit

class WCommon: NSObject {
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Extentions

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - UIViewController

extension UIViewController {
    
    func simpleAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - String

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
    var cleaned: String {
        get {
            return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var trimmed: String {
        get {
            return cleaned.replacingOccurrences(of: " ", with: "")
        }
    }
    
    var capped: String {
        get {
            return trimmed.lowercased()
        }
    }
    
    var priceValue: Double? {
        get {
            if let currencySymbol = NSLocale.current.currencySymbol {
                return Double(cleaned.replacingOccurrences(of: currencySymbol, with: ""))
            }
            else{
                return nil
            }
        }
    }
    
}
