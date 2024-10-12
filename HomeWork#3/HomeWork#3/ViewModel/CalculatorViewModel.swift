//
//  CalculatorViewModel.swift
//  HomeWork#3
//
//  Created by Vyacheslav Gusev on 11.10.2024.
//

import Foundation

class CalculatorViewModel {
    private var onUpdateDisplay: ((String) -> Void)?
    
    private var displayValue: String = "0" {
        didSet {
            onUpdateDisplay?(displayValue)
        }
    }
    
    private var firstValue: Double = 0
    private var isSecondValue: Bool = false
    private var currentOperation: String? = nil
    
    func didTappedButton(with symbol: String) {
        switch symbol {
        case "AC":
            clearElements()
        case "+", "-", "×", "÷" :
            handleCalculatorOperation(operation: symbol)
        case "%", "+/-":
            handleSpecialSymbols(symbol)
        case "=":
            calculateResult()
        default:
            handleNumberEnter(symbol)
        }
    }
    
    func bindOnUpdateDisplay(bind: ((String) -> Void)?) {
        onUpdateDisplay = bind
    }
}

private extension CalculatorViewModel {
    
    func handleCalculatorOperation(operation: String) {
        firstValue = Double(displayValue) ?? 0
        isSecondValue = true
        currentOperation = operation
    }
    
    func handleNumberEnter(_ symbol: String) {
        if isSecondValue {
            displayValue = symbol
            isSecondValue = false
        } else {
            if displayValue == "0" || displayValue == "ERROR" {
                displayValue = symbol
            } else {
                displayValue += symbol
            }
        }
    }
    
    func handleSpecialSymbols(_ symbol: String) {
        firstValue = Double(displayValue) ?? 0
        var result: Double = 0
        switch symbol {
        case "%":
            result = firstValue / 100
            if checkFormate(value: result){
                displayValue = String(Int(result))
            } else {
                displayValue = String(result)
            }
        case "+/-":
            firstValue = -firstValue
            if checkFormate(value: firstValue) {
                displayValue = String(Int(firstValue))
            } else {
                displayValue = String(firstValue)
            }
        default:
            return
        }
    }
    
    func calculateResult() {
        guard let operation = currentOperation else { return }
        let secondValue = Double(displayValue) ?? 0
        var result: Double = 0
        
        switch operation {
        case "+":
            result = firstValue + secondValue
        case "-":
            result = firstValue - secondValue
        case "×":
            result = firstValue * secondValue
        case "÷":
            if secondValue == 0 {
                displayValue = "ERROR"
            } else {
                result = firstValue / secondValue
            }
        case "%":
            result = firstValue / 1000
        default:
            break
        }
        
        if displayValue != "ERROR" {
            if checkFormate(value: result) {
                displayValue = String(Int(result))
            } else {
                displayValue = String(result)
            }
            
            isSecondValue = false
            currentOperation = nil
        }
    }
    
    func checkFormate(value: Double) -> Bool{
        if value.remainder(dividingBy: 1) == 0 {
            return true
        } else {
            return false
        }
    }
    
    func clearElements() {
        displayValue = "0"
        firstValue = 0
        isSecondValue = false
        currentOperation = nil
    }
    
}
