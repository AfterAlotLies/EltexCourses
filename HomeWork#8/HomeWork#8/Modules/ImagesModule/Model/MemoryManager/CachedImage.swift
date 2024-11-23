//
//  CachedImage.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 23.11.2024.
//

import UIKit

final class CachedImage {
    let image: UIImage
    let appliedOptions: [DownloadOptions]

    init(image: UIImage, appliedOptions: [DownloadOptions]) {
        self.image = image
        self.appliedOptions = appliedOptions
    }
}
