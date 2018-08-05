//
//  SearchViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var dataModel = SearchDataModel()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        //searchBar.showsCancelButton = true
        searchBar.barStyle = .blackTranslucent
        return searchBar
    }()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        searchBar.layoutIfNeeded()
        
        dataModel.delegate = self
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Data
    
    func reloadData() {
        let emptyQuery = searchBar.text == ""
        let noResult = dataModel.artistsCount() == 0
        
        tableView.isHidden = emptyQuery || noResult
        emptyStateView.isHidden = emptyQuery || !noResult
        
        if !noResult {
            tableView.reloadData()
        }
    }
    
    // MARK: - Appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.artistsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultArtistCell") as? SearchResultArtistCell else {
            fatalError("SearchResultArtistCell not registered")
        }
        
        let artist = dataModel.artist(at: indexPath.row)
        cell.configure(with: artist)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: SearchDataModelDelegate {
    func searchResultUpdated() {
        reloadData()
    }
    
    func searchFailure(with errorMessage: String?) {
        // handle error
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            reloadData()
            return
        }
        dataModel.search(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
