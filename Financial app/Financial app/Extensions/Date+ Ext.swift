//
//  Date+ Ext.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 13.02.2025.
//

import Foundation


extension Date {
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
