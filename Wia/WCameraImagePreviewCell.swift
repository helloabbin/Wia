//
//  WCameraImagePreviewCell.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit

class WCameraImagePreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage? {
        didSet {
            cellImageView.image = thumbnailImage
        }
    }
}
