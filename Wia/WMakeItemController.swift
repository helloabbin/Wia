//
//  WMakeItemController.swift
//  Wia
//
//  Created by Abbin Varghese on 01/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import CloudKit

class WMakeItemController: UITableViewController, WCuisineSearchControllerDelegate, WMakeItemNameCellDelegate, WMakeItemPriceCellDelegate, WItemMakeDescriptionCellDelegate {
    
    enum WMakeItemControllerRow: Int {
        case name
        case price
        case cuisine
        case description
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet

    @IBOutlet weak var nextButton: UIButton!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var itemName = ""
    var itemPrice = 0.0
    var itemCuisine: CKRecord?
    var itemDescription = ""
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelItemMakeController(_:)))
        navigationItem.leftBarButtonItem = back
        
        tableView.keyboardDismissMode = .interactive
        
        nextButton.backgroundColor = WColor.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WCuisineSearchControllerSegue" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.viewControllers.first as! WCuisineSearchController
            controller.delegate = self
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    func cancelItemMakeController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
//        if itemName.length == 0 {
//            simpleAlert(title: "Missing Name", message: "What is the name of the item?")
//        }
//        else if itemPrice == 0.0 {
//            simpleAlert(title: "Missing Price", message: "How much does the item cost?")
//        }
//        else if itemCuisine == nil {
//            simpleAlert(title: "Missing Cuisine", message: "What type of cuisine is the item?")
//        }
//        else {
            performSegue(withIdentifier: "WPlaceSearchControllerSegue", sender: self)
//        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == WMakeItemControllerRow.name.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemNameCell", for: indexPath) as! WMakeItemNameCell
            cell.delegate = self
            cell.cellText = itemName
            return cell
        }
        else if indexPath.row == WMakeItemControllerRow.price.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemPriceCell", for: indexPath) as! WMakeItemPriceCell
            cell.delegate = self
            return cell
        }
        else if indexPath.row == WMakeItemControllerRow.cuisine.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemCuisineCell", for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WItemMakeDescriptionCell", for: indexPath) as! WItemMakeDescriptionCell
            cell.delegate = self;
            return cell
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == WMakeItemControllerRow.description.rawValue {
            return 120
        }
        else{
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == WMakeItemControllerRow.cuisine.rawValue {
            performSegue(withIdentifier: "WCuisineSearchControllerSegue", sender: self)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WCuisineSearchControllerDelegate
    
    func cuisineSearchController(didFinishWith cuisine: CKRecord) {
        itemCuisine = cuisine
        let cell = tableView.cellForRow(at: IndexPath(row: WMakeItemControllerRow.cuisine.rawValue, section: 0)) as! WMakeItemCuisineCell
        cell.cellText = itemCuisine?[WConstants.cuisine.name] as! String?
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakeItemNameCellDelegate
    
    func makeItemNameCellDidChangeEditing(text: String) {
        itemName = text
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakeItemPriceCellDelegate
    
    func makeItemPriceCellDidChange(price: Double) {
        itemPrice = price
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WItemMakeDescriptionCellDelegate
    
    func itemMakeDescriptionCellDidChangeEditing(text: String) {
        itemDescription = text
    }

}
