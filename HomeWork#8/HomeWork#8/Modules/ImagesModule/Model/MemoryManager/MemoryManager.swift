//
//  MemoryManager.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 22.11.2024.
//

import Foundation
import UIKit

final class MemoryManager {
    
    enum MemoryType {
        case memoryCache
        case diskCache
    }
    
    static let shared = MemoryManager()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func saveImageToMemory(_ memoryType: MemoryType, _ image: UIImage, for url: URL, with identifier: String? = nil) {
        let cacheKey = identifier != nil ? url.absoluteString + "_\(identifier!)" : url.absoluteString
        
        switch memoryType {

        case .memoryCache:
            cache.setObject(image, forKey: url as NSURL)

        case .diskCache:
            let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
            if let data = image.pngData() {
                try? data.write(to: filePath)
            }
        }
    }
    
    func getImageFromMemory(_ memoryType: MemoryType, for url: URL) -> UIImage? {
        switch memoryType {

        case .memoryCache:
            return cache.object(forKey: url as NSURL)

        case .diskCache:
            let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
            return UIImage(contentsOfFile: filePath.path)
        }
    }
}
