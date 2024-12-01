//
//  ImageCellViewModel.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 28.11.2024.
//

import Foundation
import Combine

final class ImageCellViewModel {
    
    @Published private(set) var imageData: [String : Data] = [:]
    @Published private(set) var imageDataProgress: [String : Float] = [:]
    
    private var imageUrl: String?
    private var subscriptions: Set<AnyCancellable> = []
    private let networkManager: ImagesListNetworkProtocol
    
    init(networkManager: ImagesListNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func loadImage(from url: String) {
        let downloadPublisher = networkManager.fetchImage(imageURL: url)
        
        downloadPublisher.dataPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Image loaded successfully.")
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            } receiveValue: { [weak self] data in
                self?.imageData[url] = data
            }
            .store(in: &subscriptions)
        
        downloadPublisher.progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.imageDataProgress[url] = progress
            }
            .store(in: &subscriptions)
    }
}
