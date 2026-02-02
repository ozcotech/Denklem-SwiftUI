# Serial Disputes (Seri Uyuşmazlık) Implementation Skill

## Overview

This skill guides the implementation of the Serial Disputes calculation feature for the Denklem mediation fee calculator app.

## Feature Summary

Serial Disputes is a calculation for mediation cases where one party (e.g., an employer) has disputes with multiple other parties (e.g., 30 employees). The mediator opens multiple files but calculates fees per file based on a fixed rate.

## Legal Basis

**Article 7/4 of Mediation Fee Tariff:**
- Commercial disputes: 7,500 TL per file (2026) / 5,000 TL (2025)
- Non-commercial disputes: 6,000 TL per file (2026) / 4,000 TL (2025)

## Calculation Formula

```
Total Fee = File Count × Fee Per File
```

## Implementation Steps

### Step 1: Create Constants File

**File:** `Denklem/Denklem/Constants/SerialDisputesConstants.swift`

```swift
import SwiftUI

// MARK: - Serial Disputes Constants
struct SerialDisputesConstants {

    // MARK: - Dispute Type Enum
    enum DisputeType: String, CaseIterable, Identifiable, Codable {
        case commercial = "commercial"
        case nonCommercial = "non_commercial"

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .commercial:
                return LocalizationKeys.SerialDisputes.commercialDispute.localized
            case .nonCommercial:
                return LocalizationKeys.SerialDisputes.nonCommercialDispute.localized
            }
        }
    }

    // MARK: - Validation
    struct Validation {
        static let minimumFileCount: Int = 1
        static let maximumFileCount: Int = 1000
    }
}
```

### Step 2: Create Tariff Data File

**File:** `Denklem/Denklem/Models/Data/SerialDisputesTariff.swift`

Key values:
- 2026 Commercial: 7,500 TL
- 2026 Non-Commercial: 6,000 TL
- 2025 Commercial: 5,000 TL
- 2025 Non-Commercial: 4,000 TL

### Step 3: Create Domain Models

**File:** `Denklem/Denklem/Models/Domain/SerialDisputesResult.swift`

Contains:
- `SerialDisputesInput`: disputeType, fileCount, tariffYear
- `SerialDisputesResult`: totalFee, feePerFile, disputeType, fileCount, tariffYear

### Step 4: Create Calculator

**File:** `Denklem/Denklem/Models/Calculation/SerialDisputesCalculator.swift`

Simple multiplication: `fileCount × feePerFile`

### Step 5: Update Localization

**File:** `Denklem/Denklem/Localization/LocalizationKeys.swift`

Add `SerialDisputes` struct with keys for:
- screenTitle, resultTitle
- commercialDispute, nonCommercialDispute
- fileCount, totalFee, feePerFile
- validation messages
- legalReference

**File:** `Denklem/Localizable.xcstrings`

Add Turkish and English translations for all keys.

### Step 6: Create View Files

**Folder:** `Denklem/Denklem/Views/Screens/SerialDisputes/`

Files to create:
1. `SerialDisputesSheet.swift` - Main sheet with picker and input
2. `SerialDisputesViewModel.swift` - State management
3. `SerialDisputesResultView.swift` - Result display

### Step 7: Update Navigation

**File:** `Denklem/Denklem/Views/Screens/DisputeCategory/DisputeCategoryViewModel.swift`

- Add `@Published var showSerialDisputesSheet: Bool = false`
- Update `selectCategory` to set `showSerialDisputesSheet = true` for `.serialDisputes`
- Remove `.serialDisputes` from coming soon cases

**File:** `Denklem/Denklem/Views/Screens/DisputeCategory/DisputeCategoryView.swift`

- Add `.sheet(isPresented: $viewModel.showSerialDisputesSheet)` modifier

## UI Pattern

Follow existing patterns:
- Use `@Environment(\.theme)` for theming
- Use `@available(iOS 26.0, *)` for all views
- Present as sheet, not navigation
- Use Liquid Glass components matching existing UI

## Test Cases

| Year | Type | Files | Expected |
|------|------|-------|----------|
| 2026 | Commercial | 5 | 37,500 TL |
| 2026 | Non-Commercial | 5 | 30,000 TL |
| 2025 | Commercial | 10 | 50,000 TL |
| 2025 | Non-Commercial | 30 | 120,000 TL |

## Reference Documentation

See: `Documentation/SERIAL_DISPUTES_CALCULATION_PLAN.md`
