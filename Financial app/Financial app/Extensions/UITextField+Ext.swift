//
//  UITextField+Ext.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 11.02.2025.
//

import UIKit

extension UITextField {
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let donetoolBar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        donetoolBar.barStyle = .default
        let flexBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let items = [flexBarButtonItem, doneBarButtonItem]
        donetoolBar.items = items
        donetoolBar.sizeToFit()
        inputAccessoryView = donetoolBar
    }
    
    @objc func dismissKeyboard() {
        resignFirstResponder()
    }
}
