//
//  WDaysController.swift
//  Wia
//
//  Created by Abbin Varghese on 10/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WDaysControllerDelegate {
    func daysController(didFinishWith workingDays: [Int])
}

class WDaysController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum WDaysControllerRow: Int {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    @IBOutlet weak var closeContainerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: WDaysControllerDelegate?
    
    var daysArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        closeContainerView.layer.shadowOpacity = 1.0
        closeContainerView.layer.shadowOffset = CGSize.zero
        closeContainerView.layer.shadowRadius = 1.0
        
        doneButton.backgroundColor = WColor.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneWithController(_ sender: Any) {
        if daysArray.count > 0 {
            dismiss(animated: true, completion: { 
                self.delegate?.daysController(didFinishWith: self.daysArray)
            })
        }
    }
    
    @IBAction func cancelController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WDaysControllerCell", for: indexPath)
        
        switch indexPath.row {
        case WDaysControllerRow.sunday.rawValue:
            cell.textLabel?.text = "Sunday"
        case WDaysControllerRow.monday.rawValue:
            cell.textLabel?.text = "Monday"
        case WDaysControllerRow.tuesday.rawValue:
            cell.textLabel?.text = "Tuesday"
        case WDaysControllerRow.wednesday.rawValue:
            cell.textLabel?.text = "Wednesday"
        case WDaysControllerRow.thursday.rawValue:
            cell.textLabel?.text = "Thursday"
        case WDaysControllerRow.friday.rawValue:
            cell.textLabel?.text = "Friday"
        case WDaysControllerRow.saturday.rawValue:
            cell.textLabel?.text = "Saturday"
        default: break
        }
        
        if daysArray.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)
        if daysArray.contains(indexPath.row) {
            daysArray.remove(at: daysArray.index(of: indexPath.row)!)
            cell?.accessoryType = .none
        }
        else {
            daysArray.append(indexPath.row)
            cell?.accessoryType = .checkmark
        }
    }

}
