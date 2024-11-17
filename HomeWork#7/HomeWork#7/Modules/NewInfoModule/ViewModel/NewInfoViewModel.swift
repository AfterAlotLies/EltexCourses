//
//  NewInfoViewModel.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 15.11.2024.
//

import Combine

final class NewInfoViewModel {
    @Published private(set) var selectedCellData: NewsModel?
    
    private let newInfoData = CurrentValueSubject<NewsModel?, Never>(nil)
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        setupBind()
    }
    
    func getNewInfo(_ info: NewsModel) {
        newInfoData.send(info)
    }
}

private extension NewInfoViewModel {
    
    func setupBind() {
        newInfoData
            .sink { [weak self] data in
                self?.selectedCellData = data
            }
            .store(in: &subscriptions)
    }
}
