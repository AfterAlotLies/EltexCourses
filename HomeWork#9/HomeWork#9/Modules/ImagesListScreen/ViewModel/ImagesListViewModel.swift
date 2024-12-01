//
//  ImagesListViewModel.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 28.11.2024.
//

import Foundation
import Combine

final class ImagesListViewModel {
    
    @Published private(set) var images: [ImagesListModel] = []
    
    private let networkManager: ImagesListNetworkProtocol
    private var subscriptions: Set<AnyCancellable> = []
    private(set) var navigateToNextScreen = PassthroughSubject<Void, Never>()
        
    init(networkManager: ImagesListNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func getAllImagesData() {
        networkManager.fetchImagesData(model: [ImagesListModel].self)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("success to get data")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { imagesData in
                self.images = imagesData
            }
            .store(in: &subscriptions)
    }
    
    func buttonDidTapped() {
        navigateToNextScreen.send()
    }
    
    func addNewImageURL(_ url: String) {
        images.insert(ImagesListModel(url: url), at: images.endIndex)
    }
}

