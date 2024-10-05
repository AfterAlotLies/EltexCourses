//
//  CargoType.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

enum CargoType: Equatable {
    case fragile(fragilityLevel: Int)
    case perishable(temperatureRec: Double)
    case bulk(density: Int)
    
    var description: String {
        switch self {
        case .fragile(let fragilityLevel):
            return "Хрупкий груз с уровнем хрупкости -> \(fragilityLevel)"
        case .perishable(let temperatureRec):
            return "Скоропортящийся груз с рекомендательной температурой -> \(temperatureRec)"
        case .bulk(let density):
            return "Сыпучий груз с плотностью -> \(density)"
        }
    }
}

extension CargoType {
    
    func sameBaseType(as other: CargoType) -> Bool {
        switch (self, other) {
        case (.fragile, .fragile), (.perishable, .perishable), (.bulk, .bulk):
            return true
        default:
            return false
        }
    }
}
