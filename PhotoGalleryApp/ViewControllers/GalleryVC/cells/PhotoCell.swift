//
//  PhotoCell.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 04.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(image: UIImage) {
        self.photoImage.image = image
    }

}
