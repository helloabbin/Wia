//
//  WItemSearchController.swift
//  Wia
//
//  Created by Abbin Varghese on 01/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import Photos

class WItemSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var searchTableView: UITableView!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var selectedAssets: [PHAsset]!
    
    var searchController: UISearchController!
    var resultsArray = [AnyObject]()
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(cancelItemSearchController(_:)))
        navigationItem.leftBarButtonItem = back
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "name of this dish"
        
        navigationItem.titleView = searchController.searchBar
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        searchTableView.keyboardDismissMode = .interactive
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WMakeItemControllerSegue" {
            let controller = segue.destination as! WMakeItemController
            if let unWrapped = searchController.searchBar.text?.cleaned {
                controller.itemName = unWrapped
                controller.selectedAssets = selectedAssets
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
    func cancelItemSearchController(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func showKeyboard(_ sender: Any) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UISearchResultsUpdating
    
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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WItemSearchControllerCell", for: indexPath)
        
        let resultObj = resultsArray[indexPath.row]
        
        if let text = resultObj as? String {
            cell.textLabel?.text = "Add '\(text)' as a new Item"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultObj = resultsArray[indexPath.row]
        
        if resultObj is String {
            performSegue(withIdentifier: "WMakeItemControllerSegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "WReviewControllerSegue", sender: self)
        }
    }
}
