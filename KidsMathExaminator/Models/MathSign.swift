//
//  MathSign.swift
//  KidsMathExaminator
//

import Foundation

enum MathSign: String, CaseIterable, Hashable, Identifiable {
    case plus
    case minus
    case multiplication
    case division

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        }
    }

    func result(_ first: Int, _ second: Int) -> Int {
        switch self {
        case .plus:
            return first + second
        case .minus:
            return first - second
        case .multiplication:
            return first * second
        case .division:
            return first / second
        }
    }
}
