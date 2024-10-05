//
//  VehicleClass.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

class VehicleClass {
    
    private enum Constants {
        static let successLoadToVehicle = "Груз загружен в машину"
        static let overWeightCargo = "Груз превышает грузоподъемность машины"
        static let notEnoughPlaceInVehicle = "Закончилось место в машине"
        static let vehicleTypeNotCompatible = "Груз не совместим с грузом машины"
        static let incorrectWeightOfCargo = "Вес груза не может быть отрицательным"
    }
    
    let make: String
    let model: String
    let year: Int
    let capacity: Int
    let types: [CargoType]?
    let tankVolume: Int
    var currentLoad: Int?
    
    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]?, currentLoad: Int?, tankVolume: Int) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.currentLoad = currentLoad
        self.tankVolume = tankVolume
    }
    
    func loadCargo(cargo: CargoStruct?) {
        guard let currentCargo = cargo else {
            print(Constants.incorrectWeightOfCargo)
            return
        }
        
        guard isWithinCapacity(cargo: currentCargo) else {
            print(Constants.overWeightCargo)
            return
        }
        
        if let vehicleType = types {
            processLoadForTypeVehicle(cargo: currentCargo, vehicleType: vehicleType)
        } else {
            processLoadForNoTypeVehicle(cargo: currentCargo)
        }
    }
    
    func unloadCargo() {
        currentLoad = 0
    }
    
    func vehicleCanGo(path: Int) -> Bool {
        let kmPerLiter = 20
        let distance = Int((tankVolume / 2) * kmPerLiter)
        return path <= distance
    }
}

extension VehicleClass {
    
    func isWithinCapacity(cargo: CargoStruct) -> Bool {
        return cargo.weight <= capacity
    }
    
    func isVehicleTypeCompatible(cargo: CargoStruct, vehicleType: [CargoType]) -> Bool {
        return vehicleType.contains(where: { $0.sameBaseType(as: cargo.type) })
    }
    
    func canLoadMore(cargo: CargoStruct, load: Int) -> Bool {
        return load + cargo.weight <= capacity
    }
}

private extension VehicleClass {
    
    func processLoadForTypeVehicle(cargo: CargoStruct, vehicleType: [CargoType]) {
        if let load = currentLoad {
                if isVehicleTypeCompatible(cargo: cargo, vehicleType: vehicleType) {
                    if canLoadMore(cargo: cargo, load: load) {
                        currentLoad = load + cargo.weight
                        print(Constants.successLoadToVehicle)
                    } else {
                        print(Constants.notEnoughPlaceInVehicle)
                    }
                } else {
                    print(Constants.vehicleTypeNotCompatible)
                }
            } else {
            if isVehicleTypeCompatible(cargo: cargo, vehicleType: vehicleType) {
                currentLoad = cargo.weight
                print(Constants.successLoadToVehicle)
            } else {
                print(Constants.vehicleTypeNotCompatible)
            }
        }
    }
    
    func processLoadForNoTypeVehicle(cargo: CargoStruct) {
        if let load = currentLoad {
            if canLoadMore(cargo: cargo, load: load) {
                currentLoad = load + cargo.weight
                print(Constants.successLoadToVehicle)
            } else {
                print(Constants.notEnoughPlaceInVehicle)
            }
        } else {
            currentLoad = cargo.weight
            print(Constants.successLoadToVehicle)
        }
    }
}
