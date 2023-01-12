//
//  PhotoCollectionViewCell.swift
//  CameraFilter
//
//  Created by Thomas George on 12/01/2023.
//

import Photos
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!

    func setup(with asset: PHAsset) {
        image.backgroundColor = .systemGray6
        PHImageManager.default().requestImage(for: asset, targetSize: image.frame.size, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.image.image = image
            }
        }
    }
}
