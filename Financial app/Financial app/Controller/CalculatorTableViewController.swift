//
//  CalculatorTableViewController.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 11.02.2025.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        
        currencyLabels.forEach( { $0.text = asset?.searchResult.currency.addBrackets() })
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
    }
}
