//
//  WMakePlaceController.swift
//  Wia
//
//  Created by Abbin Varghese on 02/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

class WMakePlaceController: UITableViewController,WMakePlacePhoneNumberCellDelegate, WMakePlaceAdditionalPhoneNumberCellDelegate, WMakePlaceWorkingHoursCellDelegate, WMakePlaceAdditionalWorkingHoursCellDelegate {
    
    enum WMakePlaceControllerSection: Int {
        case name
        case address
        case coordinates
        case phoneNumber
        case workingDays
        case workinghours
    }
    
    var numberOfPhoneNumberCells = 1
    var numberOfWorkingHourCells = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelPlaceMakeController(_:)))
        navigationItem.leftBarButtonItem = back
        
        tableView.keyboardDismissMode = .interactive
    }
    
    func cancelPlaceMakeController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == WMakePlaceControllerSection.phoneNumber.rawValue {
            return numberOfPhoneNumberCells
        }
        else if section == WMakePlaceControllerSection.workinghours.rawValue {
            return numberOfWorkingHourCells
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == WMakePlaceControllerSection.name.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceNameCell", for: indexPath)
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.address.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAddressCell", for: indexPath)
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.coordinates.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceCoordinatesCell", for: indexPath)
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.phoneNumber.rawValue {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlacePhoneNumberCell", for: indexPath) as! WMakePlacePhoneNumberCell
                cell.delegate = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAdditionalPhoneNumberCell", for: indexPath) as! WMakePlaceAdditionalPhoneNumberCell
                cell.delegate = self
                return cell
            }
        }
        else if indexPath.section == WMakePlaceControllerSection.workingDays.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceWorkingDaysCell", for: indexPath)
            return cell
        }
        else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceWorkingHoursCell", for: indexPath) as! WMakePlaceWorkingHoursCell
                cell.delegate = self
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAdditionalWorkingHoursCell", for: indexPath) as! WMakePlaceAdditionalWorkingHoursCell
                cell.delegate = self
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == WMakePlaceControllerSection.workinghours.rawValue {
            if indexPath.row == 0 {
                return 96
            }
            else{
                return 60
            }
        }
        else{
            return 60
        }
    }
    
    func phoneNumberCellAccessoryButtonTapped(cell: WMakePlacePhoneNumberCell) {
        numberOfPhoneNumberCells += 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.phoneNumber.rawValue), with: .automatic)
    }
    
    func additionalPhoneNumberCellAccessoryButtonTapped(cell: WMakePlaceAdditionalPhoneNumberCell) {
        numberOfPhoneNumberCells -= 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.phoneNumber.rawValue), with: .automatic)
    }
    
    func workingHoursCellAccessoryButtonTapped(cell: WMakePlaceWorkingHoursCell) {
        numberOfWorkingHourCells += 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.workinghours.rawValue), with: .automatic)
    }
    
    func additionalWorkingHoursCellAccessoryButtonTapped(cell: WMakePlaceAdditionalWorkingHoursCell) {
        numberOfWorkingHourCells -= 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.workinghours.rawValue), with: .automatic)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
