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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Search Functions
    
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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Save Functions
    
    class func newCuisine(name: String, completionHandler: @escaping (CKRecord?, Error?) -> Swift.Void) {
        let recordId = CKRecordID(recordName: name.capped)
        let cuisineRecord = CKRecord(recordType: WConstants.recordType.cuisine, recordID: recordId)
        
        cuisineRecord.setObject(name as CKRecordValue?, forKey: WConstants.cuisine.name)
        cuisineRecord.setObject(name.capped as CKRecordValue?, forKey: WConstants.cuisine.cappedName)
        
//        let container = CKContainer.default()
//        let dataBase = container.publicCloudDatabase
//        
//        let begin = Date()
//        
//        dataBase.save(cuisineRecord) { (cuisine, error) in
//            let end = Date()
//            let timeInterval = end.timeIntervalSince(begin)
//            print(error?.localizedDescription ?? "Cuisine Saved: \(timeInterval)")
            DispatchQueue.main.async {
                completionHandler(cuisineRecord, nil)
            }
//        }
    }
}
