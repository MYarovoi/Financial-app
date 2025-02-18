//
//  DCAService.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 13.02.2025.
//

import Foundation

struct DCAService {
    func calculate(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAvetagingAmount: Double, initialDateOfInvestmentIndex: Int) -> DCAResult {
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                                   monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount,
                                                   initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let latestSharePrice = gatLatestsharePrice(asset: asset)
        let numberOfShares = getNumberOfShares(asset: asset,
                                               initialInvestmentAmount: initialInvestmentAmount,
                                               monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount,
                                               initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let currentValue = getCurrentValue(numberofShares: numberOfShares, latestSharePrice: latestSharePrice)
        let isProfitable = currentValue > investmentAmount
        let gain = currentValue - investmentAmount
        let yield = gain / investmentAmount
        let annualReturn = getAnualReturn(currentvalue: currentValue,
                                         investmentAmount: investmentAmount,
                                         initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProfitable: isProfitable)
    }
    
    private func getAnualReturn(currentvalue:Double, investmentAmount:Double, initialDateOfInvestmentIndex:Int) -> Double {
        let rate = currentvalue / investmentAmount
        let years = ((initialDateOfInvestmentIndex.doubleValue + 1) / 12)
        
        return pow(rate, (1 / years)) - 1
    }
    
    private func getInvestmentAmount(initialInvestmentAmount: Double, monthlyDollarCostAvetagingAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAvetagingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAvetagingAmount
        totalAmount += dollarCostAvetagingAmount
        return totalAmount
    }
    
    private func getCurrentValue(numberofShares: Double, latestSharePrice: Double) -> Double {
        return numberofShares * latestSharePrice
    }
    
    private func gatLatestsharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfo().first?.adjustedClose ?? 0.0
    }
    
    private func getNumberOfShares(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAvetagingAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        var totalShares = Double()
        let initialInvestmentOpenPrie = asset.timeSeriesMonthlyAdjusted.getMonthInfo()[initialDateOfInvestmentIndex].adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrie
        totalShares += initialInvestmentShares
        asset.timeSeriesMonthlyAdjusted.getMonthInfo().prefix(initialDateOfInvestmentIndex).forEach { monthInfo in
            let dcaInvestmentShares = monthlyDollarCostAvetagingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        return totalShares
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
