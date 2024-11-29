//
//  MediaUploadNetworkProtocol.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 29.11.2024.
//

import Foundation
import Combine

protocol MediaUploadNetworkProtocol {
    func getImageFromUrl(from url: String) -> AnyPublisher<Data, Error>
}
