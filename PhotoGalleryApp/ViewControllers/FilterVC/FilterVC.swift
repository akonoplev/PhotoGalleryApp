//
//  FilterVC.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 02.02.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    var image: UIImage?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        photoImage.image = image
        
        createButtons()
        
    }


}

extension FilterVC {
    func createButtons() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        var items = 0
        for i in 0..<CIFilterNames.count {
            items = i
            let filterButton = UIButton(type: . custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = i
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image:photoImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter?.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
//            let ciContext = CIContext(options: nil)
//            let coreImage = CIImage(image: photoImage.image!)
//            let filter = CIFilter(name: "\(CIFilterNames[i])" )
//            filter!.setDefaults()
//            filter!.setValue(coreImage, forKey: kCIInputImageKey)
//            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
//            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
//            let imageForButton = UIImage(cgImage: filteredImageRef!)
//            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            xCoord += (buttonWidth + gapBetweenButtons)
            scrollView.addSubview(filterButton)
        }
        scrollView.contentSize = CGSize(width: buttonWidth * CGFloat(items + 2), height: yCoord)
    }
    
    @objc func filterButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        filterImage.image = button.backgroundImage(for: .normal)
    }

}
