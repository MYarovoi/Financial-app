//
//  String+Ext.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 11.02.2025.
//

import Foundation

extension String {
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
}
