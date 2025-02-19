//
//  CalculatorPresenterTest.swift
//  Financial appTests
//
//  Created by Mykyta Yarovoi on 18.02.2025.
//

import XCTest
@testable import Financial_app

final class CalculatorPresenterTest: XCTestCase {
    var sut: CalculatorPresenter!

    override func setUpWithError() throws {
        sut = CalculatorPresenter()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        //given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: true)
        //when
        let presentation = sut.getPresentation(result: result)
        //then
        XCTAssertEqual(presentation.anualReturnLabelTextColor, .themeGreenShade)
    }
    
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        //given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: true)
        //when
        let presentation = sut.getPresentation(result: result)
        //then
        XCTAssertEqual(presentation.anualReturnLabelTextColor, .themeGreenShade)
    }
    
    func testAnnualReturnLabelTextColor_givenResultIsNonProfitable_expectRed() {
        //given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: false)
        //when
        let presentation = sut.getPresentation(result: result)
        //then
        XCTAssertEqual(presentation.anualReturnLabelTextColor, .themeRedShade)
    }
    
    func testYieldLabelTextColor_givenResultIsNonProfitable_expectSystemRed() {
        //given
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0,
                               annualReturn: 0,
                               isProfitable: false)
        //when
        let presentation = sut.getPresentation(result: result)
        //then
        XCTAssertEqual(presentation.anualReturnLabelTextColor, .themeRedShade)
    }
    
    func testYieldLabel_expectBrackets() {
        //given
        let openBracket: Character = "("
        let closeBracket: Character = ")"
        let result = DCAResult(currentValue: 0,
                               investmentAmount: 0,
                               gain: 0,
                               yield: 0.25,
                               annualReturn: 0,
                               isProfitable: false)
        //when
        let presentation = sut.getPresentation(result: result)
        //then
        XCTAssertEqual(presentation.yieldLabel.first, openBracket)
        XCTAssertEqual(presentation.yieldLabel.last, closeBracket)
    }
}
