//
//  FilterService.swift
//  CameraFilter
//
//  Created by Thomas George on 16/01/2023.
//

import CoreImage
import RxSwift
import UIKit

class FilterService {
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { [weak self] observer in
            self?.process(to: inputImage) { processedImage in
                observer.onNext(processedImage)
            }
            return Disposables.create()
        }
    }
    
    private func process(to inputImage: UIImage, completion: @escaping (UIImage) -> Void) {
        guard let filter = CIFilter(name: "CICMYKHalftone") else { return }
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        guard let sourceImage = CIImage(image: inputImage) else { return }
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return }
        guard let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        
        completion(processedImage)
    }
}
