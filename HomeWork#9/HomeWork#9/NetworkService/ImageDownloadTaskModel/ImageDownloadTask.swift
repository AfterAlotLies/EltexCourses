//
//  ImageDownloadTask.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 01.12.2024.
//

import Combine
import Foundation

struct ImageDownloadPublisher {
    let dataPublisher: AnyPublisher<Data, Error>
    let progressPublisher: AnyPublisher<Float, Never>
}

struct Download {
    let task: URLSessionDownloadTask
    let progressPublisher: PassthroughSubject<Float, Never>
    let promise: (Result<Data, Error>) -> Void
}
