//
//  DisputeCategory.swift
//  Denklem
//
//  Created by ozkan on 01.01.2026.
//

import Foundation

// MARK: - Dispute Category
/// High-level categorization of dispute types for grouping and filtering
/// Provides semantic grouping of related dispute types
enum DisputeCategory: String, CaseIterable, Identifiable, Hashable {
    case workerEmployer = "worker_employer"
    case commercial = "commercial"
    case consumer = "consumer"
    case rent = "rent"
    case neighbor = "neighbor"
    case condominium = "condominium"
    case family = "family"
    case partnershipDissolution = "partnership_dissolution"
    case other = "other"
    
    // MARK: - Identifiable Conformance
    
    var id: String { rawValue }
    
    // MARK: - Display Properties
    
    /// Localized display name for the category
    var displayName: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.workerEmployer, comment: "Worker-Employer category")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.commercial, comment: "Commercial category")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.consumer, comment: "Consumer category")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.rent, comment: "Rent category")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.neighbor, comment: "Neighbor category")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.condominium, comment: "Condominium category")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.family, comment: "Family category")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.partnershipDissolution, comment: "Partnership dissolution category")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.other, comment: "Other category")
        }
    }
    
    /// Localized description for the category
    var description: String {
        switch self {
        case .workerEmployer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.workerEmployer, comment: "Worker-Employer description")
        case .commercial:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.commercial, comment: "Commercial description")
        case .consumer:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.consumer, comment: "Consumer description")
        case .rent:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.rent, comment: "Rent description")
        case .neighbor:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.neighbor, comment: "Neighbor description")
        case .condominium:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.condominium, comment: "Condominium description")
        case .family:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.family, comment: "Family description")
        case .partnershipDissolution:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.partnershipDissolution, comment: "Partnership dissolution description")
        case .other:
            return NSLocalizedString(LocalizationKeys.DisputeType.Description.other, comment: "Other description")
        }
    }
    
    // MARK: - Domain Logic Properties
    
    /// Display priority for UI ordering (lower number = higher priority)
    var displayPriority: Int {
        switch self {
        case .workerEmployer: return 1
        case .commercial: return 2
        case .consumer: return 3
        case .rent: return 4
        case .family: return 5
        case .condominium: return 6
        case .neighbor: return 7
        case .partnershipDissolution: return 8
        case .other: return 9
        }
    }
    
    /// Whether this category typically involves monetary disputes
    var isTypicallyMonetary: Bool {
        switch self {
        case .commercial, .rent, .partnershipDissolution:
            return true
        case .workerEmployer, .consumer, .neighbor, .condominium, .family, .other:
            return false // Can be both
        }
    }
    
    // MARK: - Factory Methods
    
    /// Creates DisputeCategory from raw string value
    /// - Parameter rawValue: String representation of category
    /// - Returns: DisputeCategory enum case or nil if invalid
    static func from(_ rawValue: String) -> DisputeCategory? {
        return DisputeCategory(rawValue: rawValue)
    }
    
    /// Creates DisputeCategory from DisputeType
    /// - Parameter disputeType: DisputeType to convert
    /// - Returns: Corresponding DisputeCategory
    static func from(_ disputeType: DisputeType) -> DisputeCategory {
        return disputeType.category
    }
    
    /// Returns all categories ordered by display priority
    /// - Returns: Array of DisputeCategory cases sorted by priority
    static var orderedForDisplay: [DisputeCategory] {
        return DisputeCategory.allCases.sorted { $0.displayPriority < $1.displayPriority }
    }
}

// MARK: - DisputeCategory Extensions

extension DisputeCategory {
    
    /// Maps to DisputeConstants key format
    var disputeConstantsKey: String {
        return rawValue
    }
    
    /// Maps to LocalizationKeys format
    var localizationKey: String {
        return rawValue
    }
}

// MARK: - Collection Extensions

extension Collection where Element == DisputeCategory {
    
    /// Returns categories sorted by display priority
    var sortedByPriority: [DisputeCategory] {
        return sorted { $0.displayPriority < $1.displayPriority }
    }
    
    /// Returns monetary categories only
    var monetaryOnly: [DisputeCategory] {
        return filter { $0.isTypicallyMonetary }
    }
    
    /// Returns non-monetary categories only
    var nonMonetaryOnly: [DisputeCategory] {
        return filter { !$0.isTypicallyMonetary }
    }
}

// MARK: - Debug Support

#if DEBUG
extension DisputeCategory {
    
    /// Debug description with all properties
    var debugDescription: String {
        return """
        DisputeCategory: \(rawValue)
        Display Name: \(displayName)
        Priority: \(displayPriority)
        Typically Monetary: \(isTypicallyMonetary)
        """
    }
}
#endif
