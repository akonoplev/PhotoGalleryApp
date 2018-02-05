//
//  GalleryViewController.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 04.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var album: AlbumModel?
    var selectedPhoto: UIImage!
    let picker = UIImagePickerController()
    
    @IBAction func cameraButtonTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.isEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .pageSheet
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    fileprivate let insetForSection: CGFloat = 1
    fileprivate let insetBetweenCells: CGFloat = 1
    fileprivate let numberOfItemsInLine = 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registrate()
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.album?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.configure(image: (self.album?.photos[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = self.album?.photos[indexPath.row]
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedPhoto = choosenImage
        performSegue(withIdentifier: "filterSegue", sender: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = insetForSection*2 + CGFloat(numberOfItemsInLine-1) * insetBetweenCells
        let size = (collectionView.frame.width - inset) / CGFloat(numberOfItemsInLine)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetForSection, left: insetForSection, bottom: insetForSection, right: insetForSection)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetBetweenCells
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetBetweenCells
    }
    
    
}

extension GalleryViewController {
    func registrate() {
        self.navigationItem.title = self.album?.name
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "photoCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "filterSegue", let dest = segue.destination as? FilterVC {
            guard let image = selectedPhoto else { return }
            dest.image = image
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}



