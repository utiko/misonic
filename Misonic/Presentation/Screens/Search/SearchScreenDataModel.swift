//
//  SearchScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/5/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

protocol SearchScreenDataModelDelegate: class {
    func searchResultUpdated()
    func searchFailure(with errorMessage: String?)
}

class SearchScreenDataModel {

    public weak var delegate: SearchScreenDataModelDelegate?

    private var results: [Artist] = []
    private var qurrentQuery: String?
    
    public func search(with query: String) {
        qurrentQuery = query
        
        let searchArtists = ArtistSearchRequest { [weak self] (result) in
            switch result {
            case .success(let response):
                // Prevent show old results
                guard self?.qurrentQuery == query else { return }
                
                self?.results = response.results.artistmatches.artists.filter {
                    !$0.artistID.isEmpty
                }
                
                self?.delegate?.searchResultUpdated()

            case .errorResponse(let serverError):
                // Handle server error
                self?.delegate?.searchFailure(with: serverError.message)

            case .error(let error):
                // Handle behavior error
                self?.delegate?.searchFailure(with: error?.localizedDescription)
            }
        }
        searchArtists.searchQuery = query
        searchArtists.perform()
    }
    
    public func artistsCount() -> Int {
        return results.count
    }
    
    public func artist(at index: Int) -> Artist {
        return results[index]
    }
    
}
