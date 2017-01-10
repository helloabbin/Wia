//
//  WRatingCell.swift
//  Wia
//
//  Created by Abbin Varghese on 05/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit

protocol WRatingCellDelegate {
    func ratingCellDidChange(rating: Double)
}

class WRatingCell: UITableViewCell {
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBOutlet
    
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var fiveView: UIView!
    @IBOutlet weak var sixView: UIView!
    @IBOutlet weak var sevenView: UIView!
    @IBOutlet weak var eightView: UIView!
    @IBOutlet weak var nineView: UIView!
    @IBOutlet weak var tenView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var panView: UIView!
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Variable
    
    var delegate: WRatingCellDelegate?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - IBAction
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.location(in: panView)
            updateView(value: (translation.x / panView.frame.size.width) * 10)
        }
    }
    
    @IBAction func handleTap(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let translation = gestureRecognizer.location(in: panView)
            updateView(value: (translation.x / panView.frame.size.width) * 10)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Cell Life Cycyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panView.addGestureRecognizer(gestureRecognizer)
        
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        panView.addGestureRecognizer(tapgestureRecognizer)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Other Methods
    
    func updateView(value : CGFloat) {
        if value > 9 {
            tenView.backgroundColor = WColor.colorFor(value: value)
            nineView.backgroundColor = WColor.colorFor(value: 9)
            eightView.backgroundColor = WColor.colorFor(value: 8)
            sevenView.backgroundColor = WColor.colorFor(value: 7)
            sixView.backgroundColor = WColor.colorFor(value: 6)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "5.0"
            delegate?.ratingCellDidChange(rating: 5.0)
        }
        else if value > 8 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = WColor.colorFor(value: 9)
            eightView.backgroundColor = WColor.colorFor(value: 8)
            sevenView.backgroundColor = WColor.colorFor(value: 7)
            sixView.backgroundColor = WColor.colorFor(value: 6)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "4.5"
            delegate?.ratingCellDidChange(rating: 4.5)
        }
        else if value > 7 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = WColor.colorFor(value: 8)
            sevenView.backgroundColor = WColor.colorFor(value: 7)
            sixView.backgroundColor = WColor.colorFor(value: 6)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "4.0"
            delegate?.ratingCellDidChange(rating: 4.0)
        }
        else if value > 6 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = WColor.colorFor(value: 7)
            sixView.backgroundColor = WColor.colorFor(value: 6)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "3.5"
            delegate?.ratingCellDidChange(rating: 3.5)
        }
        else if value > 5 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = WColor.colorFor(value: 6)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "3.0"
            delegate?.ratingCellDidChange(rating: 3.0)
        }
        else if value > 4 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fiveView.backgroundColor = WColor.colorFor(value: 5)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "2.5"
            delegate?.ratingCellDidChange(rating: 2.5)
        }
        else if value > 3 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fiveView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fourView.backgroundColor = WColor.colorFor(value: 4)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "2.0"
            delegate?.ratingCellDidChange(rating: 2.0)
        }
        else if value > 2 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fiveView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fourView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            threeView.backgroundColor = WColor.colorFor(value: 3)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "1.5"
            delegate?.ratingCellDidChange(rating: 1.5)
        }
        else if value > 1 {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fiveView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fourView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            threeView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            twoView.backgroundColor = WColor.colorFor(value: 2)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "1.0"
            delegate?.ratingCellDidChange(rating: 1.0)
        }
        else {
            tenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            nineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            eightView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sevenView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            sixView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fiveView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            fourView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            threeView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            twoView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            oneView.backgroundColor = WColor.colorFor(value: 1)
            ratingLabel.text = "0.5"
            delegate?.ratingCellDidChange(rating: 0.5)
        }
    }

}
