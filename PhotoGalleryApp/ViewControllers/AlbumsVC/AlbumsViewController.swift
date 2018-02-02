//
//  AlbumsViewController.swift
//  PhotoGalleryApp
//
//  Created by Андрей Коноплев on 03.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import Photos

class AlbumsViewController: UIViewController {
    

    var albums = [AlbumModel]()
    var albumIndex = 0
    var textField = UITextField()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrate()
        setupPhotos()
    }

}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        cell.configure(albomModel: albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        albumIndex = indexPath.row
        performSegue(withIdentifier: "inGallery", sender: self)
        return indexPath
    }
}

extension AlbumsViewController {
    func registrate() {
        let nib = UINib(nibName: "AlbumCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "albumCell")
        self.navigationItem.title = "Альбомы"
        self.textField.keyboardType = .default
    }
    //MARK: get albums and photos
    private func setupPhotos() {
        let fetchOptions = PHFetchOptions()
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        
        let topLevelfetchOptions = PHFetchOptions()
        
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: topLevelfetchOptions)
        
        let allAlbums = [topLevelUserCollections, smartAlbums] as! [PHFetchResult<AnyObject>]
        
        for i in 0 ..< allAlbums.count {
            let result = allAlbums[i]
            
            result.enumerateObjects({ (asset, index, stop) in
                if let a = asset as? PHAssetCollection {
                    let opts = PHFetchOptions()
    
                    let ass = PHAsset.fetchAssets(in: a, options: opts)
                    if ass.count > 0 {
                        var photos = [UIImage]()
                        for i in 0...ass.count - 1 {
                            let obj = ass[i]
                            let imageOption = PHImageRequestOptions()
                            
                            
                            PHImageManager.default().requestImage(for: obj, targetSize: CGSize(width: 500, height: 700) , contentMode: .aspectFill, options: imageOption, resultHandler: { (image, nil) in
                                guard let images = image else { return }
                                photos.append(images)
                                
                            })
                        }
                        let newAlbom = AlbumModel(name: a.localizedTitle!, count: ass.count, photos: photos)
                        self.albums.append(newAlbom)
                    }
                }
            })
            
        }
        self.tableView.reloadData()
    }
}

//MARK: prepare segue
extension AlbumsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "inGallery", let dest = segue.destination as? GalleryViewController {
            dest.album = albums[albumIndex]
        }
    }
}
//MARK: - get name for new library and create
extension AlbumsViewController {
    func configureTextField(textField: UITextField!) {
        if let tField = textField {
            self.textField = tField
        }
    }
    
    @IBAction func addNewLibrary(_ sender: Any) {
        let alert = UIAlertController(title: "Новый альбом", message: "Введите имя нового альбома", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configureTextField)
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { (UIAlertAction) in }))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { (UIAlertAction) in
            self.createNewLibrary(title: self.textField.text ?? "")
        }))
        self.present(alert, animated: true) {}
    }
    
    func createNewLibrary(title: String) {
        if title != "" {
            var placeholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = request.placeholderForCreatedAssetCollection
            }, completionHandler: { (success, error) -> Void in
                if success {
                    if let id = placeholder?.localIdentifier {
                        _ = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id],
                                                                                  options: nil)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
    }
}
