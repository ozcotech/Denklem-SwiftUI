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
        static let comingSoon = "general.coming_soon"
        static let comingSoonMessage = "general.coming_soon_message"
        static let disputeSubject = "general.dispute_subject"
        static let recalculate = "general.recalculate"
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
        static let agriculturalProduction = "dispute_type.agricultural_production"
        static let other = "dispute_type.other"
        static let nonMonetaryNote = "dispute_type.non_monetary_note"
        static let selectPrompt = "dispute_type.select_prompt"

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
            static let agriculturalProduction = "dispute_type.agricultural_production.description"
            static let other = "dispute_type.other.description"
        }
    }
    
    // MARK: - Dispute Categories (Main Categories)
    struct DisputeCategory {
        static let mainCategories = "dispute_category.main_categories"
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
        
        // Special Calculations Section
        static let specialCalculations = "dispute_category.special_calculations"
        static let rentSpecial = "dispute_category.rent_special"
        static let rentSpecialDescription = "dispute_category.rent_special.description"
        static let attorneyFee = "dispute_category.attorney_fee"
        static let attorneyFeeDescription = "dispute_category.attorney_fee.description"
        static let reinstatement = "dispute_category.reinstatement"
        static let reinstatementDescription = "dispute_category.reinstatement.description"
        static let serialDisputes = "dispute_category.serial_disputes"
        static let serialDisputesDescription = "dispute_category.serial_disputes.description"
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
        static let title = "smm_result.title"
        static let calculatedFee = "smm_result.calculated_fee"
        static let grossFee = "smm_result.gross_fee"
        static let withholding = "smm_result.withholding"
        static let netFee = "smm_result.net_fee"
        static let vat = "smm_result.vat"
        static let totalCollected = "smm_result.total_collected"
        static let legalPerson = "smm_result.legal_person"
        static let realPerson = "smm_result.real_person"
    }

    // MARK: - SMM Calculation Screen
    struct SMMCalculation {
        static let note = "smm_calculation.note"
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

        struct FileCount {
            static let min = "validation.file_count.min"
            static let max = "validation.file_count.max"
        }

        static let requiredField = "validation.required_field"
        static let invalidAmount = "validation.invalid_amount"
        static let invalidPartyCount = "validation.invalid_party_count"
        static let invalidFileCount = "validation.invalid_file_count"
        static let invalidAgreementAmount = "validation.invalid_agreement_amount"
        static let missingCourtType = "validation.missing_court_type"
        static let estimatedTariff = "validation.estimated_tariff"
        static let invalidDisputeType = "validation.invalid_dispute_type"
        static let invalidYear = "validation.invalid_year"
    }
    
    // MARK: - Error Messages
    struct ErrorMessage {
        static let calculationFailed = "error.calculation_failed"
        static let invalidInput = "error.invalid_input"
        static let networkError = "error.network_error"
        static let fileError = "error.file_error"
        static let unknownError = "error.unknown_error"
        /// Type-safe alias for unknown error (for compatibility)
        static let unknown = "error.unknown_error"
        static let tryAgain = "error.try_again"
        static let unsupportedYear = "error.unsupported_year"
        static let tariffCreationFailed = "error.tariff_creation_failed"
    }

    // MARK: - Attorney Fee
    struct AttorneyFee {
        // Screen Titles
        static let typeScreenTitle = "attorney_fee.type_screen_title"
        static let agreementScreenTitle = "attorney_fee.agreement_screen_title"
        static let inputScreenTitle = "attorney_fee.input_screen_title"
        static let resultTitle = "attorney_fee.result_title"

        // Type Selection
        static let monetaryType = "attorney_fee.monetary_type"
        static let nonMonetaryType = "attorney_fee.non_monetary_type"

        // Agreement Status
        static let agreed = "attorney_fee.agreed"
        static let notAgreed = "attorney_fee.not_agreed"

        // Input Labels
        static let agreementAmount = "attorney_fee.agreement_amount"
        static let claimAmount = "attorney_fee.claim_amount"
        static let selectCourt = "attorney_fee.select_court"

        // Court Types
        static let civilPeaceCourt = "attorney_fee.civil_peace_court"
        static let firstInstanceCourt = "attorney_fee.first_instance_court"
        static let consumerCourt = "attorney_fee.consumer_court"
        static let intellectualPropertyCourt = "attorney_fee.intellectual_property_court"

        // Result Labels
        static let calculatedFee = "attorney_fee.calculated_fee"
        static let flatFee = "attorney_fee.flat_fee"
        static let courtType = "attorney_fee.court_type"

        // Breakdown Labels
        static let thirdPartFee = "attorney_fee.third_part_fee"
        static let bonusAmount = "attorney_fee.bonus_amount"

        // Warnings
        static let feeExceedsAmountWarning = "attorney_fee.fee_exceeds_amount_warning"
        static let minimumFeeApplied = "attorney_fee.minimum_fee_applied"

        // Legal Reference
        static let legalReference = "attorney_fee.legal_reference"
        static let legalReferenceFormat = "attorney_fee.legal_reference_format"
    }

    // MARK: - Serial Disputes
    struct SerialDisputes {
        // Screen Titles
        static let screenTitle = "serial_disputes.screen_title"
        static let resultTitle = "serial_disputes.result_title"

        // Dispute Types
        static let selectDisputeType = "serial_disputes.select_dispute_type"
        static let commercialDispute = "serial_disputes.commercial_dispute"
        static let nonCommercialDispute = "serial_disputes.non_commercial_dispute"

        // Input Labels
        static let fileCount = "serial_disputes.file_count"
        static let fileCountPlaceholder = "serial_disputes.file_count_placeholder"
        static let fileCountHint = "serial_disputes.file_count_hint"

        // Result Labels
        static let totalFee = "serial_disputes.total_fee"
        static let feePerFile = "serial_disputes.fee_per_file"
        static let calculationBreakdown = "serial_disputes.calculation_breakdown"
        static let disputeTypeLabel = "serial_disputes.dispute_type_label"
        static let fileCountLabel = "serial_disputes.file_count_label"
        static let tariffYearLabel = "serial_disputes.tariff_year_label"

        // Legal Reference
        static let legalReference = "serial_disputes.legal_reference"
        static let legalArticle = "serial_disputes.legal_article"
        static let tariffName = "serial_disputes.tariff_name"
    }

    // MARK: - Reinstatement (İşe İade)
    struct Reinstatement {
        // Screen Titles
        static let screenTitle = "reinstatement.screen_title"
        static let resultTitle = "reinstatement.result_title"
        
        // Agreement Status
        static let selectAgreementStatus = "reinstatement.select_agreement_status"
        static let agreed = "reinstatement.agreed"
        static let notAgreed = "reinstatement.not_agreed"
        
        // Input Labels - Agreement Case
        static let nonReinstatementCompensation = "reinstatement.non_reinstatement_compensation"
        static let nonReinstatementCompensationHint = "reinstatement.non_reinstatement_compensation_hint"
        static let idlePeriodWage = "reinstatement.idle_period_wage"
        static let idlePeriodWageHint = "reinstatement.idle_period_wage_hint"
        static let otherRights = "reinstatement.other_rights"
        static let otherRightsTotal = "reinstatement.other_rights_total"
        static let otherRightsHint = "reinstatement.other_rights_hint"
        static let partyCount = "reinstatement.party_count"
        static let partyCountHint = "reinstatement.party_count_hint"
        
        // Result Labels
        static let totalFee = "reinstatement.total_fee"
        static let totalAmount = "reinstatement.total_amount"
        static let calculationBreakdown = "reinstatement.calculation_breakdown"
        static let minimumFeeApplied = "reinstatement.minimum_fee_applied"
        static let bracketCalculation = "reinstatement.bracket_calculation"
        
        // Legal References (localized)
        static let legalAgreementArticle = "reinstatement.legal_agreement_article"
        static let legalNoAgreementArticle = "reinstatement.legal_no_agreement_article"
        static let legalLaborLawArticle = "reinstatement.legal_labor_law_article"
        static let tariffSection = "reinstatement.tariff_section"

        // Warning Messages
        static let noAgreementWarning = "reinstatement.no_agreement_warning"

        // Info/Description
        static let description = "reinstatement.description"
        static let agreementDescription = "reinstatement.agreement_description"
        static let noAgreementDescription = "reinstatement.no_agreement_description"
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
            static let claimAmount = "input.placeholder.claim_amount"
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
        static let disputeSubject = "result.dispute_subject"
        static let disputeSubjectNonMonetary = "result.dispute_subject_non_monetary"
        static let agreementStatus = "result.agreement_status"
        static let amount = "result.amount"
        static let partyCount = "result.party_count"
        static let calculationDate = "result.calculation_date"
        static let tariffYear = "result.tariff_year"
        static let calculationSteps = "result.calculation_steps"
        static let calculationInfo = "result.calculation_info"
        static let calculationResult = "result.calculation_result"
        static let calculationMethod = "result.calculation_method"
        static let bracketTotal = "result.bracket_total"
        static let minimumFee = "result.minimum_fee"
        static let minimumFeeApplied = "result.minimum_fee_applied"
        static let bracketTotalApplied = "result.bracket_total_applied"
        static let firstTier = "result.first_tier"
        static let nextTier = "result.next_tier"
        static let aboveTier = "result.above_tier"
        static let resultLabel = "result.result_label"
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
        static let invalidAgreementAmount = "validation.invalid_agreement_amount"
        static let missingCourtType = "validation.missing_court_type"
        /* Lines 161-173 omitted */
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
        static let supportedLanguages = "about.supported_languages"
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
        static let subtitle = "legislation.subtitle"
        static let year = "legislation.year"
        static let source = "legislation.source"
        
        // Tariff specific
        static let tariffName = "legislation.tariff_name"
        static let ministrySource = "legislation.ministry_source"
        static let viewDocument = "legislation.view_document"
        static let searchPrompt = "legislation.search.prompt"
        static let filterAll = "legislation.filter.all"
        static let tagOfficial = "legislation.tag.official"
        static let openInSafari = "legislation.action.open_in_safari"
        static let openDocument = "legislation.action.open_document"
        static let infoYear = "legislation.info.year"
        static let infoType = "legislation.info.type"
        static let infoStatus = "legislation.info.status"
        static let statusOfficial = "legislation.status.official"
        static let statusDraft = "legislation.status.draft"
        static let typeTariff = "legislation.type.tariff"
        static let typeRegulation = "legislation.type.regulation"
        static let typeLaw = "legislation.type.law"
        static let typeCircular = "legislation.type.circular"
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
        static let tools = "tab.tools"
        static let legislation = "tab.legislation"
        static let settings = "tab.settings"
    }

    // MARK: - Tools Screen
    struct Tools {
        static let title = "tools.title"
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
        static let disclaimerText = "legal.disclaimer_text"
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

    // MARK: - Court Types
    struct CourtType {
        static let civilPeace = "court_type.civil_peace"
        static let firstInstance = "court_type.first_instance"
        static let consumer = "court_type.consumer"
        static let intellectualProperty = "court_type.intellectual_property"
    }

    // MARK: - Rent Special (Tenancy - Eviction/Determination)
    struct RentSpecial {
        // Screen Titles
        static let selectionScreenTitle = "rent_special.selection_screen_title"
        static let attorneyFeeScreenTitle = "rent_special.attorney_fee_screen_title"
        static let mediationFeeScreenTitle = "rent_special.mediation_fee_screen_title"

        // Fee Mode Options
        static let attorneyFeeOption = "rent_special.attorney_fee_option"
        static let attorneyFeeOptionDescription = "rent_special.attorney_fee_option_description"
        static let mediationFeeOption = "rent_special.mediation_fee_option"
        static let mediationFeeOptionDescription = "rent_special.mediation_fee_option_description"

        // Segmented Picker Labels
        static let pickerAttorneyFee = "rent_special.picker_attorney_fee"
        static let pickerMediationFee = "rent_special.picker_mediation_fee"

        // Tenancy Types (Checkbox Labels)
        static let eviction = "rent_special.eviction"
        static let determination = "rent_special.determination"
        static let evictionDescription = "rent_special.eviction_description"
        static let determinationDescription = "rent_special.determination_description"
        static let selectAtLeastOne = "rent_special.select_at_least_one"

        // Input Labels
        static let evictionAmountLabel = "rent_special.eviction_amount_label"
        static let determinationAmountLabel = "rent_special.determination_amount_label"

        // Result Labels - Attorney Fee
        static let calculatedAttorneyFee = "rent_special.calculated_attorney_fee"
        static let inputAmount = "rent_special.input_amount"

        // Result Labels - Mediation Fee
        static let evictionMediationFee = "rent_special.eviction_mediation_fee"
        static let determinationMediationFee = "rent_special.determination_mediation_fee"
        static let totalMediationFee = "rent_special.total_mediation_fee"
        static let evictionCalculationBase = "rent_special.eviction_calculation_base"
        static let evictionOriginalAmount = "rent_special.eviction_original_amount"

        // Court Minimum Warnings
        static let courtMinimumWarningFormat = "rent_special.court_minimum_warning_format"
        static let courtMinimumWarningsTitle = "rent_special.court_minimum_warnings_title"
        static let courtCivilPeace = "rent_special.court_civil_peace"
        static let courtFirstInstance = "rent_special.court_first_instance"
        static let courtEnforcement = "rent_special.court_enforcement"

        // Minimum Fee Info
        static let attorneyMinimumApplied = "rent_special.attorney_minimum_applied"
        static let mediationMinimumApplied = "rent_special.mediation_minimum_applied"

        // Legal References
        static let attorneyFeeLegalReference = "rent_special.attorney_fee_legal_reference"
        static let mediationFeeLegalReference = "rent_special.mediation_fee_legal_reference"
    }

    // MARK: - Settings
    struct Settings {
        static let title = "settings.title"
        static let language = "settings.language"
        static let appearance = "settings.appearance"
        static let light = "settings.light"
        static let dark = "settings.dark"
        static let system = "settings.system"
    }

    // MARK: - Survey
    struct Survey {
        static let screenTitle = "survey.screen_title"
        static let question1Title = "survey.question1.title"
        static let question1OptionA = "survey.question1.option_a"
        static let question1OptionB = "survey.question1.option_b"
        static let question1Explanation = "survey.question1.explanation"
        static let question2Title = "survey.question2.title"
        static let question2OptionA = "survey.question2.option_a"
        static let question2OptionB = "survey.question2.option_b"
        static let question2Explanation = "survey.question2.explanation"
        static let correctAnswer = "survey.correct_answer"
        static let wrongAnswer = "survey.wrong_answer"
        static let nextQuestion = "survey.next_question"
        static let thankYouTitle = "survey.thank_you_title"
        static let thankYouMessage = "survey.thank_you_message"
        static let closeButton = "survey.close_button"
        static let questionCounter = "survey.question_counter"
        static let emailLabel = "survey.email_label"
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
