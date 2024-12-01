//
//  ImagesListNetworkProtocol.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 29.11.2024.
//

import Combine
import Foundation

protocol ImagesListNetworkProtocol {
    func fetchImagesData<T: Codable>(model: T.Type) -> AnyPublisher<T, Error>
    func fetchImage(imageURL: String) -> ImageDownloadPublisher
    var activeDownloads: [URLSessionTask: Download] { get set }
}
