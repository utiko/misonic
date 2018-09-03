//
//  HomeViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class HomeViewController: UIViewController {

    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyStateView: UIView!
    
    private var dataModel = HomeScreenDataModel()
    
    private var selectedAlbumIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.delegate = self
        
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataModel.startLoadingData()
    }
    
    private func registerCells() {
        collectionView.register(cellType: AlbumItemCell.self)
        collectionView.register(supplementaryViewType: CollectionSectionHeaderView.self,
                                ofKind: UICollectionElementKindSectionHeader)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let vc = SearchViewController.loadFromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: ScreenDataModelDelegate {
    func dataUpdated() {
        emptyStateView.isHidden = dataModel.albumGroups.count > 0
        collectionView.isHidden = dataModel.albumGroups.count == 0
        collectionView.reloadData()
    }
}

extension HomeViewController: TransitionImageAnimationing {
    func animatableImageView(for transitionType: TransitionImageAnimation.TransitionType) -> UIImageView? {
        switch transitionType {
        case .child:
            if let indexPath = selectedAlbumIndexPath,
                let cell = collectionView.cellForItem(at: indexPath) as? AlbumItemCell {
                return cell.albumImageView
            }
            return nil

        case .parent:
            return nil
            
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataModel.albumGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.albumGroups[section].albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumItemCell.self)
        let album = dataModel.albumGroups[indexPath.section].albums[indexPath.item]
        cell.configure(with: album)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CollectionSectionHeaderView.self)
        let albumGroup = dataModel.albumGroups[indexPath.section]
        headerView.title = albumGroup.artistName
        return headerView
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AlbumItemCell.size(for: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Prepare imageView for transition
        selectedAlbumIndexPath = indexPath
        
        // Open album
        let album = dataModel.albumGroups[indexPath.section].albums[indexPath.item]
        let albumDataModel = AlbumScreenDataModel(album: album)
        let vc = AlbumViewController.loadFromStoryboard()
        vc.dataModel = albumDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
