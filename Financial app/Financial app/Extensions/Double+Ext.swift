//
//  Double+Ext.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 13.02.2025.
//

import Foundation

extension Double {
    var stringValue: String {
        return String(self)
    }
    
    var twoDecimalPlaceString: String {
        return String(format: "%.2f", self)
    }
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    var percentageFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    func toCurrencyFormat(hasDollarSymbol: Bool, hasDecimalPlaces: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if hasDollarSymbol {
            formatter.currencySymbol = ""
        }
        
        if hasDecimalPlaces == false {
            formatter.minimumFractionDigits = 0
        }
            
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
}
