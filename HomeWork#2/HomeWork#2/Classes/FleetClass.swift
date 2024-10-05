//
//  FleetClass.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

class FleetClass {
    
    private enum Constants {
        static let successAddVehicle = "Транспорт добавлен в автопарк"
        static let noVehicleToRide = "\nНет машин, которые смогли бы перевезти груз"
        static let canGo = "\nЗагруженные машины смогут преодолеть путь"
        static let cantGo = "\nЗагруженные машины не смогут преодолеть путь"
        static let listLoadedVehicles = "\nСписок загруженных машин"
    }
    
    private var vehicleArray = [VehicleClass]()
    
    func addVehicle(_ vehicle: VehicleClass) {
        vehicleArray.append(vehicle)
        print(Constants.successAddVehicle)
    }
    
    func info() {
        print(
                """
                \n
                Машин в автопарке на данный момент: \(vehicleArray.count),
                Общая грузоподъемность автопарка: \(totalCapacity()),
                Текущая нагрузка автопарка: \(totalCurrentLoad())
                \n
                """
        )
    }
    
    func canGo(cargo: [CargoStruct], path: Int) {
        var loadedVehicleArray = [VehicleClass]()
        
        for oneCargo in cargo {
            for vehicle in vehicleArray {
                let vehicleCurrentNow = vehicle.currentLoad ?? 0
                vehicle.loadCargo(cargo: oneCargo)
                if vehicleCurrentNow < vehicle.currentLoad ?? 0 {
                    if !loadedVehicleArray.contains(where: { $0 === vehicle }) {
                        loadedVehicleArray.append(vehicle)
                    }
                }
            }
        }
        
        if loadedVehicleArray.isEmpty {
            print(Constants.noVehicleToRide)
        }
        
        var canGo: Bool = false
        
        for loadedVehicle in loadedVehicleArray {
            if loadedVehicle.vehicleCanGo(path: path) {
                canGo = true
            }
        }
        
        if canGo {
            print(Constants.canGo)
        } else {
            print(Constants.cantGo)
        }
    }
    
    func listOfLoadedVehicles() {
        print(Constants.listLoadedVehicles)
        vehicleArray.forEach{
            if $0.currentLoad ?? 0 > 0 {
                print($0.make)
            }
        }
    }
}

private extension FleetClass {
    
    func totalCapacity() -> Int {
        var totalCapacity = 0
        
        vehicleArray.forEach {
            totalCapacity += $0.capacity
        }
        return totalCapacity
    }
    
    func totalCurrentLoad() -> Int {
        var totalCurrentLoad = 0
        
        vehicleArray.forEach {
            totalCurrentLoad += $0.currentLoad ?? 0
        }
        return totalCurrentLoad
    }
}
