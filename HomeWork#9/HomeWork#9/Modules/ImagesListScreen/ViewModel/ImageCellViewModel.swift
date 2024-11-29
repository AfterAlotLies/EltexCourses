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
    @Published private(set) var progress: Float?
    
    private var imageUrl: String?
    private var subscriptions: Set<AnyCancellable> = []
    private let networkManager: ImagesListNetworkService
    private var downloadingProgressPublisher = PassthroughSubject<Float, Never>()
    
    init(networkManager: ImagesListNetworkService) {
        self.networkManager = networkManager
    }
    
    func getPublisherForCell() -> AnyPublisher<Float, Never> {
        return downloadingProgressPublisher.eraseToAnyPublisher()
    }
    
    func configureVm(with imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func loadImage(from url: String) {
        networkManager.fetchImage(imageURL: url)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("image loaded")
                case .failure(let error):
                    print("error to load image \(error.localizedDescription)")
                }
            } receiveValue: { imageData in
                self.imageData[url] = imageData
            }
            .store(in: &subscriptions)
        
        networkManager.downloadProgressPublisher
            .receive(on: DispatchQueue.main)
            .sink { progressData in
                self.imageDataProgress[url] = progressData
            }
            .store(in: &subscriptions)
    }
}
