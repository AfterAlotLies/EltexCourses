//
//  TruckClass.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

final class TruckClass: VehicleClass {
    
    private enum Constants {
        static let overWeightCargo = "Груз превышает грузоподъемность грузовика"
        static let successLoadtoTruck = "Груз загружен в грузовик"
        static let successLoadToTrailer = "Груз загружен в прицеп"
        static let trailerNotAttached = "Прицепа нет"
        static let notEnoughSpaceInTrailer = "В прицепе нет места"
        static let cargoNotCompetibleWithTruck = "Груз не совместим с грузом грузовика. Проверка на наличие прицепа..."
        static let notCompetibleCargoWithTrailer = "Прицеп не поддерживает данный тип груза"
        static let notEnoughSpaceInTruck = "В грузовике места нет.Проверка на наличие прицепа..."
        static let incorrectWeightOfCargo = "Вес груза не может быть отрицательным"
    }
    
    private let trailerAttached: Bool
    private let trailerCapacity: Int?
    private let trailerTypes: [CargoType]?
    var trailerCurrentLoad: Int?
    
    init(make: String, model: String, year: Int, capacity: Int, tankVolume: Int, types: [CargoType]?, currentLoad: Int?, trailerAttached: Bool, trailerCapacity: Int? = nil, trailerTypes: [CargoType]? = nil, trailerCurrentLoad: Int? = nil) {
        self.trailerAttached = trailerAttached
        self.trailerCapacity = trailerCapacity
        self.trailerTypes = trailerTypes
        self.trailerCurrentLoad = trailerCurrentLoad
        
        super.init(
            make: make,
            model: model,
            year: year,
            capacity: capacity,
            types: types,
            currentLoad: currentLoad,
            tankVolume: tankVolume
        )
    }
    
    override func loadCargo(cargo: CargoStruct?) {
        guard let currentCargo = cargo else {
            print(Constants.incorrectWeightOfCargo)
            return
        }
        
        guard isWithinCapacity(cargo: currentCargo) else {
            print(Constants.overWeightCargo)
            return
        }
        
        if let vehicleType = types {
            processCargoForTypeTruck(cargo: currentCargo, vehicleType: vehicleType)
        } else {
            processCargoForNoTypeTruck(cargo: currentCargo)
        }
    }
}

private extension TruckClass {

    func processCargoForTypeTruck(cargo: CargoStruct, vehicleType: [CargoType]) {
        if let load = currentLoad {
            if canLoadMore(cargo: cargo, load: load) {
                if isVehicleTypeCompatible(cargo: cargo, vehicleType: vehicleType) {
                    currentLoad = load + cargo.weight
                    print(Constants.successLoadtoTruck)
                } else {
                    handleNotCompetibleCargoForTruck(cargo: cargo)
                }
            } else {
                handleNotEnoughSpaceInTruck(cargo: cargo)
            }
        } else {
            if isVehicleTypeCompatible(cargo: cargo, vehicleType: vehicleType) {
                currentLoad = cargo.weight
                print(Constants.successLoadtoTruck)
            } else {
                handleNotCompetibleCargoForTruck(cargo: cargo)
            }
        }
    }

    func processCargoForNoTypeTruck(cargo: CargoStruct) {
        if let load = currentLoad {
            if canLoadMore(cargo: cargo, load: load) {
                currentLoad = load + cargo.weight
                print(Constants.successLoadtoTruck)
            } else {
                handleNotEnoughSpaceInTruck(cargo: cargo)
            }
        } else {
            currentLoad = cargo.weight
            print(Constants.successLoadtoTruck)
        }
    }

    func handleNotCompetibleCargoForTruck(cargo: CargoStruct) {
        print(Constants.cargoNotCompetibleWithTruck)
        if trailerAttached {
            loadCargoIntoTrailer(cargo: cargo)
        } else {
            print(Constants.trailerNotAttached)
        }
    }

    func handleNotEnoughSpaceInTruck(cargo: CargoStruct) {
        print(Constants.notEnoughSpaceInTruck)
        if trailerAttached {
            loadCargoIntoTrailer(cargo: cargo)
        } else {
            print(Constants.trailerNotAttached)
        }
    }

    func loadCargoIntoTrailer(cargo: CargoStruct) {
        let currentTrailerCapacity = trailerCapacity ?? 0
        let currentTrailerLoad = trailerCurrentLoad ?? 0
        
        if currentTrailerLoad + cargo.weight <= currentTrailerCapacity {
            if isTrailerTypeCompatible(cargo: cargo) {
                trailerCurrentLoad = currentTrailerLoad + cargo.weight
                print(Constants.successLoadToTrailer)
            } else {
                if let _ = trailerTypes {
                    trailerCurrentLoad = currentTrailerLoad + cargo.weight
                    print(Constants.successLoadToTrailer)
                } else {
                    print(Constants.notCompetibleCargoWithTrailer)
                }
            }
        } else {
            print(Constants.notEnoughSpaceInTrailer)
        }
    }

    func isTrailerTypeCompatible(cargo: CargoStruct) -> Bool {
        return trailerTypes?.contains(where: { $0.sameBaseType(as: cargo.type) }) ?? false
    }
}
