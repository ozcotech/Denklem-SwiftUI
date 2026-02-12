# DENKLEM - Screen Flow

## Application Flow Overview
DENKLEM uses a tab-based navigation structure with calculation flows branching from the Calculations tab. Each feature uses NavigationStack with `.navigationDestination` for push navigation and `.sheet` for modal presentations.

## Tab Bar Navigation
```
[Home]  [Calculations]  [Legislation]  [Settings]
```
- **Home (StartScreen)**: Welcome screen, year selection, quick access button
- **Calculations (DisputeCategoryView)**: All calculation categories
- **Legislation**: Legal documents viewer
- **Settings**: Language (TR/EN), theme, about

---

## Main Calculation Flows

### 1. Mediation Fee (Monetary + Non-Monetary)
```
DisputeCategoryView
  ├─ [Parasal Olan] ──→ MediationFeeView (isMonetary: true)
  │                      ├─ YearPickerSection (2025/2026)
  │                      ├─ Agreement Picker (Agreed/Not Agreed)
  │                      ├─ Dispute Type Dropdown (10 types)
  │                      ├─ Agreed → Amount Input
  │                      └─ Not Agreed → Party Count Input
  │                          ↓ [Hesapla]
  │                      MediationFeeResultSheet (.sheet)
  │
  └─ [Parasal Olmayan] ──→ MediationFeeView (isMonetary: false)
                           ├─ YearPickerSection (2025/2026)
                           ├─ Non-monetary info text (Art. 7/1)
                           ├─ Dispute Type Dropdown (10 types)
                           └─ Party Count Input
                               ↓ [Hesapla]
                           MediationFeeResultSheet (.sheet)
```

**Files:**
- `Views/Screens/MediationFee/MediationFeeView.swift`
- `Views/Screens/MediationFee/MediationFeeViewModel.swift`
- `Views/Screens/MediationFee/MediationFeeResultSheet.swift`

### 2. Attorney Fee
```
DisputeCategoryView
  └─ [Avukatlık Ücreti] ──→ AttorneyFeeTypeView
                              ├─ Monetary/Non-Monetary selection
                              └─ Agreement selection
                                  ↓
                              AttorneyFeeInputView
                                  ↓ [Hesapla]
                              AttorneyFeeResultSheet (.sheet)
```

**Files:** `Views/Screens/AttorneyFee/`

### 3. Reinstatement (İşe İade)
```
DisputeCategoryView
  └─ [İşe İade] ──→ ReinstatementSheet (.sheet)
                     ├─ YearPickerSection
                     ├─ Agreement Picker
                     ├─ Agreed → Compensation + Idle Wage + Other Rights inputs
                     └─ Not Agreed → Party Count input
                         ↓ [Hesapla]
                     ReinstatementResultView (inline)
```

**Files:** `Views/Screens/Reinstatement/`

### 4. Tenancy (Kira Tahliye/Tespit)
```
DisputeCategoryView
  └─ [Kira Uyuşmazlığı] ──→ TenancySelectionView
                              ├─ YearPickerSection
                              ├─ Fee Mode Picker (Attorney | Mediation)
                              ├─ Eviction checkbox + rent input
                              ├─ Rent Determination checkbox + rent input
                              └─ [Hesapla]
                                  ├─ Attorney → TenancyAttorneyFeeResultSheet (.sheet)
                                  └─ Mediation → TenancyMediationFeeResultSheet (.sheet)
```

**Files:** `Views/Screens/TenancySpecial/`

### 5. Serial Disputes (Seri Uyuşmazlık)
```
DisputeCategoryView
  └─ [Seri Uyuşmazlık] ──→ SerialDisputesSheet (.sheet)
                            ├─ YearPickerSection
                            ├─ Dispute Type Dropdown
                            ├─ File Count input
                            └─ [Hesapla]
                            SerialDisputesResultView (inline)
```

**Files:** `Views/Screens/SerialDisputes/`

### 6. Time Calculation
```
DisputeCategoryView
  └─ [Süre Hesaplama] ──→ TimeCalculationView
                           ├─ YearPickerSection
                           ├─ Dispute Type Dropdown
                           ├─ Hour/Minute inputs
                           └─ [Hesapla] → Result (inline)
```

**Files:** `Views/Screens/TimeCalculation/`

### 7. SMM Calculation
```
DisputeCategoryView
  └─ [SMM Hesaplama] ──→ SMMCalculationView
                          ├─ Amount input
                          ├─ Calculation type selection
                          └─ [Hesapla] → SMMResultSheet (.sheet)
```

**Files:** `Views/Screens/SMMCalculation/`

---

## DisputeCategoryView Navigation Map

```swift
// Navigation destinations (push)
.navigationDestination → MediationFeeView      // Monetary + Non-Monetary
.navigationDestination → TimeCalculationView    // Time calculation
.navigationDestination → SMMCalculationView     // SMM calculation
.navigationDestination → AttorneyFeeTypeView    // Attorney fee
.navigationDestination → TenancySelectionView   // Tenancy special

// Modal sheets
.sheet → ReinstatementSheet                     // Reinstatement
.sheet → SerialDisputesSheet                    // Serial disputes
```

---

## Quick Access (Home Screen)
```
StartScreen
  └─ [Direct Entry Button] ──→ MediationFeeView (isMonetary: true)
```

---

## Screen Details

### StartScreen
**File:** `Views/Screens/StartScreen/StartScreenView.swift`
- Welcome screen with logo animation
- Year selection dropdown (2025/2026)
- Entry button → DisputeCategoryView
- Quick access button → MediationFeeView
- Survey toolbar button (hidden after completion)

### DisputeCategoryView
**File:** `Views/Screens/DisputeCategory/DisputeCategoryView.swift`
- 3 sections: Main Categories (2), Special Calculations (4), Other Calculations (2)
- Main: Monetary, Non-Monetary
- Special: Attorney Fee, Serial Disputes, Reinstatement, Tenancy
- Other: Time Calculation, SMM Calculation
- Coming Soon overlay for future features

### MediationFeeView (Unified Screen)
**File:** `Views/Screens/MediationFee/MediationFeeView.swift`
- Replaces previous 2-screen flow (DisputeTypeView → InputView)
- Single screen with: year picker, agreement picker, dispute type dropdown, input field, calculate button
- Conditional UI based on isMonetary and hasAgreement flags
- FocusState + ScrollViewReader for keyboard handling

---

**Screen Flow Version:** 2.0
**Last Updated:** February 2026
**Navigation Pattern:** NavigationStack with .navigationDestination + .sheet modals
