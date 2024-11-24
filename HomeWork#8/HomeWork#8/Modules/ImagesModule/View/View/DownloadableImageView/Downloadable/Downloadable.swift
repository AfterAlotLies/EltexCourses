//
//  Downloadable.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 19.11.2024.
//

import Foundation
import UIKit

enum DownloadOptions: Equatable, Codable {
    enum From: Codable {
        case disk
        case memory
    }
    
    case circle
    case cached(From)
    case resize
}

protocol Downloadable {
    mutating func loadImage(from url: URL, withOptions options: [DownloadOptions])
    var currentRequestID: UUID? { get set }
}

extension Downloadable where Self: UIImageView {
    
    mutating func loadImage(from url: URL, withOptions options: [DownloadOptions]) {
        let requestID = UUID()
        currentRequestID = requestID
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var cachedImage: CachedImage?
            
            if options.contains(.cached(.memory)) {
                cachedImage = MemoryManager.shared.getImageFromMemory(.memoryCache, for: url)
            }
            
            if cachedImage == nil, options.contains(.cached(.disk)) {
                cachedImage = MemoryManager.shared.getImageFromMemory(.diskCache, for: url)
            }
            
            if let cachedImage = cachedImage {
                let remainingOptions: [DownloadOptions]
                if !cachedImage.appliedOptions.isEmpty {
                    //исключение из входящих параметров операций, для совершения остаточных операций
                    remainingOptions = options.filter { !cachedImage.appliedOptions.contains($0) }
                } else {
                    remainingOptions = options
                }
                
                var image = cachedImage.image
                
                //остаточные операции
                remainingOptions.forEach {
                    switch $0 {
                    case .circle:
                        DispatchQueue.main.async {
                            image = image.maskRoundedImage(image: image, radius: self.bounds.height / 2) ?? image
                            semaphore.signal()
                        }
                        semaphore.wait()
                    case .resize:
                        if options.contains(.circle) {
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                let radius = self.bounds.height / 2
                                DispatchQueue.global().async {
                                    image = image.resizeImage(to: imageSize, preserveCorners: true, cornerRadius: radius) ?? image
                                    semaphore.signal()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                let radius = self.bounds.height / 2
                                DispatchQueue.global().async {
                                    image = image.resizeImage(to: imageSize, preserveCorners: false, cornerRadius: radius) ?? image
                                    semaphore.signal()
                                }
                            }
                        }
                        
                        semaphore.wait()
                    default:
                        break
                    }
                }
                
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                //если в кеше ничего нет - идем в сеть
                if let currentRequestID {
                    NetworkManager.shared.getUrlData(from: url, requestID: currentRequestID) { [weak self] imageData in
                        guard let imageData,
                              var image = UIImage(data: imageData),
                              let self = self,
                              self.currentRequestID == requestID else {
                            return
                        }
                        
                        var appliedOptions: [DownloadOptions] = []
                        let imageSize = self.bounds.size
                        let imageRadius = self.bounds.height / 2
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            options.forEach { option in
                                switch option {
                                case .resize:
                                    if options.contains(.circle) {
                                        image = image.resizeImage(to: imageSize, preserveCorners: true, cornerRadius: imageRadius) ?? image
                                        appliedOptions.append(.resize)
                                    } else {
                                        image = image.resizeImage(to: imageSize, preserveCorners: false, cornerRadius: imageRadius) ?? image
                                        appliedOptions.append(.resize)
                                    }
                                    
                                case .cached(.memory):
                                    let cachedImage = CachedImage(image: image, appliedOptions: appliedOptions)
                                    MemoryManager.shared.saveImageToMemory(.memoryCache, cachedImage, for: url)
                                    
                                case .cached(.disk):
                                    let cachedImage = CachedImage(image: image, appliedOptions: appliedOptions)
                                    MemoryManager.shared.saveImageToMemory(.diskCache, cachedImage, for: url)
                                    
                                    //почему то при одном этом параметре не закругляет картинки?
                                case .circle:
                                    image = image.maskRoundedImage(image: image, radius: imageRadius) ?? image
                                    appliedOptions.append(.circle)
                                }
                            }
                            DispatchQueue.main.async {
                                self.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
