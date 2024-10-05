//
//  main.swift
//  HomeWork#2
//
//  Created by Vyacheslav Gusev on 02.10.2024.
//

import Foundation

let fleet = FleetClass()

let firstTruck = TruckClass(make: "Mercedes",
                            model: "HW",
                            year: 2012,
                            capacity: 500,
                            tankVolume: 1000,
                            types: [
                                .fragile(fragilityLevel: 20),
                                .bulk(density: 24)
                            ],
                            currentLoad: nil,
                            trailerAttached: false)

let secondTruck = TruckClass(make: "Honda",
                             model: "HL",
                             year: 2009,
                             capacity: 500,
                             tankVolume: 1000,
                             types: [
                                .bulk(density: 10)
                             ],
                             currentLoad: nil,
                             trailerAttached: true,
                             trailerCapacity: 300,
                             trailerTypes: [
                                .perishable(temperatureRec: 20.0)
                             ],
                             trailerCurrentLoad: nil)

let firstVehicle = VehicleClass(make: "Honda",
                                model: "CRV",
                                year: 2010,
                                capacity: 100,
                                types: [
                                    .fragile(fragilityLevel: 15)
                                ],
                                currentLoad: nil,
                                tankVolume: 500)

let secondVehicle = VehicleClass(make: "Toyota",
                                 model: "Camry",
                                 year: 2012,
                                 capacity: 50,
                                 types: [
                                    .bulk(density: 10),
                                    .fragile(fragilityLevel: 20)
                                 ],
                                 currentLoad: nil,
                                 tankVolume: 200)

fleet.addVehicle(firstTruck)
fleet.addVehicle(secondTruck)

fleet.addVehicle(firstVehicle)
fleet.addVehicle(secondVehicle)

print("\nАвтопарк до загрузки машин:")
fleet.info()

let firstCargo = CargoStruct(description: "Стекло",
                             weight: 45,
                             type: .fragile(fragilityLevel: 20))


let secondCargo = CargoStruct(description: "Мясо",
                              weight: 150,
                              type: .perishable(temperatureRec: 20.0))

let thirdCargo = CargoStruct(description: "Бетон",
                             weight: 200,
                             type: .bulk(density: 20))

let fourthCargo = CargoStruct(description: "Мебель",
                              weight: 50,
                              type: .fragile(fragilityLevel: 100))

if let cargo1 = firstCargo, let cargo2 = secondCargo, let cargo3 = thirdCargo, let cargo4 = fourthCargo {
    firstTruck.loadCargo(cargo: cargo1)
    secondTruck.loadCargo(cargo: cargo2)
    
    firstVehicle.loadCargo(cargo: cargo3)
    secondVehicle.loadCargo(cargo: cargo4)
    
    print("\nАвтопарк после загрузки машин")
    fleet.info()
    fleet.listOfLoadedVehicles()
}

firstTruck.unloadCargo()
secondTruck.unloadCargo()
firstVehicle.unloadCargo()
secondVehicle.unloadCargo()

print("\nАвтопарк после разгрузки машин")
fleet.info()

if let cargo1 = firstCargo, let cargo2 = secondCargo, let cargo3 = thirdCargo, let cargo4 = fourthCargo {
    fleet.canGo(cargo: [cargo1, cargo2, cargo3, cargo4], path: 100)
}


print("\nАвтопарк после загрузки машин:")
fleet.info()
fleet.listOfLoadedVehicles()
