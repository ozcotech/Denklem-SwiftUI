//
//  SMMCalculator.swift
//  Denklem
//
//  Created by ozkan on 25.07.2025.
//

import Foundation

// MARK: - SMM Calculator
/// Calculator for freelance receipt (SMM) calculations
/// Handles different VAT and withholding tax scenarios for real and legal persons
struct SMMCalculator {
    
    // MARK: - Constants from TariffConstants
    private static let kdvRate = TariffConstants.kdvRate // 0.20 (20%)
    private static let stopajRate = TariffConstants.stopajRate // 0.20 (20%)
    
    // MARK: - Main Calculation Method
    
    /// Calculates SMM fees for given input
    /// - Parameter input: SMMCalculationInput domain model
    /// - Returns: SMMCalculationResult with detailed breakdown
    static func calculateSMM(input: SMMCalculationInput) -> SMMCalculationResult {
        // Validate input first
        let validation = input.validate()
        guard validation.isValid else {
            return SMMCalculationResult.failure(input: input, error: validation.errorMessage ?? "Invalid SMM input")
        }
        
        let baseAmount = input.amount
        let calculationType = input.calculationType
        
        // Calculate for both person types
        let realPersonResult = calculateForPersonType(.realPerson, baseAmount: baseAmount, calculationType: calculationType)
        let legalPersonResult = calculateForPersonType(.legalPerson, baseAmount: baseAmount, calculationType: calculationType)
        
        // Create calculation breakdown
        let breakdown = SMMCalculationBreakdown(
            baseAmount: baseAmount,
            calculationType: calculationType,
            realPersonBreakdown: realPersonResult.breakdown,
            legalPersonBreakdown: legalPersonResult.breakdown,
            kdvRate: kdvRate,
            stopajRate: stopajRate
        )
        
        return SMMCalculationResult(
            input: input,
            realPersonResult: realPersonResult.result,
            legalPersonResult: legalPersonResult.result,
            breakdown: breakdown
        )
    }
    
    // MARK: - Person Type Calculation
    
    /// Calculates SMM for specific person type
    /// - Parameters:
    ///   - personType: Real person or legal person
    ///   - baseAmount: Base calculation amount
    ///   - calculationType: SMM calculation type (VAT/withholding combinations)
    /// - Returns: Calculation result for the person type
    private static func calculateForPersonType(
        _ personType: SMMPersonType,
        baseAmount: Double,
        calculationType: SMMCalculationType
    ) -> (result: SMMPersonResult, breakdown: SMMPersonBreakdown) {
        
        var brutFee: Double = 0.0
        var kdv: Double = 0.0
        var stopaj: Double = 0.0
        var netFee: Double = 0.0
        var tahsilEdilecekTutar: Double = 0.0
        
        var steps: [String] = []
        
        switch calculationType {
        case .vatIncludedWithholdingExcluded:
            // KDV Dahil, Stopaj Hariç
            // Base amount already includes VAT
            tahsilEdilecekTutar = baseAmount
            brutFee = baseAmount / (1 + kdvRate) // Remove VAT to get gross fee
            kdv = baseAmount - brutFee
            
            if personType == .legalPerson {
                stopaj = brutFee * stopajRate
                netFee = brutFee - stopaj
            } else {
                stopaj = 0.0 // Real persons don't have withholding tax
                netFee = brutFee
            }
            
            steps.append("Base amount (VAT included): \(LocalizationHelper.formatCurrency(baseAmount))")
            steps.append("Gross fee (VAT excluded): \(LocalizationHelper.formatCurrency(brutFee))")
            steps.append("VAT (20%): \(LocalizationHelper.formatCurrency(kdv))")
            if personType == .legalPerson {
                steps.append("Withholding tax (20%): \(LocalizationHelper.formatCurrency(stopaj))")
            }
            steps.append("Net fee: \(LocalizationHelper.formatCurrency(netFee))")
            steps.append("Total collected: \(LocalizationHelper.formatCurrency(tahsilEdilecekTutar))")
            
        case .vatExcludedWithholdingIncluded:
            // KDV Hariç, Stopaj Dahil
            // Base amount excludes VAT but includes withholding effect
            if personType == .legalPerson {
                // Net amount is given, need to calculate gross
                netFee = baseAmount
                brutFee = netFee / (1 - stopajRate) // Reverse calculate gross from net
                stopaj = brutFee - netFee
            } else {
                // No withholding for real persons
                brutFee = baseAmount
                stopaj = 0.0
                netFee = brutFee
            }
            
            kdv = brutFee * kdvRate
            tahsilEdilecekTutar = brutFee + kdv
            
            steps.append("Base amount: \(LocalizationHelper.formatCurrency(baseAmount))")
            steps.append("Gross fee (VAT excluded): \(LocalizationHelper.formatCurrency(brutFee))")
            if personType == .legalPerson {
                steps.append("Withholding tax (20%): \(LocalizationHelper.formatCurrency(stopaj))")
            }
            steps.append("Net fee: \(LocalizationHelper.formatCurrency(netFee))")
            steps.append("VAT (20%): \(LocalizationHelper.formatCurrency(kdv))")
            steps.append("Total collected: \(LocalizationHelper.formatCurrency(tahsilEdilecekTutar))")
            
        case .vatIncludedWithholdingIncluded:
            // KDV Dahil, Stopaj Dahil
            // Base amount includes both VAT and withholding effect
            tahsilEdilecekTutar = baseAmount
            
            if personType == .legalPerson {
                // Work backwards from total collected amount
                // Total = (Gross - Stopaj) + VAT
                // Total = Gross - (Gross * stopajRate) + (Gross * kdvRate)
                // Total = Gross * (1 - stopajRate + kdvRate)
                brutFee = baseAmount / (1 - stopajRate + kdvRate)
                stopaj = brutFee * stopajRate
                netFee = brutFee - stopaj
            } else {
                // No withholding for real persons
                brutFee = baseAmount / (1 + kdvRate)
                stopaj = 0.0
                netFee = brutFee
            }
            
            kdv = brutFee * kdvRate
            
            steps.append("Base amount (VAT+withholding included): \(LocalizationHelper.formatCurrency(baseAmount))")
            steps.append("Gross fee (VAT excluded): \(LocalizationHelper.formatCurrency(brutFee))")
            if personType == .legalPerson {
                steps.append("Withholding tax (20%): \(LocalizationHelper.formatCurrency(stopaj))")
            }
            steps.append("Net fee: \(LocalizationHelper.formatCurrency(netFee))")
            steps.append("VAT (20%): \(LocalizationHelper.formatCurrency(kdv))")
            steps.append("Total collected: \(LocalizationHelper.formatCurrency(tahsilEdilecekTutar))")
            
        case .vatExcludedWithholdingExcluded:
            // KDV Hariç, Stopaj Hariç
            // Base amount is pure gross fee
            brutFee = baseAmount
            kdv = brutFee * kdvRate
            
            if personType == .legalPerson {
                stopaj = brutFee * stopajRate
                netFee = brutFee - stopaj
            } else {
                stopaj = 0.0
                netFee = brutFee
            }
            
            tahsilEdilecekTutar = brutFee + kdv
            
            steps.append("Base amount (gross fee): \(LocalizationHelper.formatCurrency(baseAmount))")
            steps.append("Gross fee (VAT excluded): \(LocalizationHelper.formatCurrency(brutFee))")
            if personType == .legalPerson {
                steps.append("Withholding tax (20%): \(LocalizationHelper.formatCurrency(stopaj))")
            }
            steps.append("Net fee: \(LocalizationHelper.formatCurrency(netFee))")
            steps.append("VAT (20%): \(LocalizationHelper.formatCurrency(kdv))")
            steps.append("Total collected: \(LocalizationHelper.formatCurrency(tahsilEdilecekTutar))")
        }
        
        let result = SMMPersonResult(
            personType: personType,
            brutFee: brutFee,
            stopaj: stopaj,
            netFee: netFee,
            kdv: kdv,
            tahsilEdilecekTutar: tahsilEdilecekTutar
        )
        
        let breakdown = SMMPersonBreakdown(
            personType: personType,
            steps: steps,
            brutFee: brutFee,
            stopaj: stopaj,
            netFee: netFee,
            kdv: kdv,
            tahsilEdilecekTutar: tahsilEdilecekTutar
        )
        
        return (result, breakdown)
    }
}

// MARK: - SMM Calculation Input
/// Input parameters for SMM calculation
struct SMMCalculationInput {
    
    // MARK: - Required Properties
    
    /// Base amount for calculation
    let amount: Double
    
    /// Type of SMM calculation (VAT/withholding combinations)
    let calculationType: SMMCalculationType
    
    /// Timestamp when calculation was requested
    let calculationDate: Date
    
    // MARK: - Initializers
    
    init(amount: Double, calculationType: SMMCalculationType) {
        self.amount = amount
        self.calculationType = calculationType
        self.calculationDate = Date()
    }
    
    // MARK: - Validation
    
    /// Validates the SMM calculation input
    /// - Returns: ValidationResult indicating success or failure
    func validate() -> ValidationResult {
        // Validate amount
        let amountValidation = ValidationConstants.validateSMMAmount(amount)
        if !amountValidation.isValid {
            return amountValidation
        }
        
        // Validate calculation type
        let typeValidation = ValidationConstants.validateSMMCalculationType(calculationType.rawValue)
        if !typeValidation.isValid {
            return typeValidation
        }
        
        return .success
    }
}

// MARK: - SMM Person Type
/// Represents the type of person for SMM calculation
enum SMMPersonType: String, CaseIterable {
    case realPerson = "real_person"
    case legalPerson = "legal_person"
    
    var displayName: String {
        switch self {
        case .realPerson:
            return NSLocalizedString(LocalizationKeys.SMMResult.realPerson, comment: "")
        case .legalPerson:
            return NSLocalizedString(LocalizationKeys.SMMResult.legalPerson, comment: "")
        }
    }
    
    /// Whether this person type is subject to withholding tax
    var hasWithholdingTax: Bool {
        switch self {
        case .realPerson:
            return false
        case .legalPerson:
            return true
        }
    }
}

// MARK: - SMM Person Result
/// Calculation result for a specific person type
struct SMMPersonResult {
    
    /// Person type (real or legal)
    let personType: SMMPersonType
    
    /// Gross fee (VAT excluded)
    let brutFee: Double
    
    /// Withholding tax amount (20% for legal persons, 0 for real persons)
    let stopaj: Double
    
    /// Net fee (gross - withholding)
    let netFee: Double
    
    /// VAT amount (20% of gross fee)
    let kdv: Double
    
    /// Total amount to be collected
    let tahsilEdilecekTutar: Double
    
    // MARK: - Computed Properties
    
    /// Formatted gross fee
    var formattedBrutFee: String {
        return LocalizationHelper.formatCurrencyForDisplay(brutFee)
    }
    
    /// Formatted withholding tax
    var formattedStopaj: String {
        return LocalizationHelper.formatCurrencyForDisplay(stopaj)
    }
    
    /// Formatted net fee
    var formattedNetFee: String {
        return LocalizationHelper.formatCurrencyForDisplay(netFee)
    }
    
    /// Formatted VAT
    var formattedKdv: String {
        return LocalizationHelper.formatCurrencyForDisplay(kdv)
    }
    
    /// Formatted total collected amount
    var formattedTahsilEdilecekTutar: String {
        return LocalizationHelper.formatCurrencyForDisplay(tahsilEdilecekTutar)
    }
}

// MARK: - SMM Person Breakdown
/// Detailed breakdown for a specific person type
struct SMMPersonBreakdown {
    
    /// Person type
    let personType: SMMPersonType
    
    /// Calculation steps
    let steps: [String]
    
    /// Result amounts
    let brutFee: Double
    let stopaj: Double
    let netFee: Double
    let kdv: Double
    let tahsilEdilecekTutar: Double
    
    /// Formatted breakdown text
    var formattedBreakdown: String {
        return steps.joined(separator: "\n")
    }
}

// MARK: - SMM Calculation Breakdown
/// Overall calculation breakdown for SMM
struct SMMCalculationBreakdown {
    
    /// Base amount used for calculation
    let baseAmount: Double
    
    /// Calculation type used
    let calculationType: SMMCalculationType
    
    /// Breakdown for real person
    let realPersonBreakdown: SMMPersonBreakdown
    
    /// Breakdown for legal person
    let legalPersonBreakdown: SMMPersonBreakdown
    
    /// Applied rates
    let kdvRate: Double
    let stopajRate: Double
    
    // MARK: - Computed Properties
    
    /// Summary of calculation
    var summary: String {
        return """
        SMM Calculation Summary
        Base Amount: \(LocalizationHelper.formatCurrency(baseAmount))
        Calculation Type: \(calculationType.displayName)
        VAT Rate: \(LocalizationHelper.formatPercentage(kdvRate))
        Withholding Rate: \(LocalizationHelper.formatPercentage(stopajRate))
        """
    }
}

// MARK: - SMM Calculation Result
/// Complete result of SMM calculation
struct SMMCalculationResult {
    
    /// Input parameters used
    let input: SMMCalculationInput
    
    /// Result for real person
    let realPersonResult: SMMPersonResult
    
    /// Result for legal person
    let legalPersonResult: SMMPersonResult
    
    /// Detailed calculation breakdown
    let breakdown: SMMCalculationBreakdown
    
    /// Timestamp when calculation was completed
    let calculationDate: Date
    
    /// Whether calculation was successful
    let isSuccess: Bool
    
    /// Error message if calculation failed
    let errorMessage: String?
    
    // MARK: - Initializers
    
    /// Initializer for successful calculation
    init(input: SMMCalculationInput,
         realPersonResult: SMMPersonResult,
         legalPersonResult: SMMPersonResult,
         breakdown: SMMCalculationBreakdown) {
        
        self.input = input
        self.realPersonResult = realPersonResult
        self.legalPersonResult = legalPersonResult
        self.breakdown = breakdown
        self.calculationDate = Date()
        self.isSuccess = true
        self.errorMessage = nil
    }
    
    /// Initializer for failed calculation
    init(input: SMMCalculationInput, error: String) {
        self.input = input
        
        // Create empty results for failed calculation
        self.realPersonResult = SMMPersonResult(
            personType: .realPerson,
            brutFee: 0.0,
            stopaj: 0.0,
            netFee: 0.0,
            kdv: 0.0,
            tahsilEdilecekTutar: 0.0
        )
        
        self.legalPersonResult = SMMPersonResult(
            personType: .legalPerson,
            brutFee: 0.0,
            stopaj: 0.0,
            netFee: 0.0,
            kdv: 0.0,
            tahsilEdilecekTutar: 0.0
        )
        
        self.breakdown = SMMCalculationBreakdown(
            baseAmount: input.amount,
            calculationType: input.calculationType,
            realPersonBreakdown: SMMPersonBreakdown(
                personType: .realPerson,
                steps: ["Calculation failed"],
                brutFee: 0.0,
                stopaj: 0.0,
                netFee: 0.0,
                kdv: 0.0,
                tahsilEdilecekTutar: 0.0
            ),
            legalPersonBreakdown: SMMPersonBreakdown(
                personType: .legalPerson,
                steps: ["Calculation failed"],
                brutFee: 0.0,
                stopaj: 0.0,
                netFee: 0.0,
                kdv: 0.0,
                tahsilEdilecekTutar: 0.0
            ),
            kdvRate: TariffConstants.kdvRate,
            stopajRate: TariffConstants.stopajRate
        )
        
        self.calculationDate = Date()
        self.isSuccess = false
        self.errorMessage = error
    }
    
    // MARK: - Export Methods
    
    /// Returns SMM calculation data for export
    /// - Returns: Dictionary with exportable data
    func toExportData() -> [String: Any] {
        var data: [String: Any] = [
            "calculationDate": LocalizationHelper.formatDateForExport(calculationDate),
            "isSuccess": isSuccess,
            "baseAmount": LocalizationHelper.formatCurrencyForExport(input.amount),
            "calculationType": input.calculationType.displayName
        ]
        
        if isSuccess {
            // Real person data
            data["realPerson_brutFee"] = LocalizationHelper.formatCurrencyForExport(realPersonResult.brutFee)
            data["realPerson_stopaj"] = LocalizationHelper.formatCurrencyForExport(realPersonResult.stopaj)
            data["realPerson_netFee"] = LocalizationHelper.formatCurrencyForExport(realPersonResult.netFee)
            data["realPerson_kdv"] = LocalizationHelper.formatCurrencyForExport(realPersonResult.kdv)
            data["realPerson_tahsilEdilecekTutar"] = LocalizationHelper.formatCurrencyForExport(realPersonResult.tahsilEdilecekTutar)
            
            // Legal person data
            data["legalPerson_brutFee"] = LocalizationHelper.formatCurrencyForExport(legalPersonResult.brutFee)
            data["legalPerson_stopaj"] = LocalizationHelper.formatCurrencyForExport(legalPersonResult.stopaj)
            data["legalPerson_netFee"] = LocalizationHelper.formatCurrencyForExport(legalPersonResult.netFee)
            data["legalPerson_kdv"] = LocalizationHelper.formatCurrencyForExport(legalPersonResult.kdv)
            data["legalPerson_tahsilEdilecekTutar"] = LocalizationHelper.formatCurrencyForExport(legalPersonResult.tahsilEdilecekTutar)
        } else if let errorMessage = errorMessage {
            data["errorMessage"] = errorMessage
        }
        
        return data
    }
}

// MARK: - SMM Calculation Result Factory
extension SMMCalculationResult {
    
    /// Creates a successful SMM calculation result
    /// - Parameters:
    ///   - input: Input parameters
    ///   - realPersonResult: Real person calculation result
    ///   - legalPersonResult: Legal person calculation result
    ///   - breakdown: Calculation breakdown
    /// - Returns: Successful SMM calculation result
    static func success(
        input: SMMCalculationInput,
        realPersonResult: SMMPersonResult,
        legalPersonResult: SMMPersonResult,
        breakdown: SMMCalculationBreakdown
    ) -> SMMCalculationResult {
        return SMMCalculationResult(
            input: input,
            realPersonResult: realPersonResult,
            legalPersonResult: legalPersonResult,
            breakdown: breakdown
        )
    }
    
    /// Creates a failed SMM calculation result
    /// - Parameters:
    ///   - input: Input parameters
    ///   - error: Error message
    /// - Returns: Failed SMM calculation result
    static func failure(input: SMMCalculationInput, error: String) -> SMMCalculationResult {
        return SMMCalculationResult(input: input, error: error)
    }
}
