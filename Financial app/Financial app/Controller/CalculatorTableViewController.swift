//
//  CalculatorTableViewController.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 11.02.2025.
//

import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAverageTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset: Asset?
    @Published private var initialDateOfInvestmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveragingAmount: Int?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        observeForm()
        setupDateSlider()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        
        currencyLabels.forEach( { $0.text = asset?.searchResult.currency.addBrackets() })
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
    }
    
    private func setupDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getyMonthInfo().count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    func observeForm() {
        $initialDateOfInvestmentIndex.sink { [weak self] index in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            
            if let monthInfo = self?.asset?.timeSeriesMonthlyAdjusted.getyMonthInfo(), index >= 0, index < monthInfo.count {
                let dateString = monthInfo[index].date.MMYYFormat
                self?.initialDateOfInvestment.text = dateString
            }
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] text in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAverageTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] text in
            self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
        }.store(in: &cancellables)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex).sink { initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex in
            <#code#>
        }.store(in: &cancellables)
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAverageTextField.addDoneButton()
        initialDateOfInvestment.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection", let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController, let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index: Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getyMonthInfo() {
            initialDateOfInvestmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialInvestmentAmountTextField.text = dateString
        }
    }
    
    @IBAction func dateSliderDidCange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
}
