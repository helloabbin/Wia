//
//  WMakeItemController.swift
//  Wia
//
//  Created by Abbin Varghese on 01/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

class WMakeItemController: UITableViewController {
    
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
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    func cancelItemMakeController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "WPlaceSearchControllerSegue", sender: self)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == WMakeItemControllerRow.name.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemTextFieldCell", for: indexPath)
            return cell
        }
        else if indexPath.row == WMakeItemControllerRow.price.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemPriceCell", for: indexPath)
            return cell
        }
        else if indexPath.row == WMakeItemControllerRow.cuisine.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakeItemCuisineCell", for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WItemMakeDescriptionCell", for: indexPath)
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
            performSegue(withIdentifier: "WCuisinePickerControllerSegue", sender: self)
        }
    }
}
