//
//  ViewController.swift
//  CameraFilter
//
//  Created by Thomas George on 12/01/2023.
//

import RxSwift
import UIKit

class ViewController: UIViewController {
    // MARK: - Property

    let disposeBag = DisposeBag()
    let filterService = FilterService()
    
    // MARK: - IBOutlet

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var applyFilterButton: UIButton!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func applyFilterButtonTapped(_ sender: Any) {
        guard let sourceImage = photoImageView.image else { return }
        
        filterService.applyFilter(to: sourceImage)
            .subscribe { filteredImage in
                DispatchQueue.main.async { [weak self] in
                    self?.photoImageView.image = filteredImage
                }
            }.disposed(by: disposeBag)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let photosController = navController.viewControllers.first as? PhotoCollectionViewController
        else {
            fatalError("Segue destination is not found")
        }
        
        photosController.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Function
    
    // MARK: - Private Function
    
    private func updateUI(with photo: UIImage) {
        photoImageView.image = photo
        applyFilterButton.isHidden = false
    }
    
    // MARK: - Objc Function
}
