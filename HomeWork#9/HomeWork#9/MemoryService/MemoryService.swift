//
//  MemoryService.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 01.12.2024.
//

import Foundation
import UIKit

final class MemoryService {
    
    static let shared = MemoryService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func saveImageToMemory(_ cachedImage: UIImage, for url: String) {
        cache.setObject(cachedImage, forKey: NSString(string: url))
    }
    
    func getImageFromMemory(for url: String) -> UIImage? {
        return cache.object(forKey: NSString(string: url))
    }
}
