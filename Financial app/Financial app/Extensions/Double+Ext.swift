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
}
