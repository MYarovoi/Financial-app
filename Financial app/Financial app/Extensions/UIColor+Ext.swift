//
//  UIColor+Ext.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 14.02.2025.
//

import UIKit

extension UIColor {
    
    static let themeRedShade = UIColor("#fae2e1")
    static let themeGreenShade = UIColor("#b0f1dd")
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.removeFirst()
        }
        
        if cString.count != 6 {
            self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: alpha)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

