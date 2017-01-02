//
//  WPlaceSearchController.swift
//  Wia
//
//  Created by Abbin Varghese on 02/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

class WPlaceSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var searchTableView: UITableView!
    
    var searchController: UISearchController!
    var resultsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelPlaceSearchController(_:)))
        navigationItem.leftBarButtonItem = back
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "name of the place"
        
        navigationItem.titleView = searchController.searchBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(showKeyboard(_:)), with: self, afterDelay: 0.1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func showKeyboard(_ sender: Any) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func cancelPlaceSearchController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        if text.length > 0 {
            WManager.searchItems(searchText: text) { (results, searchedString) in
                if results.count > 0 {
                    resultsArray = results
                }
                else{
                    resultsArray.removeAll()
                    resultsArray.append(searchedString as AnyObject)
                }
                searchTableView.reloadData()
            }
        }
        else{
            resultsArray.removeAll()
            searchTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WPlaceSearchControllerCell", for: indexPath)
        
        let resultObj = resultsArray[indexPath.row]
        
        if let text = resultObj as? String {
            cell.textLabel?.text = "Add '\(text)' as a new Place"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultObj = resultsArray[indexPath.row]
        
        if resultObj is String {
            performSegue(withIdentifier: "WMakePlaceControllerSegue", sender: self)
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
