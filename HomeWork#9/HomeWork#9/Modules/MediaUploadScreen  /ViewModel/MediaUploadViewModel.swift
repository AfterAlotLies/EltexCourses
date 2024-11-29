//
//  MediaUploadViewModel.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 29.11.2024.
//

import Foundation
import Combine

final class MediaUploadViewModel {
    
    enum ImageProcessState {
        case idle
        case loading
        case optimizing
        case ready
    }
    
    @Published private(set) var imageData: Data?
    @Published private(set) var processState: ImageProcessState = .idle
    @Published private(set) var requestError: String = ""
    
    private let networkService: MediaUploadNetworkProtocol
    private var subscriptions: Set<AnyCancellable> = []
    
    init(networkService: MediaUploadNetworkProtocol) {
        self.networkService = networkService
    }
    
    func getImageBaseOnURL(_ url: String) {
        processState = .loading
        networkService.getImageFromUrl(from: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    print("success")
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.processState = .idle
                        self?.requestError = "\(error.localizedDescription)"
                    }
                }
            } receiveValue: { [weak self] data in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.processState = .optimizing
                }
                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                    let compressedData = data.compress()
                    DispatchQueue.main.async {
                        self?.imageData = compressedData
                        self?.processState = .ready
                    }
                }
            }
            .store(in: &subscriptions)

    }
}
