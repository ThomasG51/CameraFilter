//
//  PhotoCollectionViewController.swift
//  CameraFilter
//
//  Created by Thomas George on 12/01/2023.
//

import Photos
import RxSwift
import UIKit

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    private let cellIdentifier = "PhotoCellIdentifier"
    private var images = [PHAsset]()
    
    // MARK: - IBOutlet
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }
    
    // MARK: - IBAction
    
    // MARK: - Navigation
    
    // MARK: - Function
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Photo cell identifier not found")
        }
        cell.setup(with: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3, height: view.frame.size.width / 3)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.height), contentMode: .aspectFit, options: nil) { [weak self] image, info in
                    
            guard let info = info else { return }
                    
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Private Function

    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects { object, _, _ in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Objc Function
}
