//
//  NewsListViewModel.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import Foundation
import Combine

final class NewsListViewModel: ObservableObject {
    @Published var newsData: [NewsModel]?
    @Published var textFieldKeyWord: String = "" {
        didSet {
            loadData()
        }
    }
    private let networkService: NetworkService = NetworkService()
    private var subscriptions: Set<AnyCancellable> = []
    
}

private extension NewsListViewModel {
    
    func loadData() {
        networkService.fetchData(textFieldKeyWord)
            .map { $0.articles.prefix(20).map{ article in
                let formattedDate = self.formatDate(from: article.dataPublished) ?? article.dataPublished
                return NewsModel(title: article.title,
                                 dataPublished: formattedDate)
            }}
            .sink { error in
                print(error)
            } receiveValue: { newsData in
                self.newsData = newsData
            }
            .store(in: &subscriptions)

    }
    
    func formatDate(from isoDateString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoFormatter.date(from: isoDateString) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date)
    }

}
