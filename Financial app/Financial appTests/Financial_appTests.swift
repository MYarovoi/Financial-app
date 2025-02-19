//
//  Financial_appTests.swift
//  Financial appTests
//
//  Created by Mykyta Yarovoi on 18.02.2025.
//

import XCTest
@testable import Financial_app

class Financial_appTests: XCTestCase {
    var sut: DCAService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        //given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAvetagingAmount: Double = 1000
        let initialDateOfInvestmentIndex = 5
        let asset = buildWinningAsset()
        //when
        let result = sut.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        XCTAssertEqual(result.investmentAmount, 10000)
        XCTAssertTrue(result.isProfitable)
        XCTAssertEqual(result.currentValue, 14228.17, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4228.17, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3873, accuracy: 0.1)
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        //given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAvetagingAmount: Double = 0
        let initialDateOfInvestmentIndex = 3
        let asset = buildWinningAsset()
        //when
        let result = sut.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProfitable)
        XCTAssertEqual(result.currentValue, 6666.66, accuracy: 0.1)
        XCTAssertEqual(result.gain, 1666.66, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.333, accuracy: 0.1)
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        //given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAvetagingAmount: Double = 1500
        let initialDateOfInvestmentIndex = 5
        let asset = buildLosingAsset()
        //when
        let result = sut.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertFalse(result.isProfitable)
        XCTAssertEqual(result.currentValue, 9189.32, accuracy: 0.1)
        XCTAssertEqual(result.gain, -3310.65, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.2648, accuracy: 0.1)
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        //given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAvetagingAmount: Double = 0
        let initialDateOfInvestmentIndex = 5
        let asset = buildLosingAsset()
        //when
        let result = sut.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        //then
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertFalse(result.isProfitable)
        XCTAssertEqual(result.currentValue, 3235.29, accuracy: 0.1)
        XCTAssertEqual(result.gain, -1764.70, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.2648, accuracy: 0.1)
    }
    
    private func buildLosingAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String : OHLC] = ["2024-01-25" : OHLC(open: "170", close: "160", adjustedClose: "160"),
                                           "2024-02-25" : OHLC(open: "160", close: "150", adjustedClose: "150"),
                                           "2024-03-25" : OHLC(open: "150", close: "140", adjustedClose: "140"),
                                           "2024-04-25" : OHLC(open: "140", close: "130", adjustedClose: "130"),
                                           "2024-05-25" : OHLC(open: "130", close: "120", adjustedClose: "120"),
                                           "2024-06-25" : OHLC(open: "120", close: "110", adjustedClose: "110")]
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let meta = buildMeta()
        let timeSeries: [String : OHLC] = ["2024-01-25" : OHLC(open: "100", close: "110", adjustedClose: "110"),
                                           "2024-02-25" : OHLC(open: "110", close: "120", adjustedClose: "120"),
                                           "2024-03-25" : OHLC(open: "120", close: "130", adjustedClose: "130"),
                                           "2024-04-25" : OHLC(open: "130", close: "140", adjustedClose: "140"),
                                           "2024-05-25" : OHLC(open: "140", close: "150", adjustedClose: "150"),
                                           "2024-06-25" : OHLC(open: "150", close: "160", adjustedClose: "160")]
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: meta, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZ", type: "ETF", currency: "USD")
    }
    
    private func buildMeta() -> Meta {
        return Meta(symbol: "XYZ")
    }
    
    func testInvestmentAmount_whenDCAIsUsed_expectResult() {
        //given
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAvetagingAmount: Double = 100
        let initialDateOfInvestmentIndex = 3
        
        //when
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        //then
        XCTAssertEqual(investmentAmount, 800)
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        //given
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAvetagingAmount: Double = 0
        let initialDateOfInvestmentIndex = 3
        
        //when
        let investmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDollarCostAvetagingAmount: monthlyDollarCostAvetagingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        //then
        XCTAssertEqual(investmentAmount, 500)
    }
}
