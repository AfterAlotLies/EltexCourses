//
//  ImagesListViewModel.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 28.11.2024.
//

import Foundation
import Combine

final class ImagesListViewModel {
    
    private let networkManager: ImagesListNetworkService
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published private(set) var images: [ImagesListModel] = []
    
    init(networkManager: ImagesListNetworkService) {
        self.networkManager = networkManager
    }
    
    func getAllImagesData() {
        networkManager.fetchImagesData(model: [ImagesListModel].self)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { imagesData in
                self.images = imagesData
            }
            .store(in: &subscriptions)
    }
}

