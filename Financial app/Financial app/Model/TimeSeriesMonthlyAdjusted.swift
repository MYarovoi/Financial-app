//
//  TimeSeriesMonthlyAdjusted.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 09.02.2025.
//

import Foundation

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct TimeSeriesMonthlyAdjusted: Decodable {
    let meta: Meta
    let timeSeries: [String: OHLC]
    
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthInfo() -> [MonthInfo] {
        var monthInfos: [MonthInfo] = []
        let sortedtimeSeries = timeSeries.sorted(by: {$0.key > $1.key})
        
        for (dateString, ohlc) in sortedtimeSeries {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else { return [] }
            guard let adjustedOpen = getAdjustedClose(ohlc: ohlc) else { return [] }
            guard let adjustedClose = ohlc.adjustedClose.toDouble() else { return [] }
            
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
}
    
    private func getAdjustedClose(ohlc: OHLC) -> Double? {
        guard let open = ohlc.open.toDouble(),
                let adjustedClose = ohlc.adjustedClose.toDouble(),
                let close = ohlc.close.toDouble() else { return nil }
        
        return open * adjustedClose / close
    }

struct Meta: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct OHLC: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
