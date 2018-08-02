//
//  HomeViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    lazy private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController:  nil)
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        return searchController
    }()
    
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var searchButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //definesPresentationContext = true
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.leftBarButtonItems = []
            self.navigationItem.rightBarButtonItems = []
            self.navigationItem.titleView = self.searchController.searchBar
            self.searchController.searchBar.becomeFirstResponder()
        })
    }
    
}

extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.leftBarButtonItems = [self.shareButton]
            self.navigationItem.rightBarButtonItems = [self.searchButton]
            self.navigationItem.titleView = nil
        })
    }
}

