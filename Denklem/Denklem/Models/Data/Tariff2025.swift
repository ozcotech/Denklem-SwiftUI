//
//  Tariff2025.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff 2025 Implementation
/// Implementation of TariffProtocol for 2025 tariff data
/// Uses actual tariff rates and fees from TariffConstants.Tariff2025
struct Tariff2025: TariffProtocol {
    
    // MARK: - Basic Properties
    
    let year: Int = 2025
    
    let isFinalized: Bool = true
    
    // MARK: - Minimum Hours Multiplier
    
    let minimumHoursMultiplier: Int = 2
    
    // MARK: - Hourly Rates (from TariffConstants.Tariff2025)
    
    let hourlyRates: [String: Double] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: 785.0,
        DisputeConstants.DisputeTypeKeys.commercial: 1150.0,
        DisputeConstants.DisputeTypeKeys.consumer: 785.0,
        DisputeConstants.DisputeTypeKeys.rent: 835.0,
        DisputeConstants.DisputeTypeKeys.neighbor: 835.0,
        DisputeConstants.DisputeTypeKeys.condominium: 835.0,
        DisputeConstants.DisputeTypeKeys.family: 785.0,
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: 900.0,
        DisputeConstants.DisputeTypeKeys.agriculturalProduction: 785.0,
        DisputeConstants.DisputeTypeKeys.other: 785.0
    ]
    
    // MARK: - Fixed Fees (from TariffConstants.Tariff2025)
    
    /// Fixed fees by dispute type and party count ranges
    /// Array indices: [0: 2 parties, 1: 3-5 parties, 2: 6-10 parties, 3: 11+ parties]
    /// Threshold logic: partyCount <= 2, <= 5, <= 10, <= Int.max
    let fixedFees: [String: [Double]] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.commercial: [2300.0, 2350.0, 2450.0, 2550.0],
        DisputeConstants.DisputeTypeKeys.consumer: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.rent: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.neighbor: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.condominium: [1670.0, 1750.0, 1850.0, 1950.0],
        DisputeConstants.DisputeTypeKeys.family: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: [1800.0, 2000.0, 2100.0, 2200.0],
        DisputeConstants.DisputeTypeKeys.agriculturalProduction: [1570.0, 1650.0, 1750.0, 1850.0],
        DisputeConstants.DisputeTypeKeys.other: [1570.0, 1650.0, 1750.0, 1850.0]
    ]
    
    /// Party count thresholds for fee calculation
    let partyCountThresholds: [Int] = [2, 5, 10, Int.max]
    
    // MARK: - Minimum Fees (from TariffConstants.Tariff2025)
    
    let minimumFees: [String: Double] = [
        "general": 6000.0,    // General minimum fee for most dispute types
        "commercial": 9000.0  // Higher minimum for commercial disputes
    ]
    
    // MARK: - Calculation Brackets (from TariffConstants.Tariff2025)
    
    /// Progressive calculation brackets for agreement cases
    /// Format: (upper limit, percentage rate)
    let brackets: [(limit: Double, rate: Double)] = [
        (300000.0, 0.06),       // 0-300,000 TL: 6%
        (780000.0, 0.05),       // 300,001-780,000 TL: 5%
        (1560000.0, 0.04),      // 780,001-1,560,000 TL: 4%
        (4680000.0, 0.03),      // 1,560,001-4,680,000 TL: 3%
        (6240000.0, 0.02),      // 4,680,001-6,240,000 TL: 2%
        (12480000.0, 0.015),    // 6,240,001-12,480,000 TL: 1.5%
        (26520000.0, 0.01),     // 12,480,001-26,520,000 TL: 1%
        (Double.infinity, 0.005) // 26,520,001+ TL: 0.5%
    ]

}

// MARK: - Tariff 2025 Factory
extension Tariff2025 {
    
    /// Creates a new Tariff2025 instance
    static func create() -> Tariff2025 {
        return Tariff2025()
    }
}

// MARK: - Tariff 2025 Validation Protocol Conformance
extension Tariff2025: TariffValidationProtocol {}
