//
//  LocalizationKeys.swift
//  Denklem
//
//  Created by ozkan on 18.07.2025.
//

import Foundation

// MARK: - Localization Keys
/// Type-safe localization keys for consistent string access throughout the app
struct LocalizationKeys {
    
    // MARK: - App Information
    struct AppInfo {
        static let name = "app.name"
        static let tagline = "app.tagline"
        static let description = "app.description"
    }
    
    // MARK: - General Terms
    struct General {
        static let calculate = "general.calculate"
        static let cancel = "general.cancel"
        static let ok = "general.ok"
        static let save = "general.save"
        static let share = "general.share"
        static let export = "general.export"
        static let close = "general.close"
        static let back = "general.back"
        static let next = "general.next"
        static let done = "general.done"
        static let error = "general.error"
        static let warning = "general.warning"
        static let info = "general.info"
        static let success = "general.success"
    }
    
    // MARK: - Dispute Types
    struct DisputeType {
        static let workerEmployer = "dispute_type.worker_employer"
        static let commercial = "dispute_type.commercial"
        static let consumer = "dispute_type.consumer"
        static let rent = "dispute_type.rent"
        static let neighbor = "dispute_type.neighbor"
        static let condominium = "dispute_type.condominium"
        static let family = "dispute_type.family"
        static let partnershipDissolution = "dispute_type.partnership_dissolution"
        static let other = "dispute_type.other"
        
        // Descriptions
        struct Description {
            static let workerEmployer = "dispute_type.worker_employer.description"
            static let commercial = "dispute_type.commercial.description"
            static let consumer = "dispute_type.consumer.description"
            static let rent = "dispute_type.rent.description"
            static let neighbor = "dispute_type.neighbor.description"
            static let condominium = "dispute_type.condominium.description"
            static let family = "dispute_type.family.description"
            static let partnershipDissolution = "dispute_type.partnership_dissolution.description"
            static let other = "dispute_type.other.description"
        }
    }
    
    // MARK: - Dispute Categories (Main Categories)
    struct DisputeCategory {
        // Screen
        static let title = "dispute_category.title"
        static let subtitle = "dispute_category.subtitle"
        
        // Main Categories
        static let monetary = "dispute_category.monetary"
        static let monetaryDescription = "dispute_category.monetary.description"
        static let nonMonetary = "dispute_category.non_monetary"
        static let nonMonetaryDescription = "dispute_category.non_monetary.description"
        
        // Other Calculations
        static let otherCalculations = "dispute_category.other_calculations"
        static let timeCalculation = "dispute_category.time_calculation"
        static let timeCalculationDescription = "dispute_category.time_calculation.description"
        static let smmCalculation = "dispute_category.smm_calculation"
        static let smmCalculationDescription = "dispute_category.smm_calculation.description"
        
        // Future Features (Phase 2+)
        static let rentSpecial = "dispute_category.rent_special"
        static let rentSpecialDescription = "dispute_category.rent_special.description"
        static let lawyerFee = "dispute_category.lawyer_fee"
        static let lawyerFeeDescription = "dispute_category.lawyer_fee.description"
    }
    
    // MARK: - Agreement Status
    struct AgreementStatus {
        static let agreed = "agreement_status.agreed"
        static let notAgreed = "agreement_status.not_agreed"
        static let selectPrompt = "agreement_status.select_prompt"
        static let tapToSelect = "agreement_status.tap_to_select"
        
        struct Description {
            static let agreed = "agreement_status.agreed.description"
            static let notAgreed = "agreement_status.not_agreed.description"
        }
    }
    
    // MARK: - Calculation Types
    struct CalculationType {
        static let monetary = "calculation_type.monetary"
        static let nonMonetary = "calculation_type.non_monetary"
        static let timeCalculation = "calculation_type.time_calculation"
        static let smmCalculation = "calculation_type.smm_calculation"
        
        struct Description {
            static let monetary = "calculation_type.monetary.description"
            static let nonMonetary = "calculation_type.non_monetary.description"
            static let timeCalculation = "calculation_type.time_calculation.description"
            static let smmCalculation = "calculation_type.smm_calculation.description"
        }
    }
    
    // MARK: - SMM Calculation Types
    struct SMMCalculationType {
        static let vatIncludedWithholdingExcluded = "smm_calculation_type.vat_included_withholding_excluded"
        static let vatExcludedWithholdingIncluded = "smm_calculation_type.vat_excluded_withholding_included"
        static let vatIncludedWithholdingIncluded = "smm_calculation_type.vat_included_withholding_included"
        static let vatExcludedWithholdingExcluded = "smm_calculation_type.vat_excluded_withholding_excluded"
        
        struct Description {
            static let vatIncludedWithholdingExcluded = "smm_calculation_type.vat_included_withholding_excluded.description"
            static let vatExcludedWithholdingIncluded = "smm_calculation_type.vat_excluded_withholding_included.description"
            static let vatIncludedWithholdingIncluded = "smm_calculation_type.vat_included_withholding_included.description"
            static let vatExcludedWithholdingExcluded = "smm_calculation_type.vat_excluded_withholding_excluded.description"
        }
    }
    
    // MARK: - SMM Result Table Labels
    struct SMMResult {
        static let mediationFee = "smm_result.mediation_fee"
        static let incomeTaxWithholding = "smm_result.income_tax_withholding"
        static let netFee = "smm_result.net_fee"
        static let vat = "smm_result.vat"
        static let collectedFee = "smm_result.collected_fee"
        static let legalPerson = "smm_result.legal_person"
        static let realPerson = "smm_result.real_person"
    }
    
    // MARK: - Validation Messages
    struct Validation {
        struct Amount {
            static let min = "validation.amount.min"
            static let max = "validation.amount.max"
        }
        
        struct PartyCount {
            static let min = "validation.party_count.min"
            static let max = "validation.party_count.max"
        }
        
        static let requiredField = "validation.required_field"
        static let invalidAmount = "validation.invalid_amount"
        static let invalidPartyCount = "validation.invalid_party_count"
        static let estimatedTariff = "validation.estimated_tariff"
        static let invalidDisputeType = "validation.invalid_dispute_type"
    }
    
    // MARK: - Error Messages
    struct ErrorMessage {
        static let calculationFailed = "error.calculation_failed"
        static let invalidInput = "error.invalid_input"
        static let networkError = "error.network_error"
        static let fileError = "error.file_error"
        static let unknownError = "error.unknown_error"
        static let tryAgain = "error.try_again"
        static let unsupportedYear = "error.unsupported_year"
        static let tariffCreationFailed = "error.tariff_creation_failed"
    }
    
    // MARK: - Screen Titles
    struct ScreenTitle {
        static let home = "screen.title.home"
        static let disputeCategory = "screen.title.dispute_category"
        static let disputeCategoryComingSoon = "screen.dispute_category.coming_soon"
        static let agreementStatus = "screen.title.agreement_status"
        static let disputeType = "screen.title.dispute_type"
        static let input = "screen.title.input"
        static let result = "screen.title.result"
        static let timeCalculation = "screen.title.time_calculation"
        static let smmCalculation = "screen.title.smm_calculation"
        static let about = "screen.title.about"
        static let legislation = "screen.title.legislation"
    }
    
    // MARK: - Input Fields
    struct Input {
        static let agreementAmount = "input.agreement_amount"
        static let partyCount = "input.party_count"
        static let mediationFee = "input.mediation_fee"
        static let startDate = "input.start_date"
        static let assignmentDate = "input.assignment_date"
        
        struct Placeholder {
            static let amount = "input.placeholder.amount"
            static let partyCount = "input.placeholder.party_count"
            static let mediationFee = "input.placeholder.mediation_fee"
        }
        
        struct Hint {
            static let amount = "input.hint.amount"
            static let partyCount = "input.hint.party_count"
            static let mediationFee = "input.hint.mediation_fee"
        }
    }
    
    // MARK: - Result Labels
    struct Result {
        static let mediationFee = "result.mediation_fee"
        static let disputeType = "result.dispute_type"
        static let amount = "result.amount"
        static let partyCount = "result.party_count"
        static let calculationDate = "result.calculation_date"
        static let tariffYear = "result.tariff_year"
    }
    
    // MARK: - Time Calculation
    struct TimeCalculation {
        static let disputeTypes = "time_calculation.dispute_types"
        static let laborLaw = "time_calculation.labor_law"
        static let commercialLaw = "time_calculation.commercial_law"
        static let consumerLaw = "time_calculation.consumer_law"
        static let rentalDisputes = "time_calculation.rental_disputes"
        static let partnershipDissolution = "time_calculation.partnership_dissolution"
        static let condominiumLaw = "time_calculation.condominium_law"
        static let neighborLaw = "time_calculation.neighbor_law"
        static let agriculturalProduction = "time_calculation.agricultural_production"
        
        struct Result {
            static let week = "time_calculation.week"
            static let weeks = "time_calculation.weeks"
            static let deadline = "time_calculation.deadline"
            static let extendedDeadline = "time_calculation.extended_deadline"
            static let processEndDates = "time_calculation.process_end_dates"
        }
        
        static let disputeTypeDuration = "time_calculation.dispute_type_duration"
    }
    
    // MARK: - Home Screen
    struct Home {
        static let welcome = "home.welcome"
        static let selectYear = "home.select_year"
        static let yearWarning = "home.year_warning"
        static let disputeCategories = "home.dispute_categories"
        static let monetaryDisputes = "home.monetary_disputes"
        static let nonMonetaryDisputes = "home.non_monetary_disputes"
        static let otherCalculations = "home.other_calculations"
        static let timeCalculation = "home.time_calculation"
        static let smmCalculation = "home.smm_calculation"
    }
    
    // MARK: - Start Screen
    struct Start {
        static let appTitle = "app.name"
        static let appSubtitle = "app.tagline"
        static let tariffYearLabel = "start.tariff_year_label"
        static let enterButton = "start.enter_button"
        static let enterButtonWithYear = "start.enter_button_with_year"
        static let yearDropdownHint = "start.year_dropdown_hint"
        static let year2025 = "start.year_2025"
        static let year2026 = "start.year_2026"
        static let selectYearHint = "start.select_year_hint"
        static let scrollToSelect = "start.scroll_to_select"
    }
    
    // MARK: - About Screen
    struct About {
        static let appInfo = "about.app_info"
        static let version = "about.version"
        static let developer = "about.developer"
        static let contact = "about.contact"
        static let company = "about.company"
        static let legalInfo = "about.legal_info"
        static let disclaimer = "about.disclaimer"
        static let copyright = "about.copyright"
        static let whoWeAre = "about.who_we_are"
        static let appDescriptionLong = "about.app_description_long"
        static let smmReceipt = "about.smm_receipt"
        
        // Feature Information
        static let features = "about.features"
        static let supportedYears = "about.supported_years"
        static let disputeTypes = "about.dispute_types"
        static let languages = "about.languages"
        static let calculationTypes = "about.calculation_types"
        static let tariffYears = "about.tariff_years"
        
        // Legal & Data
        static let legal = "about.legal"
        static let dataSource = "about.data_source"
        static let officialData = "about.official_data"
        static let finalizedData = "about.finalized_data"
        static let estimatedData = "about.estimated_data"
        
        // Technical Information
        static let bundleId = "about.bundle_id"
        static let minIOSVersion = "about.min_ios_version"
        static let buildConfig = "about.build_config"
    }
    
    // MARK: - Legislation Screen
    struct Legislation {
        static let title = "legislation.title"
        static let year = "legislation.year"
        static let source = "legislation.source"
        static let viewDocument = "legislation.view_document"
    }
    
    // MARK: - Error Messages
    struct Error {
        static let calculationFailed = "error.calculation_failed"
        static let invalidInput = "error.invalid_input"
        static let networkError = "error.network_error"
        static let fileError = "error.file_error"
        static let unknownError = "error.unknown_error"
        static let tryAgain = "error.try_again"
    }
    
    // MARK: - Success Messages
    struct Success {
        static let calculationCompleted = "success.calculation_completed"
        static let dataSaved = "success.data_saved"
        static let dataExported = "success.data_exported"
        static let shared = "success.shared"
    }
    
    // MARK: - Loading Messages
    struct Loading {
        static let calculating = "loading.calculating"
        static let loading = "loading.loading"
        static let pleaseWait = "loading.please_wait"
    }
    
    // MARK: - Tab Bar
    struct TabBar {
        static let home = "tab.home"
        static let legislation = "tab.legislation"
        static let about = "tab.about"
        static let language = "tab.language"
    }
    
    // MARK: - Language Settings
    struct Language {
        static let title = "language.title"
        static let current = "language.current"
        static let select = "language.select"
        static let turkish = "language.turkish"
        static let english = "language.english"
        static let changeSuccess = "language.change_success"
        static let restartRequired = "language.restart_required"
    }
    
    // MARK: - Contact & Support
    struct Contact {
        static let email = "contact.email"
        static let website = "contact.website"
        static let shareApp = "contact.share_app"
        static let rateApp = "contact.rate_app"
        static let sendFeedback = "contact.send_feedback"
    }
    
    // MARK: - Legal
    struct Legal {
        static let disclaimer = "legal.disclaimer"
        static let source = "legal.source"
        static let privacyPolicy = "legal.privacy_policy"
        static let termsOfUse = "legal.terms_of_use"
        static let dataProtection = "legal.data_protection"
        static let officialSource = "legal.official_source"
    }
    
    // MARK: - Currency
    struct Currency {
        static let symbol = "currency.symbol"
        static let code = "currency.code"
        static let format = "currency.format"
    }
    
    // MARK: - Calculation Header
    struct Calculation {
        static let typeHeader = "calculation.type_header"
    }
}

// MARK: - LocalizationKeys Extension
extension LocalizationKeys {
    
    /// Helper function to get localized string with type safety
    static func localized(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    /// Helper function to get localized string with format arguments
    static func localized(_ key: String, _ arguments: CVarArg..., comment: String = "") -> String {
        let format = NSLocalizedString(key, comment: comment)
        return String(format: format, arguments: arguments)
    }
}

// MARK: - String Extension for Type-Safe Localization
extension String {
    
    /// Returns localized string using the string as key
    /// Uses Bundle.localizedBundle for runtime language switching
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
    }
    
    /// Returns localized string with format arguments
    func localized(_ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: "")
        return String(format: format, arguments: arguments)
    }
    
    /// Returns localized string with custom comment
    func localized(comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle, value: "", comment: comment)
    }
}
