//
//  WImagePickerController.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit
import Photos

class WImagePickerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var cameraItem: UIBarButtonItem!
    @IBOutlet weak var nextItem: UIBarButtonItem!
    @IBOutlet weak var libraryUnavailableMessage: UIView!
    
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    fileprivate var cellSize: CGSize!
    fileprivate var selectedAssets = [PHAsset]()
    
    fileprivate var imageManager: PHCachingImageManager!
    
    fileprivate let status = PHPhotoLibrary.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if status == .authorized || status == .notDetermined {
            
            imageManager = PHCachingImageManager()
            
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let bobPredicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            allPhotosOptions.predicate = bobPredicate
            
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
            imageCollectionView.reloadData()
            
            PHPhotoLibrary.shared().register(self)
        }
        else {
            libraryUnavailableMessage.isHidden = false
        }
        
        let scale = UIScreen.main.scale
        var cellWidth :CGFloat
        let screenWidth = UIScreen.main.bounds.size.width
        
        if screenWidth >= 375.0 { // 4.7" screen or bigger
            cellWidth = (screenWidth/4) - 1
        }
        else {
            cellWidth = (screenWidth/3) - 1
        }
        
        cellSize = CGSize.init(width: cellWidth, height: cellWidth)
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let scale = UIScreen.main.scale
        let cellSize = (imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    deinit {
        if status == .authorized || status == .notDetermined {
            PHPhotoLibrary.shared().unregisterChangeObserver(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func cancelPicker(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if status == .authorized || status == .notDetermined {
            return fetchResult.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WImagePickerCell", for: indexPath) as! WImagePickerCell
        
        cell.representedAssetIdentifier = asset.localIdentifier
        
        if selectedAssets.contains(asset) {
            cell.selectCell()
        }
        else{
            cell.deSelectCell()
        }
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WImagePickerCell
        let asset = fetchResult[indexPath.row]
        
        if selectedAssets.contains(asset) {
            selectedAssets.remove(at: selectedAssets.index(of: asset)!)
            cell.deSelectCell()
        }
        else {
            if selectedAssets.count < 3 {
                selectedAssets.append(asset)
                cell.selectCell()
            }
        }
        
        if selectedAssets.count > 2 {
            cameraItem.isEnabled = false
        }
        else{
            cameraItem.isEnabled = true
        }
        
        if selectedAssets.count > 0 {
            nextItem.isEnabled = true
        }
        else{
            nextItem.isEnabled = false
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

}

extension WImagePickerController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        DispatchQueue.main.sync {
            fetchResult = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                
                guard let collectionView = self.imageCollectionView else { fatalError() }
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, removed.count > 0 {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                        
                        for asset in changes.insertedObjects {
                            let resource : PHAssetResource = PHAssetResource.assetResources(for: asset).first!
                            let name : String = resource.originalFilename
                            if name[0 ..< 3] == "WIA" {
                                self.selectedAssets.append(asset)
                            }
                        }
                        
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                imageCollectionView!.reloadData()
            }
        }
    }
}
