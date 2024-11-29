//
//  NetworkService.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 28.11.2024.
//

import Foundation
import Combine

final class NetworkService: NSObject, ImagesListNetworkProtocol, MediaUploadNetworkProtocol {
    
    enum NetworkErrors: Error {
        case invalidURL
        case invalidData
    }
    
    private var downloadImagePromise: ((Result<Data, Error>) -> Void)?
    var downloadProgressPublisher: PassthroughSubject<Float, Never> = PassthroughSubject<Float, Never>()
    
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
    
    func getImageFromUrl(from url: String) -> AnyPublisher<Data, Error> {
        guard let request = createRequest(with: url, for: "GET") else {
            return Fail(error: NetworkErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    
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

private extension NetworkService {
    
    func createRequest(with url: String, for httpMethod: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
