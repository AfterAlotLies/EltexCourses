//
//  ImagesListNetworkService.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 28.11.2024.
//

import Foundation
import Combine

protocol IImagesListNetworkService {
    func fetchImagesData<T: Codable>(model: T.Type) -> AnyPublisher<T, Error>
    func fetchImage(imageURL: String) -> AnyPublisher<Data, Error>
}

final class ImagesListNetworkService: NSObject, IImagesListNetworkService {
    
    enum NetworkErrors: Error {
        case invalidURL
        case invalidData
    }
    
    private(set) var downloadProgressPublisher = PassthroughSubject<Float, Never>()
    private var downloadImagePromise: ((Result<Data, Error>) -> Void)?
    
    func fetchImagesData<T: Codable>(model: T.Type) -> AnyPublisher<T, Error> {
        guard let request = createRequest(with: "http://164.90.163.215:1337/api/upload/files", for: "GET") else {
            return Fail(error: NetworkErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchImage(imageURL: String) -> AnyPublisher<Data, Error> {
        guard let request = createRequest(with: "http://164.90.163.215:1337\(imageURL)", for: "GET") else {
            return Fail(error: NetworkErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let downloadTask = session.downloadTask(with: request)
        downloadTask.resume()
        
        return Deferred {
             Future<Data, Error> { promise in
                self.downloadImagePromise = promise
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension ImagesListNetworkService: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        downloadProgressPublisher.send(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            downloadImagePromise?(.success(data))
        } catch {
            downloadImagePromise?(.failure(NetworkErrors.invalidData))
        }
    }
}

private extension ImagesListNetworkService {
    
    func createRequest(with url: String, for httpMethod: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
