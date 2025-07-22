//
//  CalculationResult.swift
//  Denklem
//
//  Created by ozkan on 22.07.2025.
//

import Foundation

// MARK: - Calculation Result
/// Domain model representing the result of a mediation fee calculation
/// Encapsulates the calculated fee, input parameters, and calculation metadata
struct CalculationResult {
    
    // MARK: - Core Properties
    
    /// The calculated mediation fee
    let mediationFee: MediationFee
    
    /// Input parameters used for calculation
    let input: CalculationInput
    
    /// Timestamp when calculation was performed
    let calculationDate: Date
    
    /// Whether calculation was successful
    let isSuccess: Bool
    
    /// Error message if calculation failed
    let errorMessage: String?
    
    // MARK: - Computed Properties
    
    /// Quick access to calculated amount
    var amount: Double {
        return mediationFee.amount
    }
    
    /// Quick access to formatted amount
    var formattedAmount: String {
        return mediationFee.formattedAmount
    }
    
    /// Quick access to dispute type
    var disputeType: DisputeType {
        return mediationFee.disputeType
    }
    
    /// Quick access to agreement status
    var agreementStatus: AgreementStatus {
        return mediationFee.agreementStatus
    }
    
    /// Quick access to calculation type
    var calculationType: CalculationType {
        return mediationFee.calculationType
    }
    
    /// Summary description of the result
    var summary: String {
        if !isSuccess {
            return NSLocalizedString(LocalizationKeys.ErrorMessage.calculationFailed, comment: "")
        }
        return "\(disputeType.displayName) - \(formattedAmount)"
    }
    
    // MARK: - Initializers
    
    /// Main initializer for successful calculation
    /// - Parameters:
    ///   - mediationFee: The calculated mediation fee
    ///   - input: Input parameters used for calculation
    init(mediationFee: MediationFee, input: CalculationInput) {
        self.mediationFee = mediationFee
        self.input = input
        self.calculationDate = Date()
        self.isSuccess = true
        self.errorMessage = nil
    }
    
    /// Initializer for failed calculation
    /// - Parameters:
    ///   - input: Input parameters used for calculation
    ///   - errorMessage: Error message describing the failure
    init(input: CalculationInput, errorMessage: String) {
        // Create a placeholder mediation fee for failed calculations
        let breakdown = CalculationBreakdown(
            steps: [NSLocalizedString(LocalizationKeys.ErrorMessage.calculationFailed, comment: "")],
            finalAmount: 0.0
        )
        
        self.mediationFee = MediationFee(
            amount: 0.0,
            disputeType: input.disputeType,
            tariffYear: input.tariffYear,
            calculationType: input.calculationType,
            agreementStatus: input.agreementStatus,
            partyCount: input.partyCount,
            disputeAmount: input.disputeAmount,
            calculationBreakdown: breakdown,
            baseFee: 0.0
        )
        
        self.input = input
        self.calculationDate = Date()
        self.isSuccess = false
        self.errorMessage = errorMessage
    }
}

// MARK: - Calculation Input
/// Input parameters for mediation fee calculation
struct CalculationInput {
    
    // MARK: - Required Properties
    
    /// Type of dispute
    let disputeType: DisputeType
    
    /// Type of calculation to perform
    let calculationType: CalculationType
    
    /// Agreement status in the dispute
    let agreementStatus: AgreementStatus
    
    /// Number of parties in the dispute
    let partyCount: Int
    
    /// Tariff year to use for calculation
    let tariffYear: TariffYear
    
    // MARK: - Optional Properties
    
    /// Dispute amount (required for monetary calculations)
    let disputeAmount: Double?
    
    /// Additional calculation parameters
    let additionalParameters: [String: Any]?
    
    // MARK: - Initializers
    
    /// Main initializer for calculation input
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - calculationType: Type of calculation
    ///   - agreementStatus: Agreement status
    ///   - partyCount: Number of parties
    ///   - tariffYear: Tariff year
    ///   - disputeAmount: Dispute amount (optional)
    ///   - additionalParameters: Additional parameters (optional)
    init(disputeType: DisputeType,
         calculationType: CalculationType,
         agreementStatus: AgreementStatus,
         partyCount: Int,
         tariffYear: TariffYear,
         disputeAmount: Double? = nil,
         additionalParameters: [String: Any]? = nil) {
        
        self.disputeType = disputeType
        self.calculationType = calculationType
        self.agreementStatus = agreementStatus
        self.partyCount = partyCount
        self.tariffYear = tariffYear
        self.disputeAmount = disputeAmount
        self.additionalParameters = additionalParameters
    }
    
    /// Convenience initializer with default values
    /// - Parameters:
    ///   - disputeType: Type of dispute
    ///   - agreementStatus: Agreement status
    ///   - partyCount: Number of parties
    ///   - disputeAmount: Dispute amount (optional)
    init(disputeType: DisputeType,
         agreementStatus: AgreementStatus,
         partyCount: Int,
         disputeAmount: Double? = nil) {
        
        self.init(
            disputeType: disputeType,
            calculationType: disputeAmount != nil ? .monetary : .nonMonetary,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            tariffYear: .current,
            disputeAmount: disputeAmount
        )
    }
}

// MARK: - CalculationResult Extensions

extension CalculationResult {
    
    // MARK: - Validation
    
    /// Validates the calculation result
    /// - Returns: ValidationResult indicating success or failure
    func validate() -> ValidationResult {
        if !isSuccess {
            return .failure(
                code: AppConstants.ErrorCodes.calculationError,
                message: errorMessage ?? NSLocalizedString(LocalizationKeys.ErrorMessage.calculationFailed, comment: "")
            )
        }
        
        return mediationFee.validate()
    }
    
    // MARK: - Export
    
    /// Returns calculation result data for export
    /// - Returns: Dictionary with exportable data
    func toExportData() -> [String: Any] {
        var data: [String: Any] = [
            "calculationDate": LocalizationHelper.formatDateForExport(calculationDate),
            "isSuccess": isSuccess,
            "summary": summary
        ]
        
        if isSuccess {
            data.merge(mediationFee.toExportData()) { _, new in new }
            data.merge(input.toExportData()) { _, new in new }
        } else if let errorMessage = errorMessage {
            data["errorMessage"] = errorMessage
        }
        
        return data
    }
    
    /// Returns JSON representation
    /// - Returns: JSON data
    func toJSON() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return try? encoder.encode(self)
    }
}

// MARK: - CalculationInput Extensions

extension CalculationInput {
    
    // MARK: - Validation
    
    /// Validates the calculation input
    /// - Returns: ValidationResult indicating success or failure
    func validate() -> ValidationResult {
        // Validate dispute type
        let disputeTypeValidation = ValidationConstants.validateDisputeType(disputeType.rawValue)
        if !disputeTypeValidation.isValid {
            return disputeTypeValidation
        }
        
        // Validate agreement status
        let agreementValidation = ValidationConstants.validateAgreementStatus(agreementStatus.rawValue)
        if !agreementValidation.isValid {
            return agreementValidation
        }
        
        // Validate party count
        let partyValidation = ValidationConstants.validatePartyCount(partyCount)
        if !partyValidation.isValid {
            return partyValidation
        }
        
        // Validate year
        let yearValidation = ValidationConstants.validateYear(tariffYear.rawValue)
        if !yearValidation.isValid {
            return yearValidation
        }
        
        // Validate dispute amount if provided
        if let disputeAmount = disputeAmount {
            let amountValidation = ValidationConstants.validateAmount(disputeAmount)
            if !amountValidation.isValid {
                return amountValidation
            }
        }
        
        // Validate calculation type requirements
        if calculationType.requiresDisputeAmount && disputeAmount == nil {
            return .failure(
                code: ValidationConstants.DisputeType.validationErrorCode,
                message: NSLocalizedString(LocalizationKeys.Validation.requiredField, comment: "")
            )
        }
        
        return .success
    }
    
    // MARK: - Export
    
    /// Returns input data for export
    /// - Returns: Dictionary with exportable data
    func toExportData() -> [String: Any] {
        var data: [String: Any] = [
            "inputDisputeType": disputeType.displayName,
            "inputCalculationType": calculationType.displayName,
            "inputAgreementStatus": agreementStatus.displayName,
            "inputPartyCount": partyCount,
            "inputTariffYear": tariffYear.rawValue
        ]
        
        if let disputeAmount = disputeAmount {
            data["inputDisputeAmount"] = LocalizationHelper.formatCurrencyForExport(disputeAmount)
        }
        
        return data
    }
}

// MARK: - Codable Conformance

extension CalculationResult: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case mediationFee
        case input
        case calculationDate
        case isSuccess
        case errorMessage
    }
}

extension CalculationInput: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case disputeType
        case calculationType
        case agreementStatus
        case partyCount
        case tariffYear
        case disputeAmount
        case additionalParameters
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode DisputeType from string
        let disputeTypeString = try container.decode(String.self, forKey: .disputeType)
        disputeType = DisputeType(rawValue: disputeTypeString) ?? .other
        
        // Decode CalculationType from string
        let calculationTypeString = try container.decode(String.self, forKey: .calculationType)
        calculationType = CalculationType(rawValue: calculationTypeString) ?? .monetary
        
        // Decode AgreementStatus from string
        let agreementStatusString = try container.decode(String.self, forKey: .agreementStatus)
        agreementStatus = AgreementStatus(rawValue: agreementStatusString) ?? .notAgreed
        
        partyCount = try container.decode(Int.self, forKey: .partyCount)
        
        // Decode TariffYear from int
        let tariffYearInt = try container.decode(Int.self, forKey: .tariffYear)
        tariffYear = TariffYear(rawValue: tariffYearInt) ?? .year2025
        
        disputeAmount = try container.decodeIfPresent(Double.self, forKey: .disputeAmount)
        
        // Handle additionalParameters as optional
        additionalParameters = try container.decodeIfPresent([String: String].self, forKey: .additionalParameters)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(disputeType.rawValue, forKey: .disputeType)
        try container.encode(calculationType.rawValue, forKey: .calculationType)
        try container.encode(agreementStatus.rawValue, forKey: .agreementStatus)
        try container.encode(partyCount, forKey: .partyCount)
        try container.encode(tariffYear.rawValue, forKey: .tariffYear)
        try container.encodeIfPresent(disputeAmount, forKey: .disputeAmount)
        
        // Encode additionalParameters if present (simplified as string dictionary)
        if let params = additionalParameters {
            let stringParams = params.compactMapValues { $0 as? String }
            try container.encodeIfPresent(stringParams, forKey: .additionalParameters)
        }
    }
}

// MARK: - Factory Methods

extension CalculationResult {
    
    /// Creates a successful calculation result
    /// - Parameters:
    ///   - mediationFee: The calculated mediation fee
    ///   - input: Input parameters used
    /// - Returns: CalculationResult with success status
    static func success(mediationFee: MediationFee, input: CalculationInput) -> CalculationResult {
        return CalculationResult(mediationFee: mediationFee, input: input)
    }
    
    /// Creates a failed calculation result
    /// - Parameters:
    ///   - input: Input parameters used
    ///   - error: Error that occurred during calculation
    /// - Returns: CalculationResult with failure status
    static func failure(input: CalculationInput, error: String) -> CalculationResult {
        return CalculationResult(input: input, errorMessage: error)
    }
}

extension CalculationInput {
    
    /// Creates calculation input with validation
    /// - Parameters: Standard input parameters
    /// - Returns: Result containing validated input or error
    static func create(
        disputeType: DisputeType,
        calculationType: CalculationType,
        agreementStatus: AgreementStatus,
        partyCount: Int,
        tariffYear: TariffYear,
        disputeAmount: Double? = nil
    ) -> Result<CalculationInput, ValidationResult> {
        
        let input = CalculationInput(
            disputeType: disputeType,
            calculationType: calculationType,
            agreementStatus: agreementStatus,
            partyCount: partyCount,
            tariffYear: tariffYear,
            disputeAmount: disputeAmount
        )
        
        let validation = input.validate()
        if validation.isValid {
            return .success(input)
        } else {
            return .failure(validation)
        }
    }
}
