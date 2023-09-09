//
//  Double+Extension.swift
//  tip-calcultor
//
//  Created by Manny Alvarez on 09/09/2023.
//

import Foundation

extension Double {
    var currencyFormatt: String {
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}
