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

    @IBOutlet weak var nextButton: UIButton!
    
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
    
    func cancelItemMakeController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "WPlaceSearchControllerSegue", sender: self)
    }
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == WMakeItemControllerRow.description.rawValue {
            return 120
        }
        else{
            return 60
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
