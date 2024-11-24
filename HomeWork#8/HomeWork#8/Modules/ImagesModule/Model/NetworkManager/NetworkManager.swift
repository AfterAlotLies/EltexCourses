//
//  NetworkManager.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 21.11.2024.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private var tasks: [UUID: URLSessionTask] = [:]
    private let queue = DispatchQueue(label: "com.vyacheslavgusev.queue", attributes: .concurrent)

    private init() {}

    func getUrlData(from url: URL, requestID: UUID, completion: @escaping ((Data?) -> Void)) {
        queue.async(flags: .barrier) {
            if let existingTask = self.tasks[requestID] {
                existingTask.cancel()
            }
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            self.queue.async(flags: .barrier) {
                self.tasks.removeValue(forKey: requestID)
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }

        queue.async(flags: .barrier) {
            self.tasks[requestID] = task
        }

        task.resume()
    }

    func cancelTask(requestID: UUID) {
        queue.async(flags: .barrier) {
            if self.tasks.isEmpty {
                return
            } else {
                self.tasks[requestID]?.cancel()
                self.tasks.removeValue(forKey: requestID)
            }
        }
    }
}

