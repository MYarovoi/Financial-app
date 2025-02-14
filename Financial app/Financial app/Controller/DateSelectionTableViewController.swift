//
//  DateSelectionTableViewController.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 13.02.2025.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    private var monthInfo: [MonthInfo] = []
    var selectedIndex: Int?
    
    var didSelectDate: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfos()
        setupnavigation()
    }
    
    private func setupnavigation() {
        title = "Select date"
    }
    
    private func setupMonthInfos() {
        monthInfo = timeSeriesMonthlyAdjusted?.getMonthInfo() ?? []
    }
}

extension DateSelectionTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DateSelectionTableViewCell
        let index = indexPath.item
        let monthInfo = monthInfo[index]
        let isSelected = index == selectedIndex
        cell.configure(with: monthInfo, index: index, isSelected: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class  DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var mothsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelected: Bool) {
        monthLabel.text = monthInfo.date.MMYYFormat
        
        accessoryType = isSelected ? .checkmark : .none
        
        if index == 1 {
            mothsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            mothsAgoLabel.text = "\(index) months ago"
        } else {
            mothsAgoLabel.text = "Just invested"
        }
    }
}
