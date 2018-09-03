//
//  SearchViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class SearchViewController: UIViewController, StoryboardLoadable {

    static var sourceStoryboard: Storyboard = .home
    
    var dataModel = SearchScreenDataModel()
    
    @IBOutlet private weak var searchBar: UISearchBar!
    private weak var searchBarWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        //navigationItem.titleView = searchBar
        searchBar.layoutIfNeeded()
        searchBar.becomeFirstResponder()

        dataModel.delegate = self
        
        setupConstraints()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBarWidthConstraint.constant = view.frame.size.width - 50
        navigationItem.titleView?.layoutIfNeeded()
    }
    
    func registerCells() {
        tableView.register(cellType: SearchResultArtistCell.self)
    }
    
    func setupConstraints() {
        searchBarWidthConstraint = navigationItem.titleView?.widthAnchor.constraint(equalToConstant: 60)
        searchBarWidthConstraint.isActive = true
        
        navigationItem.titleView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchResultArtistCell.self) 
        
        let artist = dataModel.artist(at: indexPath.row)
        cell.configure(with: artist)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = dataModel.artist(at: indexPath.row)
        let screenModel = ArtistScreenDataModel(artistID: artist.artistID)
        let vc = ArtistViewController.loadFromStoryboard()
        vc.dataModel = screenModel
        navigationController?.pushViewController(vc, animated: true)
    }    
}

extension SearchViewController: SearchScreenDataModelDelegate {
    func dataUpdated() {
        reloadData()
    }
    
    func searchFailure(with errorMessage: String?) {
        // TODO: Handle error
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
