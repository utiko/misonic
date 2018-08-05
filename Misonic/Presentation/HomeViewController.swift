//
//  HomeViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let searchArtists = ArtistSearchRequest { (response) in
            switch response {
            case .success(let result):
                if let firs = result.results.artistmatches.artists.first {
                    DatabaseProvider.addArtist(artist: firs, completion: { (_) in
                        
                    })
                }
                print(result)
            case .successWithError(let serverError):
                print(serverError.message)
            case .error(let error):
                print(error ?? "Unknown error")
            }
        }
        searchArtists.searchQuery = "Dakh"
        searchArtists.perform()*/
        
        //definesPresentationContext = true
    }
    
}
