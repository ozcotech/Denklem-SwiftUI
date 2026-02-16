//
//  Tariff2026.swift
//  Denklem
//
//  Created by ozkan on 20.07.2025.
//

import Foundation

// MARK: - Tariff 2026 Implementation
/// Implementation of TariffProtocol for 2026 tariff data
/// Official tariff rates and fees for 2026
struct Tariff2026: TariffProtocol {
    
    // MARK: - Basic Properties
    
    let year: Int = 2026
    
    let isFinalized: Bool = true
    
    // MARK: - Minimum Hours Multiplier
    
    let minimumHoursMultiplier: Int = 2
    
    // MARK: - Hourly Rates
    
    let hourlyRates: [String: Double] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: 1130.0,        
        DisputeConstants.DisputeTypeKeys.commercial: 1500.0,           
        DisputeConstants.DisputeTypeKeys.consumer: 1000.0,             
        DisputeConstants.DisputeTypeKeys.rent: 1170.0,                 
        DisputeConstants.DisputeTypeKeys.neighbor: 1170.0,
        DisputeConstants.DisputeTypeKeys.condominium: 1170.0,          
        DisputeConstants.DisputeTypeKeys.family: 1000.00,               
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: 1170.0, 
        DisputeConstants.DisputeTypeKeys.agriculturalProduction: 1000.0,
        DisputeConstants.DisputeTypeKeys.other: 1000.0                 
    ]
    
    // MARK: - Fixed Fees
    
    /// Fixed fees by dispute type and party count ranges
    /// Array indices: [0: 2 parties, 1: 3-5 parties, 2: 6-10 parties, 3: 11+ parties]
    /// Threshold logic: partyCount <= 2, <= 5, <= 10, <= Int.max
    let fixedFees: [String: [Double]] = [
        DisputeConstants.DisputeTypeKeys.workerEmployer: [2260.0, 2460.0, 2560.0, 2660.0],    
        DisputeConstants.DisputeTypeKeys.commercial: [3000.0, 3200.0, 3300.0, 3400.0],        
        DisputeConstants.DisputeTypeKeys.consumer: [2000.0, 2200.0, 2300.0, 2400.0],          
        DisputeConstants.DisputeTypeKeys.rent: [2340.0, 2540.0, 2640.0, 2740.0],              
        DisputeConstants.DisputeTypeKeys.neighbor: [2340.0, 2540.0, 2640.0, 2740.0],          
        DisputeConstants.DisputeTypeKeys.condominium: [2340.0, 2540.0, 2640.0, 2740.0],       
        DisputeConstants.DisputeTypeKeys.family: [2000.0, 2200.0, 2300.0, 2400.0],            
        DisputeConstants.DisputeTypeKeys.partnershipDissolution: [2340.0, 2540.0, 2640.0, 2740.0], 
        DisputeConstants.DisputeTypeKeys.agriculturalProduction: [2000.0, 2200.0, 2300.0, 2400.0],
        DisputeConstants.DisputeTypeKeys.other: [2000.0, 2200.0, 2300.0, 2400.0]             
    ]
    
    /// Party count thresholds for fee calculation
    let partyCountThresholds: [Int] = [2, 5, 10, Int.max]
    
    // MARK: - Minimum Fees
    
    let minimumFees: [String: Double] = [
        "general": 9000.0,     
        "commercial": 13000.0  
    ]
    
    // MARK: - Calculation Brackets

/// Progressive calculation brackets for agreement cases
/// Format: (cumulative upper limit, percentage rate)
///
/// Official Tariff → Code Conversion:
/// | Official (Tier Amount) | Cumulative Limit |
/// |------------------------|------------------|
/// | First 600,000          | 600,000          |
/// | Next 960,000           | 1,560,000        |
/// | Next 1,560,000         | 3,120,000        |
/// | Next 3,120,000         | 6,240,000        |
/// | Next 9,360,000         | 15,600,000       |
/// | Next 12,480,000        | 28,080,000       |
/// | Next 24,960,000        | 53,040,000       |
/// | Above                  | ∞                |
let brackets: [(limit: Double, rate: Double)] = [
    (600000.0, 0.06),       // First 600,000 TL: 6%
    (1560000.0, 0.05),      // 600,001 - 1,560,000 TL: 5%
    (3120000.0, 0.04),      // 1,560,001 - 3,120,000 TL: 4%
    (6240000.0, 0.03),      // 3,120,001 - 6,240,000 TL: 3%
    (15600000.0, 0.02),     // 6,240,001 - 15,600,000 TL: 2%
    (28080000.0, 0.015),    // 15,600,001 - 28,080,000 TL: 1.5%
    (53040000.0, 0.01),     // 28,080,001 - 53,040,000 TL: 1%
    (Double.infinity, 0.005) // 53,040,001+ TL: 0.5%
]


}

// MARK: - Tariff 2026 Factory
extension Tariff2026 {
    
    /// Creates a new Tariff2026 instance
    static func create() -> Tariff2026 {
        return Tariff2026()
    }
}

// MARK: - Tariff 2026 Validation Protocol Conformance
extension Tariff2026: TariffValidationProtocol {}
