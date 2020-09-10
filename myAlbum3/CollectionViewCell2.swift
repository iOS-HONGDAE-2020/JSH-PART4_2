//
//  CollectionViewCell2.swift
//  myAlbum3
//
//  Created by 정수현 on 2020/09/09.
//  Copyright © 2020 정수현. All rights reserved.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            highlightIndicator.layer.borderColor = UIColor.darkGray.cgColor
            highlightIndicator.layer.borderWidth = 3
        }
    }

    static let identifier = "CollectionViewCell2"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell2", bundle: nil)
    }
    
    
}
