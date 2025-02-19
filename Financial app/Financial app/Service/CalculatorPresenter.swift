//
//  CalculatorPresenter.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 18.02.2025.
//

import UIKit

struct CalculatorPresenter {
    func getPresentation(result: DCAResult) -> CalculatorPresentation {
        let isProfitable = result.isProfitable == true
        let gainSymbol = isProfitable ? "+" : ""
                
        return .init(currentValueLabelBackgroundColor: result.isProfitable == true ? .themeGreenShade : .themeRedShade,
                     currentValueLabel: result.currentValue.currencyFormat,
                     investmentAmountLabel: result.investmentAmount.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false),
                     gainLabel: result.gain.toCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
                     yieldLabel: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
                     yieldLabelTextColor: isProfitable ? .themeGreenShade : .themeRedShade,
                     anualReturnLabel: result.annualReturn.percentageFormat,
                     anualReturnLabelTextColor: isProfitable ? .themeGreenShade : .themeRedShade)
    }
}


struct CalculatorPresentation {
    let currentValueLabelBackgroundColor: UIColor
    let currentValueLabel: String
    let investmentAmountLabel: String
    let gainLabel: String
    let yieldLabel: String
    let yieldLabelTextColor: UIColor
    let anualReturnLabel: String
    let anualReturnLabelTextColor: UIColor
}
