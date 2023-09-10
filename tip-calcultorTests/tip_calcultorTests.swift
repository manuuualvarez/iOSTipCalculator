//
//  tip_calcultorTests.swift
//  tip-calcultorTests
//
//  Created by Manny Alvarez on 08/09/2023.
//

import XCTest
import Combine
@testable import tip_calcultor

final class tip_calcultorTests: XCTestCase {
    
    // System Under Test (SUT)
    private var sut: CalculatorViewModel!
    // Properties
    private var cancellables: Set<AnyCancellable>!
    private var logoViewTapPublisher: PassthroughSubject<Void, Never>!
    private var audioPlayer: AudioPlayerMock!
    
    override func setUp() {
        audioPlayer = AudioPlayerMock()
        sut = .init(audioPlayer: audioPlayer)
        logoViewTapPublisher = .init()
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
        audioPlayer = nil
        logoViewTapPublisher = nil
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorViewModel.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapPublisher.eraseToAnyPublisher()
        )
    }
    
    func testResultForOnePersonWithoutTip() {
        //Given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)
        //When
        let output = sut.transform(input: input)
        //Then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100.0)
            XCTAssertEqual(result.totalTip, 0)
            XCTAssertEqual(result.totalBill, 100.0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipForTwoPersons() {
        //Given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //When
        let output = sut.transform(input: input)
        //Then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalTip, 0)
            XCTAssertEqual(result.totalBill, 100.0)
        }.store(in: &cancellables)
    }
    
    func testResultTenPercentTipForTwoPersons() {
        //Given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //When
        let output = sut.transform(input: input)
        //Then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalTip, 10)
            XCTAssertEqual(result.totalBill, 110.0)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipForTwoPersons() {
        //Given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 20)
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //When
        let output = sut.transform(input: input)
        //Then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 60)
            XCTAssertEqual(result.totalTip, 20)
            XCTAssertEqual(result.totalBill, 120.0)
        }.store(in: &cancellables)
    }
    
    func testSoundPlayedAndCalculatorresetOnLogoView() {
        //Given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 1)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        let expectation2 = audioPlayer.expectation
        //Then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellables)
        //When
        logoViewTapPublisher.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    
}

class AudioPlayerMock: AudioPlayerService {
    var expectation = XCTestExpectation(description: "playSound called")
    func playSound() {
        expectation.fulfill()
    }
}
