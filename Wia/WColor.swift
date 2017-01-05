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
    
    open class func colorFor(value : CGFloat) -> UIColor {
        if value > 9 {
            return UIColor.init(red: 42/255, green: 82/255, blue: 6/255, alpha: 1.0)
        }
        else if value > 8 {
            return UIColor.init(red: 55/255, green: 115/255, blue: 1/255, alpha: 1.0)
        }
        else if value > 7 {
            return UIColor.init(red: 81/255, green: 158/255, blue: 37/255, alpha: 1.0)
        }
        else if value > 6 {
            return UIColor.init(red: 143/255, green: 197/255, blue: 44/255, alpha: 1.0)
        }
        else if value > 5 {
            return UIColor.init(red: 198/255, green: 208/255, blue: 21/255, alpha: 1.0)
        }
        else if value > 4 {
            return UIColor.init(red: 255/255, green: 208/255, blue: 5/255, alpha: 1.0)
        }
        else if value > 3 {
            return UIColor.init(red: 255/255, green: 177/255, blue: 5/255, alpha: 1.0)
        }
        else if value > 2 {
            return UIColor.init(red: 255/255, green: 108/255, blue: 3/255, alpha: 1.0)
        }
        else if value > 1 {
            return UIColor.init(red: 217/255, green: 27/255, blue: 17/255, alpha: 1.0)
        }
        else {
            return UIColor.init(red: 198/255, green: 26/255, blue: 34/255, alpha: 1.0)
        }
    }

}
