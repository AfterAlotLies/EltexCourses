//
//  UITextField+Publisher.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 15.11.2024.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{ $0.object as? UITextField }
            .map { $0.text ?? "" }
            .filter { $0.count >= 3}
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
