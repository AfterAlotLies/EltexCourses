//
//  CargoStruct.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

struct CargoStruct {
    let description: String
    let weight: Int
    let type: CargoType
    
    init?(description: String, weight: Int, type: CargoType) {
        guard weight >= 0 else {
            return nil
        }

        self.description = description
        self.type = type
        self.weight = weight
    }
}
