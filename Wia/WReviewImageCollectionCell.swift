//
//  WReviewImageCollectionCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import Photos

class WReviewImageCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var selectedAssets: [PHAsset]!
    fileprivate var imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize = CGSize.zero

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = selectedAssets[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WReviewImageCell", for: indexPath) as! WReviewImageCell
        cell.representedAssetIdentifier = asset.localIdentifier
        
        let height = Int(collectionView.frame.size.height)
        let scale = UIScreen.main.scale
        let size = CGSize.init(width: height * asset.pixelWidth/asset.pixelHeight, height: height)
        thumbnailSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let asset = selectedAssets[indexPath.row]
        
        let height = Int(collectionView.frame.size.height)
        let size = CGSize.init(width: height * asset.pixelWidth/asset.pixelHeight, height: height)
        
        return size
    }

}
