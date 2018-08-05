//
//  SearchDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/5/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

protocol SearchDataModelDelegate: class {
    func searchResultUpdated()
    func searchFailure(with errorMessage: String?)
}

class SearchDataModel {
    
    private var results: [Artist] = []
    
    public weak var delegate: SearchDataModelDelegate?
    
    public func search(with query: String) {
        let searchArtists = ArtistSearchRequest { [weak self] (response) in
            switch response {
            case .success(let result):
                self?.results = result.results.artistmatches.artists
                self?.delegate?.searchResultUpdated()

            case .successWithError(let serverError):
                self?.delegate?.searchFailure(with: serverError.message)

            case .error(let error):
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
