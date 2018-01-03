//
//  AlbumCell.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 03.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albomImage: UIImageView!
    @IBOutlet weak var albomNameLabel: UILabel!
    @IBOutlet weak var photosCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(albomModel: AlbumModel) {
        self.albomNameLabel.text = albomModel.name
        self.photosCountLabel.text = String(albomModel.photos.count) + " фото"
        self.albomImage.image = albomModel.photos.last
    }

    
}
