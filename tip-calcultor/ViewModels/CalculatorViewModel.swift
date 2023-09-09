//
//  CalculatorViewModel.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 08/09/2023.
//

import Foundation
import Combine


class CalculatorViewModel {
    // MARK: - Properties
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Data FROM the ViewController
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    // MARK: - Data for the ViewController
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    // MARK: - Public Methods
    func transform(input: Input) -> Output {
        let updateViewPublisher =
        Publishers.CombineLatest3(input.billPublisher, input.tipPublisher, input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
            
            let totalTip = getTipAmount(bill: bill, tip: tip)
            let totalBill = bill + totalTip
            let amountPerPerson = totalBill / Double(split)
            let result = Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)
            return Just(result)
        }
        .eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher)
    }
    
    // MARK: - Private Methods
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.10
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.20
        case .custom(let value):
            return Double(value)
        }
    }
}
