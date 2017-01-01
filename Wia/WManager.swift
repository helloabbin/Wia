//
//  WManager.swift
//  Wia
//
//  Created by Abbin Varghese on 01/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import CloudKit

class WManager: NSObject {
    
    class func searchItems(searchText:String, completion:(_ results: [CKRecord], _ searchedText: String) -> Void) {
        if searchText.length > 0 {
            completion([], searchText.cleaned)
        }
        else{
            completion([], searchText.cleaned)
        }
    }
    
    class func searchPlaces(searchText:String, completion:(_ results: [CKRecord], _ searchedText: String) -> Void) {
        completion([], searchText.cleaned)
    }
    
    class func searchCuisines(searchText:String, completion:(_ results: [CKRecord], _ searchedText: String) -> Void) {
        completion([], searchText.cleaned)
    }
}
