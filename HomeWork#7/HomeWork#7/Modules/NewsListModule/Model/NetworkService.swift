//
//  NetworkService.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import Foundation
import Combine

enum NetworkErrors: Error {
    case error
}

final class NetworkService {
    
    func fetchData(_ keyWord: String) -> AnyPublisher<ArticlesModel, Error> {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(keyWord)") else {
            return Fail(error: NetworkErrors.error)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-Api-Key": "3a6c589f5c6e4a51b2afc6607c83f99a"]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ArticlesModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
