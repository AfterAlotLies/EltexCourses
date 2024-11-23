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

    private let cache = NSCache<NSURL, CachedImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    func saveImageToMemory(_ memoryType: MemoryType, _ cachedImage: CachedImage, for url: URL) {
        let cacheKey = url.absoluteString
        let fileName = url.lastPathComponent
        let filePath = cacheDirectory.appendingPathComponent(fileName)
        let metadataPath = filePath.appendingPathExtension("json")

        switch memoryType {
        case .memoryCache:
            cache.setObject(cachedImage, forKey: NSURL(string: cacheKey)!)
        case .diskCache:
            if let imageData = cachedImage.image.pngData() {
                try? imageData.write(to: filePath)
            }
            
            if let metadata = try? JSONEncoder().encode(cachedImage.appliedOptions) {
                try? metadata.write(to: metadataPath)
            }
        }
    }

    func getImageFromMemory(_ memoryType: MemoryType, for url: URL) -> CachedImage? {
        let cacheKey = url.absoluteString
        let fileName = url.lastPathComponent
        let filePath = cacheDirectory.appendingPathComponent(fileName)
        let metadataPath = filePath.appendingPathExtension("json")
        
        switch memoryType {
        case .memoryCache:
            return cache.object(forKey: NSURL(string: cacheKey)!)
        case .diskCache:
            guard let image = UIImage(contentsOfFile: filePath.path) else { return nil }
            
            let appliedOptions: [DownloadOptions]
            if let metadataData = try? Data(contentsOf: metadataPath),
               let metadata = try? JSONDecoder().decode([DownloadOptions].self, from: metadataData) {
                appliedOptions = metadata
            } else {
                appliedOptions = []
            }
            
            return CachedImage(image: image, appliedOptions: appliedOptions)
        }
    }
}

