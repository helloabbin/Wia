//
//  WReviewController.swift
//  Wia
//
//  Created by Abbin Varghese on 01/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

class WReviewController: UITableViewController {

    enum WReviewControllerRow: Int {
        case images
        case rating
        case review
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelReviewController(_:)))
        navigationItem.leftBarButtonItem = back
    }
    
    func cancelReviewController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == WReviewControllerRow.images.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WReviewImageCollectionCell", for: indexPath)
            return cell
        }
        else if indexPath.row == WReviewControllerRow.rating.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WRatingCell", for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WReviewCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == WReviewControllerRow.rating.rawValue {
            return 60
        }
        else {
            return 120
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
