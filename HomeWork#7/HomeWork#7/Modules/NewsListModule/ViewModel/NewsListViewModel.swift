//
//  NewsListViewModel.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import Foundation
import Combine

final class NewsListViewModel {
    let buttonTapped = PassthroughSubject<TypeOfSortRequest, Never>()
    
    @Published private(set) var newsData: [NewsModel]?
    @Published private(set) var isLoading: Bool = false
    @Published var selectedCellData: NewsModel?
    @Published var textFieldWord: String = "" {
        didSet {
            self.makeRequestBaseOnTextFieldWord()
        }
    }
    
    private var currentPage: Int = 0
    private let pageSize: Int = 20
    private var allFethedData: [NewsModel] = []
    private let networkService: NetworkService = NetworkService()
    private var subscriptions: Set<AnyCancellable> = []
    private var currentSortType: TypeOfSortRequest = .noSort
    private var isSorted: Bool = false
    
    init() {
        buttonTapped
            .sink { sortType in
                self.isSorted = sortType != .noSort
                self.makeRequestBaseOnSort(by: sortType)
                self.currentSortType = sortType
            }
            .store(in: &subscriptions)
    }
    
    func loadNextPage() {
        guard !isLoading else { return }
        
        if isSorted {
            loadNextPageWithSort()
        } else {
            loadNextPageWithoutSort()
        }
    }
}

private extension NewsListViewModel {
    
    func loadNextPageWithSort() {
        currentPage += 1
        
        networkService.getDataBySort(textFieldWord, currentSortType)
            .map { $0.articles.map { [weak self] article in
                let formattedDate = self?.formatDate(from: article.dataPublished) ?? article.dataPublished
                return NewsModel(title: article.title,
                                 dataPublished: formattedDate,
                                 author: article.author,
                                 content: article.content)
            }}
            .sink { completion in
                switch completion {
                case .finished:
                    print("Sorted data loaded successfully")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] newData in
                guard let self = self else { return }
                self.allFethedData.append(contentsOf: newData)
                self.newsData = Array(self.allFethedData.prefix(self.currentPage * self.pageSize))
            }
            .store(in: &subscriptions)
    }
    
    func loadNextPageWithoutSort() {
        guard !isLoading else { return }
        isLoading = true
        
        currentPage += 1
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(currentPage * pageSize, allFethedData.count)
        
        let newPageData = Array(allFethedData[startIndex..<endIndex])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.newsData = (self?.newsData ?? []) + newPageData
            self?.isLoading = false
        }
    }
    
    func makeRequestBaseOnTextFieldWord() {
        isLoading = true
        currentPage = 0
        
        networkService.getDataByWord(textFieldWord)
            .map { $0.articles.map { [weak self] article in
                let formattedDate = self?.formatDate(from: article.dataPublished) ?? article.dataPublished
                return NewsModel(title: article.title,
                                 dataPublished: formattedDate,
                                 author: article.author,
                                 content: article.content)
            }}
            .sink { completion in
                switch completion {
                case .finished:
                    print("Data loaded successfully")
                case .failure(let error):
                    print(error)
                }
                self.isLoading = false
            } receiveValue: { [weak self] newsData in
                guard let self = self else { return }
                self.allFethedData = newsData
                self.newsData = Array(self.allFethedData.prefix(self.pageSize))
                self.isLoading = false
            }
            .store(in: &subscriptions)
    }
    
    func makeRequestBaseOnSort(by sortType: TypeOfSortRequest) {
        isLoading = true
        currentPage = 0
        
        networkService.getDataBySort(textFieldWord, sortType)
            .map { $0.articles.map { [weak self] article in
                let formattedDate = self?.formatDate(from: article.dataPublished) ?? article.dataPublished
                return NewsModel(title: article.title,
                                 dataPublished: formattedDate,
                                 author: article.author,
                                 content: article.content)
            }}
            .sink { completion in
                switch completion {
                case .finished:
                    print("Sorted data loaded successfully")
                case .failure(let error):
                    print(error)
                }
                self.isLoading = false
            } receiveValue: { [weak self] sortedNewsData in
                guard let self = self else { return }
                self.allFethedData = sortedNewsData
                self.newsData = Array(self.allFethedData.prefix(self.pageSize))
                self.isLoading = false
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
