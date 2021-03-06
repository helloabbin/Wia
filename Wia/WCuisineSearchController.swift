//
//  WCuisineSearchController.swift
//  Wia
//
//  Created by Abbin Varghese on 06/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import CloudKit

protocol WCuisineSearchControllerDelegate {
    func cuisineSearchController(didFinishWith cuisine: CKRecord)
}

class WCuisineSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var searchTableView: UITableView!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variables
    
    var searchController: UISearchController!
    var resultsArray = [AnyObject]()
    var delegate: WCuisineSearchControllerDelegate?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "name of this cuisine"
        searchController.searchBar.delegate = self
        
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
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Actions
    
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
            WManager.searchCuisines(searchText: text) { (results, searchedString) in
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
    // MARK: - UISearchResultsUpdating
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WCuisineSearchCell", for: indexPath) as! WCuisineSearchCell
        
        let resultObj = resultsArray[indexPath.row]
        
        if let text = resultObj as? String {
            cell.cellText = "Add '\(text)' as a new Cuisine"
        }
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let resultObj = resultsArray[indexPath.row]
        
        if let text = resultObj as? String {
            
            let cell = tableView.cellForRow(at: indexPath) as! WCuisineSearchCell
            cell.startAnimating()
            
            WManager.newCuisine(name: text, completionHandler: { (cuisine, error) in
                if let unwrapped = cuisine {
                    cell.stopAnimating()
                    self.searchController.dismiss(animated: false, completion: {
                        self.dismiss(animated: true, completion: {
                            self.delegate?.cuisineSearchController(didFinishWith: unwrapped)
                        })
                    })
                }
                else{
                    self.simpleAlert(title: "Somthing went wrong", message: error?.localizedDescription)
                }
            })
        }
    }
    
}
