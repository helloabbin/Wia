//
//  WMakePlaceController.swift
//  Wia
//
//  Created by Abbin Varghese on 02/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit
import Photos

class WMakePlaceController: UITableViewController,WMakePlacePhoneNumberCellDelegate, WMakePlaceAdditionalPhoneNumberCellDelegate, WMakePlaceWorkingHoursCellDelegate, WMakePlaceAdditionalWorkingHoursCellDelegate, WMakePlaceAddressCellDelegate, WMapViewControllerDelegate, WDaysControllerDelegate {
    
    enum WMakePlaceControllerSection: Int {
        case name
        case address
        case location
        case phoneNumber
        case workingDays
        case workinghours
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var nextButton: UIButton!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var numberOfPhoneNumberCells = 1
    var numberOfWorkingHourCells = 1
    
    var selectedAssets: [PHAsset]!
    
    var itemName = ""
    var itemPrice = 0.0
    var itemCuisine: CKRecord?
    var itemDescription = ""
    
    var placeName = ""
    var placeAddress = ""
    var placeLocation: CLLocation?
    var placePhoneNumbers = [String]()
    var placeWorkingDays = [Int]()
    var placeWokingFrom = [Date]()
    var placeWorkingTill = [Date]()
    
    let fromDatePicker = UIDatePicker()
    let tillDatePicker = UIDatePicker()
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelPlaceMakeController(_:)))
        navigationItem.leftBarButtonItem = back
        
        tableView.keyboardDismissMode = .interactive
        
        fromDatePicker.backgroundColor = UIColor.white
        fromDatePicker.datePickerMode = .time
        fromDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        tillDatePicker.backgroundColor = UIColor.white
        tillDatePicker.datePickerMode = .time
        tillDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        nextButton.backgroundColor = WColor.mainColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WMapViewControllerSegue" {
            let controller = segue.destination as! WMapViewController
            controller.delegate = self
        }
        else if segue.identifier == "WDaysControllerSegue" {
            let controller = segue.destination as! WDaysController
            controller.delegate = self
            controller.daysArray = placeWorkingDays
        }
        else if segue.identifier == "WReviewControllerSegue" {
//            let itemRecord = WManager.initItem(itemName: itemName,
//                                               itemPrice: itemPrice,
//                                               itemCuisine: itemCuisine!,
//                                               itemDescription: itemDescription,
//                                               placeName: placeName,
//                                               placeAddress: placeAddress,
//                                               placeLocation: placeLocation!,
//                                               placePhoneNumber: placePhoneNumbers,
//                                               placeWorkingDays: placeWorkingDays,
//                                               placeWorkingFrom: placeWokingFrom,
//                                               placeWorkingTill: placeWorkingTill)
            let controller = segue.destination as! WReviewController
//            controller.itemRecord = itemRecord
            controller.selectedAssets = selectedAssets
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - DatePickerMethod
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: WMakePlaceControllerSection.workinghours.rawValue)) as! WMakePlaceWorkingHoursCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        let date = sender.date
        
        if sender === fromDatePicker {
            let from = formatter.string(from: date)
            cell.cellFromText = from
            placeWokingFrom.removeAll()
            placeWokingFrom.append(date)
        }
        else {
            let till = formatter.string(from: date)
            cell.cellTillText = till
            placeWorkingTill.removeAll()
            placeWorkingTill.append(date)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    func cancelPlaceMakeController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
//        if placeName.length == 0 {
//            simpleAlert(title: "Name Missing", message: "Please provide the name of the place")
//        }
//        else if placeAddress.length == 0 {
//            simpleAlert(title: "Address Missing", message: "Please provide the address of the place")
//        }
//        else if placeLocation == nil {
//            simpleAlert(title: "Location Missing", message: "Please provide the exact location of this Place")
//        }
//        else {
            performSegue(withIdentifier: "WReviewControllerSegue", sender: self)
//        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceNameCell", for: indexPath) as! WMakePlaceNameCell
            cell.cellText = placeName
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.address.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAddressCell", for: indexPath) as! WMakePlaceAddressCell
            cell.delegate = self
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.location.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceCoordinatesCell", for: indexPath)
            return cell
        }
        else if indexPath.section == WMakePlaceControllerSection.phoneNumber.rawValue {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlacePhoneNumberCell", for: indexPath) as! WMakePlacePhoneNumberCell
                cell.delegate = self
                if placePhoneNumbers.count > 0 {
                    cell.cellPhoneNumber = placePhoneNumbers[0]
                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAdditionalPhoneNumberCell", for: indexPath) as! WMakePlaceAdditionalPhoneNumberCell
                cell.delegate = self
                cell.cellIndexPath = indexPath
                if placePhoneNumbers.count > indexPath.row {
                    cell.cellText = placePhoneNumbers[indexPath.row]
                }
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
                cell.cellFromInputView = fromDatePicker
                cell.cellTillInputView = tillDatePicker
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WMakePlaceAdditionalWorkingHoursCell", for: indexPath) as! WMakePlaceAdditionalWorkingHoursCell
                cell.delegate = self
                return cell
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDelegate
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == WMakePlaceControllerSection.location.rawValue {
            performSegue(withIdentifier: "WMapViewControllerSegue", sender: self)
        }
        else if indexPath.section == WMakePlaceControllerSection.workingDays.rawValue {
            performSegue(withIdentifier: "WDaysControllerSegue", sender: self)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakePlacePhoneNumberCellDelegate
    
    func phoneNumberCellAccessoryButtonTapped(cell: WMakePlacePhoneNumberCell) {
        if placePhoneNumbers.count ==  numberOfPhoneNumberCells {
            numberOfPhoneNumberCells += 1
            tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.phoneNumber.rawValue), with: .automatic)
        }
        print(placePhoneNumbers)
    }
    
    func phoneNumberCellDidChange(phoneNumber: String?) {
        if let unwrapped = phoneNumber {
            if placePhoneNumbers.count > 0 {
                placePhoneNumbers[0] = unwrapped
            }
            else{
                placePhoneNumbers.append(unwrapped)
            }
        }
        else {
            if placePhoneNumbers.count > 0 {
                placePhoneNumbers.remove(at: 0)
            }
        }
        print(placePhoneNumbers)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakePlaceAdditionalPhoneNumberCellDelegate
    
    func additionalPhoneNumberCellAccessoryButtonTapped(at indexPath: IndexPath) {
        if placePhoneNumbers.count > indexPath.row {
            placePhoneNumbers.remove(at: indexPath.row)
        }
        numberOfPhoneNumberCells -= 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.phoneNumber.rawValue), with: .automatic)
        print(placePhoneNumbers)
    }
    
    func additionalPhoneNumberCellDidChange(phoneNumber: String?, at indexPath: IndexPath) {
        if let unwrapped = phoneNumber {
            if placePhoneNumbers.count > indexPath.row {
                placePhoneNumbers[indexPath.row] = unwrapped
            }
            else{
                placePhoneNumbers.append(unwrapped)
            }
        }
        else {
            if placePhoneNumbers.count > indexPath.row {
                placePhoneNumbers.remove(at: indexPath.row)
            }
        }
        print(placePhoneNumbers)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakePlaceWorkingHoursCellDelegate
    
    func workingHoursCellAccessoryButtonTapped(cell: WMakePlaceWorkingHoursCell) {
        numberOfWorkingHourCells += 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.workinghours.rawValue), with: .automatic)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakePlaceAdditionalWorkingHoursCellDelegate
    
    func additionalWorkingHoursCellAccessoryButtonTapped(cell: WMakePlaceAdditionalWorkingHoursCell) {
        numberOfWorkingHourCells -= 1
        tableView.reloadSections(IndexSet(integer: WMakePlaceControllerSection.workinghours.rawValue), with: .automatic)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMakePlaceAddressCellDelegate
    
    func makePlaceAddressCellDidChangeEditing(text: String) {
        placeAddress = text
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WMapViewControllerDelegate
    
    func mapViewController(didFinishWith location: CLLocation) {
        placeLocation = location
        let cell : WMakePlaceCoordinatesCell = tableView.cellForRow(at: IndexPath(row: 0, section: WMakePlaceControllerSection.location.rawValue)) as! WMakePlaceCoordinatesCell
        
        let lat = placeLocation!.coordinate.latitude
        let condensedLat = Double(round(100000*lat)/100000)
        
        let log = placeLocation!.coordinate.longitude
        let condensedlog = Double(round(100000*log)/100000)
        
        cell.cellText = "\(condensedLat), \(condensedlog)"
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - WDaysControllerDelegate
    
    func daysController(didFinishWith workingDays: [Int]) {
        placeWorkingDays = workingDays
        var string = ""
        placeWorkingDays.sort()
        
        for day in placeWorkingDays {
            let dateFormater = DateFormatter()
            let daySymbols = dateFormater.standaloneWeekdaySymbols
            let dayName = daySymbols?[day]
            if string.length > 0 {
                string += ", \(dayName!)"
            }
            else{
                string += dayName!
            }
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: WMakePlaceControllerSection.workingDays.rawValue)) as! WMakePlaceWorkingDaysCell
        cell.cellText = string
    }
    
}
