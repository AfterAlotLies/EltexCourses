//
//  NetworkManager.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 21.11.2024.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func getUrlData(from url: URL, completion: @escaping ((Data?) -> Void)) {
        DispatchQueue.global().async {
            let imageDataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let dataImage = data {
                    DispatchQueue.main.async {
                        completion(dataImage)
                    }
                }
            }
            imageDataTask.resume()
        }
    }
}
