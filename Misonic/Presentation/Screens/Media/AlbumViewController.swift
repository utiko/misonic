//
//  AlbumViewController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class AlbumViewController: UIViewController, StoryboardLoadable {

    static var sourceStoryboard: Storyboard = .media

    var dataModel: AlbumScreenDataModel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let headerSection = 0
    private let tracksSection = 1
    
    private weak var albumImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCells()
        
        dataModel.delegate = self
        dataModel.startLoadingData()

        collectionView.isHidden = dataModel.album == nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func registerCells() {
        collectionView.register(cellType: AlbumHeaderCell.self)
        collectionView.register(cellType: AlbumTrackCell.self)
        collectionView.register(supplementaryViewType: CollectionSectionHeaderView.self,
                                ofKind: UICollectionElementKindSectionHeader)
    }
    
    private func reloadData() {
        collectionView.isHidden = dataModel.album == nil
        collectionView.reloadData()
        
        var buttons = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(options))]
        if dataModel.isInMyLibrary == false {
            buttons.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(saveAlbum)))
        }
        
        navigationItem.rightBarButtonItems = buttons
    }
    
    @objc private func saveAlbum() {
        dataModel.saveAlbumToMyLibrary()
    }
    
    @objc private func options() {
        let dialog = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        if dataModel.isInMyLibrary == true {
            dialog.addAction(UIAlertAction(title: "Remove from library", style: .destructive, handler: { [weak self] _ in
                self?.dataModel.removeAlbumFromMyLibrary()
            }))
        }
        
        dialog.addAction(UIAlertAction(title: "View artist", style: .default, handler: { [weak self] _ in
            guard let artistID = self?.dataModel.album?.artist.artistID else { return }
            
            let screenModel = ArtistScreenDataModel(artistID: artistID)
            let vc = ArtistViewController.loadFromStoryboard()
            vc.dataModel = screenModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(dialog, animated: true, completion: nil)
    }
    
}

extension AlbumViewController: ScreenDataModelDelegate {
    func dataUpdated() {
        reloadData()
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard dataModel.album != nil else { return 0 }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case headerSection: return 1
        case tracksSection: return dataModel.album?.tracks.count ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let album = dataModel.album else {
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case headerSection:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumHeaderCell.self)
            cell.configure(with: album)
            albumImageView = cell.albumImageView
            return cell
            
        case tracksSection:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AlbumTrackCell.self)
            let track = album.tracks[indexPath.row]
            cell.configure(with: track)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case tracksSection:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: CollectionSectionHeaderView.self)
            headerView.title = "Tracks"
            return headerView
            
        default:
            return UICollectionReusableView(frame: CGRect.zero)
        }
    }
}

extension AlbumViewController: TransitionImageAnimationing {
    func animatableImageView(for transitionType: TransitionImageAnimation.TransitionType) -> UIImageView? {
        switch transitionType {
        case .child:
            return nil
        case .parent:
            return albumImageView
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case headerSection:
            return AlbumHeaderCell.size(for: collectionView)

        case tracksSection:
            return AlbumTrackCell.size(for: collectionView)

        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case tracksSection: return CGSize(width: collectionView.frame.size.width, height: 50)
        default: return .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.adjustedContentInset.top + scrollView.contentOffset.y
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: headerSection)) as? AlbumHeaderCell {
            cell.updateParalax(forPosition: scrollPosition)
            
            navigationItem.title = scrollPosition > cell.frame.size.height - 20
                ? dataModel.album?.name
                : ""
        }
    }
}
