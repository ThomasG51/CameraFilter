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
    
    // MARK: - IBOutlet

    @IBOutlet var photoImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let photosController = navController.viewControllers.first as? PhotoCollectionViewController
        else {
            fatalError("Segue destination is not found")
        }
        
        photosController.selectedPhoto.subscribe(onNext: { [weak self] photo in
            self?.photoImageView.image = photo
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Function
    
    // MARK: - Private Function
    
    // MARK: - Objc Function
}
