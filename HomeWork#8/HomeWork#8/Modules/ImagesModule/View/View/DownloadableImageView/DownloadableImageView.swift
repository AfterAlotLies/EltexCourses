//
//  DownloadableImageView.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 19.11.2024.
//

import UIKit

class DownloadableImageView: UIImageView, Downloadable {
    
    var currentRequestID: UUID?
    
    func cancelImageDownload() {
        if let requestID = currentRequestID {
            NetworkManager.shared.cancelTask(requestID: requestID)
            currentRequestID = nil
        }
    }
  
}
