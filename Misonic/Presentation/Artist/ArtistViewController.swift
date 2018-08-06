//
//  ArtistViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController, StoryboardLoadable {
    static var sourceStoryboard: Storyboard = .main

    var dataModel: ArtistScreenDataModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let headerSection = 0
    private let albumsSection = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        dataModel.delegate = self
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataModel.startLoadingData()
    }
    
    func registerCells() {
        collectionView.register(cellType: ArtistHeaderCell.self)
    }
    
    func reloadData() {
        collectionView.isHidden = dataModel.artist == nil
        collectionView.reloadData()
    }
}

extension ArtistViewController: ArtistScreenDataModelDelegate {
    func dataUpdated() {
        reloadData()
    }
}

extension ArtistViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case headerSection: return 1
        case albumsSection: return dataModel.albums.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case headerSection:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ArtistHeaderCell.self)
            return cell
        
        case albumsSection:
            return UICollectionViewCell()

        default:
            return UICollectionViewCell()
        }
    }
    
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case headerSection:
            let width = view.frame.size.width
            let height = width
            return CGSize(width: width, height: height)

        case albumsSection:
            let width = view.frame.size.width / 2
            let height = width
            return CGSize(width: width, height: height)
            
        default:
            return CGSize.zero
        }
    }
}
