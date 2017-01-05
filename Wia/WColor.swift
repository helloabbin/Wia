//
//  WColor.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit

class WColor: UIColor {
    
    override open class var green: UIColor {
        get {
            return UIColor.init(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
        }
    }
    
    override open class var red: UIColor {
        get {
            return UIColor.init(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
        }
    }
    
    open class var mainColor: UIColor {
        get {
            return UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        }
    }
}
