//
//  Downloadable.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 19.11.2024.
//

import Foundation
import UIKit

enum DownloadOptions: Equatable {
    enum From {
        case disk
        case memory
    }
    
    case circle
    case cached(From)
    case resize
}

protocol Downloadable {
    func loadImage(from url: URL, withOptions options: [DownloadOptions])
}

extension Downloadable where Self: UIImageView {
    
    func loadImage(from url: URL, withOptions options: [DownloadOptions]) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            if options.contains(where: { $0 == .cached(.memory)} ) {
                if var imageFromMemoryCache = MemoryManager.shared.getImageFromMemory(.memoryCache, for: url) {
                    options.forEach {
                        switch $0 {
                        case .circle:
                            print("circle mem")
                            DispatchQueue.main.async {
                                imageFromMemoryCache = imageFromMemoryCache.maskRoundedImage(image: imageFromMemoryCache, radius: self.bounds.height / 2) ?? imageFromMemoryCache
                                semaphore.signal()
                            }
                            semaphore.wait()
                        case .resize:
                            print("resize mem")
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                DispatchQueue.global().async {
                                    imageFromMemoryCache = imageFromMemoryCache.resizeImage(to: imageSize) ?? imageFromMemoryCache
                                    semaphore.signal()
                                }
                            }
                            semaphore.wait()
                        default:
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        self.image = imageFromMemoryCache
                    }
                    return
                }
            }
            if options.contains(where: { $0 == .cached(.disk) }) {
                if var imageFromDiskMemory = MemoryManager.shared.getImageFromMemory(.diskCache, for: url) {
                    options.forEach {
                        switch $0 {
                        case .circle:
                            DispatchQueue.main.async {
                                imageFromDiskMemory = imageFromDiskMemory.maskRoundedImage(image: imageFromDiskMemory, radius: self.bounds.height / 2) ?? imageFromDiskMemory
                                semaphore.signal()
                            }
                            semaphore.wait()
                        case .resize:
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                DispatchQueue.global().async {
                                    imageFromDiskMemory = imageFromDiskMemory.resizeImage(to: imageSize) ?? imageFromDiskMemory
                                    semaphore.signal()
                                }
                            }
                            semaphore.wait()
                        default:
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        self.image = imageFromDiskMemory
                    }
                    return
                }
            }
            
            NetworkManager.shared.getUrlData(from: url) { imageData in
                guard let imageData, var image = UIImage(data: imageData) else { return }
                options.forEach {
                    switch $0 {
                    case .resize:
                        image = image.resizeImage(to: self.bounds.size) ?? image
                    case .cached(.memory):
                        MemoryManager.shared.saveImageToMemory(.memoryCache, image, for: url)
                    case .cached(.disk):
                        MemoryManager.shared.saveImageToMemory(.diskCache, image, for: url)
                    case .circle:
                        image = image.maskRoundedImage(image: image, radius: self.bounds.height / 2) ?? image
                    }
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

private extension Downloadable where Self: UIImageView {
    
    func getImagesFromCacheByType(_ cacheType: DownloadOptions) {
        
    }
}
