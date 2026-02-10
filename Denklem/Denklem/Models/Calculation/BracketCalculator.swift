//
//  BracketCalculator.swift
//  Denklem
//
//  Shared bracket-based fee calculation utility.
//  Eliminates duplicate progressive bracket calculation logic
//  across AttorneyFeeCalculator and TenancyCalculator.
//

import Foundation

// MARK: - Bracket Calculator
/// Utility for progressive bracket-based fee calculations.
/// Used by both AttorneyFeeCalculator and TenancyCalculator
/// for third-part (attorney fee) bracket computations.
enum BracketCalculator {
    
    /// Calculates fee using progressive bracket system
    /// - Parameters:
    ///   - amount: The monetary amount to calculate fee for
    ///   - brackets: Progressive brackets with (limit, rate, cumulativeLimit)
    /// - Returns: Total calculated fee based on progressive brackets
    static func calculateFee(
        amount: Double,
        brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)]
    ) -> Double {
        var remaining = amount
        var total: Double = 0
        
        for bracket in brackets {
            let take = min(remaining, bracket.limit)
            total += take * bracket.rate
            remaining -= take
            if remaining <= 0 { break }
        }
        
        return total
    }
}
