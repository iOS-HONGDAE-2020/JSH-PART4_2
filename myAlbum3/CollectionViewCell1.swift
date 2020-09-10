//
//  CollectionViewCell1.swift
//  myAlbum3
//
//  Created by 정수현 on 2020/09/09.
//  Copyright © 2020 정수현. All rights reserved.
//

import UIKit

class CollectionViewCell1: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }
    static let identifier = "CollectionViewCell1"
     
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell1", bundle: nil)
    }
}
