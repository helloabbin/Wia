//
//  WImagePickerCell.swift
//  Wia
//
//  Created by Abbin Varghese on 31/12/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

import UIKit

class WImagePickerCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var selectView: UIView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage? {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func selectCell() {
        selectView.layer.borderColor = WColor.openGreen.cgColor
        selectView.layer.borderWidth = 5
        selectView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
    }
    
    func deSelectCell() {
        selectView.layer.borderColor = WColor.clear.cgColor
        selectView.layer.borderWidth = 0
        selectView.backgroundColor = UIColor.init(white: 1, alpha: 0.0)
    }
    
}
