//
//  ArtistViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class ArtistViewController: UIViewController, StoryboardLoadable {
    static var sourceStoryboard: Storyboard = .main

    var dataModel: ArtistScreenDataModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let headerSection = 0
    private let albumsSection = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.Misonic.background
        registerNibs()
        dataModel.delegate = self
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataModel.startLoadingData()
    }
    
    func registerNibs() {
        collectionView.register(cellType: ArtistHeaderCell.self)
        collectionView.register(cellType: ArtistAlbumCell.self)
        collectionView.register(supplementaryViewType: CollectionSectionHeaderView.self,
                                ofKind: UICollectionElementKindSectionHeader)
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
            if let artist = dataModel.artist {
                cell.configure(with: artist)
            }
            return cell
        
        case albumsSection:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ArtistAlbumCell.self)
            let album = dataModel.albums[indexPath.row]
            cell.configure(with: album)
            return cell

        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case albumsSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CollectionSectionHeaderView.self)
            headerView.title = "Albums"
            return headerView

        default:
            return UICollectionReusableView(frame: CGRect.zero)
        }
    }
    
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == albumsSection else { return }
        
        let album = dataModel.albums[indexPath.row]
        let albumDataModel = AlbumScreenDataModel(albumID: album.albumID)
        let vc = AlbumViewController.loadFromStoryboard()
        vc.dataModel = albumDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case headerSection:
            return ArtistHeaderCell.size(for: collectionView)

        case albumsSection:
            return ArtistAlbumCell.size(for: collectionView)
            
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case albumsSection: return CGSize(width: collectionView.frame.size.width, height: 50)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case albumsSection:
            return UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.adjustedContentInset.top + scrollView.contentOffset.y
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: headerSection)) as? ArtistHeaderCell {
            cell.updateParalax(forPosition: scrollPosition)
            
            navigationItem.title = scrollPosition > cell.frame.size.height - 20
                ? dataModel.artist?.name
                : ""
        }
    }

}
