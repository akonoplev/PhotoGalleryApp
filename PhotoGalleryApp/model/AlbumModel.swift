//
//  File.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 03.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import Photos

class AlbumModel {
    let name: String
    let count: Int
    let photos: [UIImage]
    
    init(name: String, count: Int, photos: [UIImage]) {
        self.name = name
        self.count = count
        self.photos = photos
    }
}
