# Seri Uyuşmazlık Hesaplama Özelliği - Planlama Dokümanı

## İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Yasal Dayanak](#yasal-dayanak)
3. [Hesaplama Kuralları](#hesaplama-kuralları)
4. [Kullanıcı Akışı](#kullanıcı-akışı)
5. [Dosya Yapısı](#dosya-yapısı)
6. [Yeni Dosyalar](#yeni-dosyalar)
7. [Güncellenecek Dosyalar](#güncellenecek-dosyalar)
8. [Uygulama Planı](#uygulama-planı)

---

## Genel Bakış

Bu özellik, arabuluculuk sürecinde **seri uyuşmazlık** durumlarında arabuluculuk ücretini hesaplamak için geliştirilecektir.

### Seri Uyuşmazlık Nedir?

Bir işyerinde örneğin 30 işçi çalışıyor ve işveren bu işçilerle yolunu ayırmaya karar veriyor. Burada 1 işveren taraf var ve 30 işçi taraf var. İşçiler veya işveren arabuluculuğa başvuruyor ve aynı işçi-işveren uyuşmazlığına ilişkin seri başvuruda bulunuyor. Yani arabulucuya bir görev geliyor ancak 30 dosya açılmış oluyor.

**Tanım:** Taraflardan birinin aynı olduğu ve bir ay içinde başvurulan en az on uyuşmazlık seri uyuşmazlık olarak kabul edilir.

### Temel Özellikler

- **Tarife Yılları:** 2025 ve 2026
- **Uyuşmazlık Türleri:**
  - Ticari Uyuşmazlıklar
  - Ticari Harici Uyuşmazlıklar
- **Sonuç:** Toplam arabuluculuk ücreti

---

## Yasal Dayanak

### 2026 Arabuluculuk Ücret Tarifesi - Madde 7/4

> Arabuluculuk sürecinin sonunda seri uyuşmazlıklarda anlaşma sağlanması halinde, arabuluculuğun konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlık olsa bile arabulucu, her bir uyuşmazlık bakımından, **ticari uyuşmazlıklarda 7.500,00 TL**, **diğer uyuşmazlıklarda ise 6.000,00 TL** ücret isteyebilir.
>
> Taraflardan birinin aynı olduğu ve bir ay içinde başvurulan en az on uyuşmazlık seri uyuşmazlık olarak kabul edilir.

### 2025 Arabuluculuk Ücret Tarifesi - Madde 7/4

- **Ticari Uyuşmazlıklar:** 5.000,00 TL
- **Diğer Uyuşmazlıklar:** 4.000,00 TL

---

## Hesaplama Kuralları

### Hesaplama Formülü

```
Toplam Ücret = Dosya Sayısı × Dosya Başı Ücret
```

### 2026 Yılı Ücretleri

| Uyuşmazlık Türü | Dosya Başı Ücret |
|-----------------|------------------|
| Ticari Uyuşmazlıklar | 7.500,00 TL |
| Ticari Harici Uyuşmazlıklar | 6.000,00 TL |

### 2025 Yılı Ücretleri

| Uyuşmazlık Türü | Dosya Başı Ücret |
|-----------------|------------------|
| Ticari Uyuşmazlıklar | 5.000,00 TL |
| Ticari Harici Uyuşmazlıklar | 4.000,00 TL |

### Örnek Hesaplamalar

#### Örnek 1: 2026 - Ticari Uyuşmazlık, 5 Dosya
```
5 × 7.500 = 37.500,00 TL
```

#### Örnek 2: 2026 - Ticari Harici Uyuşmazlık, 5 Dosya
```
5 × 6.000 = 30.000,00 TL
```

#### Örnek 3: 2025 - Ticari Uyuşmazlık, 10 Dosya
```
10 × 5.000 = 50.000,00 TL
```

#### Örnek 4: 2025 - Ticari Harici Uyuşmazlık, 30 Dosya
```
30 × 4.000 = 120.000,00 TL
```

---

## Kullanıcı Akışı

```
DisputeCategoryView (Mevcut Ekran)
    └── Özel Hesaplamalar Bölümü
            └── Seri Uyuşmazlık ────────────────────────────────────┐
                                                                     ▼
                    ┌──────────────────────────────────────────────────┐
                    │        SerialDisputesSheet (SHEET)               │
                    │                                                   │
                    │  ┌─────────────────────────────────────────────┐ │
                    │  │           Uyuşmazlık Türü                   │ │
                    │  │  ┌─────────────────────────────────────┐    │ │
                    │  │  │ ▼ Ticari Uyuşmazlıklar              │    │ │
                    │  │  └─────────────────────────────────────┘    │ │
                    │  │    ○ Ticari Uyuşmazlıklar                   │ │
                    │  │    ○ Ticari Harici Uyuşmazlıklar            │ │
                    │  └─────────────────────────────────────────────┘ │
                    │                                                   │
                    │  ┌─────────────────────────────────────────────┐ │
                    │  │           Dosya Sayısı                      │ │
                    │  │  ┌─────────────────────────────────────┐    │ │
                    │  │  │                               5     │    │ │
                    │  │  └─────────────────────────────────────┘    │ │
                    │  └─────────────────────────────────────────────┘ │
                    │                                                   │
                    │  ┌─────────────────────────────────────────────┐ │
                    │  │               [Hesapla]                     │ │
                    │  └─────────────────────────────────────────────┘ │
                    └──────────────────────────────────────────────────┘
                                          │
                                          ▼
                    ┌──────────────────────────────────────────────────┐
                    │      SerialDisputesResultSheet (SONUÇ)          │
                    │                                                   │
                    │  Toplam Arabuluculuk Ücreti                      │
                    │  ═══════════════════════════                     │
                    │         ₺37.500,00                               │
                    │                                                   │
                    │  ────────────────────────────                    │
                    │  Hesaplama Detayları:                            │
                    │  • Uyuşmazlık Türü: Ticari                       │
                    │  • Dosya Sayısı: 5                               │
                    │  • Dosya Başı Ücret: ₺7.500,00                   │
                    │  • Tarife Yılı: 2026                             │
                    │                                                   │
                    │  📋 Yasal Dayanak                                │
                    │  2026 Arabuluculuk Ücret Tarifesi Madde 7/4     │
                    │                                                   │
                    │  [Kapat]                                          │
                    └──────────────────────────────────────────────────┘
```

**Akış Açıklaması:**

1. Kullanıcı DisputeCategoryView ekranında "Seri Uyuşmazlık" butonuna basar
2. Bir sheet açılır (navigation değil, sheet)
3. Sheet içinde:
   - Dropdown menü: Ticari / Ticari Harici seçimi
   - Input field: Dosya sayısı girişi
   - Hesapla butonu
4. Hesapla butonuna basınca sonuç gösterilir
5. Tarife yılı StartScreen'den seçilen yıla göre otomatik belirlenir

---

## Dosya Yapısı

### Yeni Klasör Yapısı

```
Denklem/
├── Constants/
│   └── SerialDisputesConstants.swift     [YENİ]
│
├── Localization/
│   ├── LocalizationKeys.swift            [GÜNCELLE]
│   └── Localizable.xcstrings             [GÜNCELLE]
│
├── Models/
│   ├── Calculation/
│   │   └── SerialDisputesCalculator.swift [YENİ]
│   ├── Data/
│   │   └── SerialDisputesTariff.swift     [YENİ] (2025 + 2026 birlikte)
│   └── Domain/
│       └── SerialDisputesResult.swift     [YENİ]
│
└── Views/
    └── Screens/
        ├── DisputeCategory/
        │   ├── DisputeCategoryView.swift      [GÜNCELLE]
        │   └── DisputeCategoryViewModel.swift [GÜNCELLE]
        │
        └── SerialDisputes/                    [YENİ KLASÖR]
            ├── SerialDisputesSheet.swift      [YENİ]
            ├── SerialDisputesViewModel.swift  [YENİ]
            └── SerialDisputesResultView.swift [YENİ]
```

---

## Yeni Dosyalar

### 1. Constants/SerialDisputesConstants.swift

**Amaç:** Seri uyuşmazlık hesaplama sabitleri

```swift
import SwiftUI

// MARK: - Serial Disputes Constants
struct SerialDisputesConstants {

    // MARK: - Dispute Type Enum
    enum DisputeType: String, CaseIterable, Identifiable, Codable {
        case commercial = "commercial"           // Ticari Uyuşmazlıklar
        case nonCommercial = "non_commercial"    // Ticari Harici Uyuşmazlıklar

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .commercial:
                return LocalizationKeys.SerialDisputes.commercialDispute.localized
            case .nonCommercial:
                return LocalizationKeys.SerialDisputes.nonCommercialDispute.localized
            }
        }

        var iconColor: Color {
            switch self {
            case .commercial:
                return .blue
            case .nonCommercial:
                return .green
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

### 2. Models/Data/SerialDisputesTariff.swift

**Amaç:** 2025 ve 2026 tarife verileri

```swift
import Foundation

// MARK: - Serial Disputes Tariff
struct SerialDisputesTariff {

    // MARK: - 2026 Fees
    struct Tariff2026 {
        static let year: Int = 2026
        static let commercialFeePerFile: Double = 7_500.0
        static let nonCommercialFeePerFile: Double = 6_000.0
    }

    // MARK: - 2025 Fees
    struct Tariff2025 {
        static let year: Int = 2025
        static let commercialFeePerFile: Double = 5_000.0
        static let nonCommercialFeePerFile: Double = 4_000.0
    }

    // MARK: - Fee Retrieval
    static func getFeePerFile(
        for disputeType: SerialDisputesConstants.DisputeType,
        year: Int
    ) -> Double {
        switch year {
        case 2026:
            return disputeType == .commercial ?
                Tariff2026.commercialFeePerFile :
                Tariff2026.nonCommercialFeePerFile
        case 2025:
            return disputeType == .commercial ?
                Tariff2025.commercialFeePerFile :
                Tariff2025.nonCommercialFeePerFile
        default:
            return Tariff2026.nonCommercialFeePerFile
        }
    }
}
```

### 3. Models/Domain/SerialDisputesResult.swift

**Amaç:** Hesaplama sonuç modeli

```swift
import Foundation

// MARK: - Serial Disputes Input
struct SerialDisputesInput: Equatable, Codable {
    let disputeType: SerialDisputesConstants.DisputeType
    let fileCount: Int
    let tariffYear: Int

    func validate() -> ValidationResult {
        guard fileCount >= SerialDisputesConstants.Validation.minimumFileCount else {
            return .failure(
                code: 1001,
                message: LocalizationKeys.SerialDisputes.invalidFileCount.localized
            )
        }
        guard fileCount <= SerialDisputesConstants.Validation.maximumFileCount else {
            return .failure(
                code: 1002,
                message: LocalizationKeys.SerialDisputes.maxFileCountExceeded.localized
            )
        }
        return .success
    }
}

// MARK: - Serial Disputes Result
struct SerialDisputesResult: Equatable, Codable {
    let totalFee: Double
    let feePerFile: Double
    let disputeType: SerialDisputesConstants.DisputeType
    let fileCount: Int
    let tariffYear: Int

    var formattedTotalFee: String {
        LocalizationHelper.formatCurrency(totalFee)
    }

    var formattedFeePerFile: String {
        LocalizationHelper.formatCurrency(feePerFile)
    }
}
```

### 4. Models/Calculation/SerialDisputesCalculator.swift

**Amaç:** Hesaplama motoru

```swift
import Foundation

// MARK: - Serial Disputes Calculator
struct SerialDisputesCalculator {

    /// Seri uyuşmazlık ücreti hesapla
    static func calculate(input: SerialDisputesInput) -> SerialDisputesResult {
        // Get fee per file from tariff
        let feePerFile = SerialDisputesTariff.getFeePerFile(
            for: input.disputeType,
            year: input.tariffYear
        )

        // Calculate total fee
        let totalFee = Double(input.fileCount) * feePerFile

        return SerialDisputesResult(
            totalFee: totalFee,
            feePerFile: feePerFile,
            disputeType: input.disputeType,
            fileCount: input.fileCount,
            tariffYear: input.tariffYear
        )
    }
}
```

### 5. Views/Screens/SerialDisputes/SerialDisputesSheet.swift

**Amaç:** Ana sheet ekranı

```swift
@available(iOS 26.0, *)
struct SerialDisputesSheet: View {
    @StateObject private var viewModel: SerialDisputesViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: SerialDisputesViewModel(selectedYear: selectedYear))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingXL) {
                    // Dispute Type Picker
                    disputeTypePicker

                    // File Count Input
                    fileCountInput

                    // Calculate Button
                    calculateButton
                }
                .padding()
            }
            .navigationTitle(LocalizationKeys.SerialDisputes.screenTitle.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizationKeys.General.close.localized) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showResult) {
                if let result = viewModel.calculationResult {
                    SerialDisputesResultView(result: result)
                }
            }
        }
    }
}
```

### 6. Views/Screens/SerialDisputes/SerialDisputesViewModel.swift

**Amaç:** Sheet için ViewModel

```swift
@available(iOS 26.0, *)
@MainActor
final class SerialDisputesViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedDisputeType: SerialDisputesConstants.DisputeType = .commercial
    @Published var fileCountText: String = ""
    @Published var showResult: Bool = false
    @Published var calculationResult: SerialDisputesResult?
    @Published var errorMessage: String?

    // MARK: - Properties
    let selectedYear: TariffYear

    // MARK: - Computed Properties
    var isCalculateButtonEnabled: Bool {
        guard let count = Int(fileCountText), count > 0 else { return false }
        return true
    }

    var disputeTypes: [SerialDisputesConstants.DisputeType] {
        SerialDisputesConstants.DisputeType.allCases
    }

    // MARK: - Initialization
    init(selectedYear: TariffYear) {
        self.selectedYear = selectedYear
    }

    // MARK: - Methods
    func performCalculation() {
        guard let fileCount = Int(fileCountText) else {
            errorMessage = LocalizationKeys.SerialDisputes.invalidFileCount.localized
            return
        }

        let input = SerialDisputesInput(
            disputeType: selectedDisputeType,
            fileCount: fileCount,
            tariffYear: selectedYear.value
        )

        let validation = input.validate()
        guard validation.isValid else {
            errorMessage = validation.message
            return
        }

        errorMessage = nil
        calculationResult = SerialDisputesCalculator.calculate(input: input)
        showResult = true
    }
}
```

### 7. Views/Screens/SerialDisputes/SerialDisputesResultView.swift

**Amaç:** Sonuç görünümü

```swift
@available(iOS 26.0, *)
struct SerialDisputesResultView: View {
    let result: SerialDisputesResult
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingXL) {
                    // Main Result Card
                    mainResultCard

                    // Breakdown Card
                    breakdownCard

                    // Legal Reference Card
                    legalReferenceCard
                }
                .padding()
            }
            .navigationTitle(LocalizationKeys.SerialDisputes.resultTitle.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizationKeys.General.close.localized) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationBackground(.clear)
    }
}
```

---

## Güncellenecek Dosyalar

### 1. DisputeCategoryViewModel.swift

**Değişiklikler:**

```swift
// MARK: - Navigation Flags - [GÜNCELLE]
@Published var showSerialDisputesSheet: Bool = false  // [YENİ]

// MARK: - selectCategory Method - [GÜNCELLE]
func selectCategory(_ category: DisputeCategoryType) {
    switch category {
    // ... mevcut cases
    case .serialDisputes:
        showSerialDisputesSheet = true  // [DEĞİŞTİR - coming soon yerine]
    case .rentSpecial, .reinstatement:
        // Show coming soon popover
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            showComingSoonPopover = true
        }
    }
}
```

### 2. DisputeCategoryView.swift

**Değişiklikler:**

```swift
// MARK: - Body - [GÜNCELLE]
var body: some View {
    // ... mevcut kod
    .sheet(isPresented: $viewModel.showSerialDisputesSheet) {  // [YENİ]
        SerialDisputesSheet(selectedYear: viewModel.selectedYear)
    }
}
```

### 3. LocalizationKeys.swift

**Yeni Eklenecek Keys:**

```swift
// MARK: - [YENİ] Serial Disputes
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
    static let fileCountHint = "serial_disputes.file_count_hint"

    // Result Labels
    static let totalFee = "serial_disputes.total_fee"
    static let feePerFile = "serial_disputes.fee_per_file"
    static let calculationBreakdown = "serial_disputes.calculation_breakdown"

    // Validation
    static let invalidFileCount = "serial_disputes.invalid_file_count"
    static let maxFileCountExceeded = "serial_disputes.max_file_count_exceeded"

    // Legal Reference
    static let legalReference = "serial_disputes.legal_reference"
}
```

### 4. Localizable.xcstrings

**Yeni Eklenecek Çeviriler:**

| Key | Türkçe | İngilizce |
|-----|--------|-----------|
| `serial_disputes.screen_title` | Seri Uyuşmazlık | Serial Dispute |
| `serial_disputes.result_title` | Hesaplama Sonucu | Calculation Result |
| `serial_disputes.select_dispute_type` | Uyuşmazlık Türü Seçin | Select Dispute Type |
| `serial_disputes.commercial_dispute` | Ticari Uyuşmazlıklar | Commercial Disputes |
| `serial_disputes.non_commercial_dispute` | Ticari Harici Uyuşmazlıklar | Non-Commercial Disputes |
| `serial_disputes.file_count` | Dosya Sayısı | File Count |
| `serial_disputes.file_count_hint` | Uyuşmazlık dosya miktarını girin | Enter number of dispute files |
| `serial_disputes.total_fee` | Toplam Ücret | Total Fee |
| `serial_disputes.fee_per_file` | Dosya Başı Ücret | Fee Per File |
| `serial_disputes.calculation_breakdown` | Hesaplama Detayları | Calculation Details |
| `serial_disputes.invalid_file_count` | Geçerli bir dosya sayısı girin | Enter a valid file count |
| `serial_disputes.max_file_count_exceeded` | Maksimum dosya sayısı aşıldı | Maximum file count exceeded |
| `serial_disputes.legal_reference` | Arabuluculuk Ücret Tarifesi Madde 7/4 | Mediation Fee Tariff Article 7/4 |

---

## Uygulama Planı

### Aşama 1: Temel Yapı (Constants & Models)

1. [ ] `SerialDisputesConstants.swift` oluştur
2. [ ] `SerialDisputesTariff.swift` oluştur (2025 + 2026 birlikte)
3. [ ] `SerialDisputesResult.swift` oluştur (input + result modelleri)
4. [ ] `SerialDisputesCalculator.swift` oluştur

### Aşama 2: Lokalizasyon Güncellemeleri

5. [ ] `LocalizationKeys.swift` güncelle (SerialDisputes struct ekle)
6. [ ] `Localizable.xcstrings` güncelle (TR/EN çeviriler)

### Aşama 3: View & ViewModel

7. [ ] `SerialDisputesViewModel.swift` oluştur
8. [ ] `SerialDisputesSheet.swift` oluştur
9. [ ] `SerialDisputesResultView.swift` oluştur

### Aşama 4: Navigation Entegrasyonu

10. [ ] `DisputeCategoryViewModel.swift` güncelle (showSerialDisputesSheet)
11. [ ] `DisputeCategoryView.swift` güncelle (sheet modifier ekle)

### Aşama 5: Test

12. [ ] Hesaplama testleri
13. [ ] UI flow testi

---

## Hesaplama Test Senaryoları

| Senaryo | Yıl | Tür | Dosya | Beklenen Sonuç |
|---------|-----|-----|-------|----------------|
| 1 | 2026 | Ticari | 5 | 37.500,00 TL |
| 2 | 2026 | Ticari Harici | 5 | 30.000,00 TL |
| 3 | 2026 | Ticari | 30 | 225.000,00 TL |
| 4 | 2026 | Ticari Harici | 30 | 180.000,00 TL |
| 5 | 2025 | Ticari | 10 | 50.000,00 TL |
| 6 | 2025 | Ticari Harici | 10 | 40.000,00 TL |

---

## Dikkat Edilecek Noktalar

1. **iOS 26.0+ Requirement:** Tüm view'lar `@available(iOS 26.0, *)` ile işaretlenmeli
2. **Theme Injection:** `@Environment(\.theme) var theme` kullanılmalı
3. **Localization:** Hiçbir string hardcoded olmamalı
4. **Liquid Glass:** Mevcut UI pattern'lere uyum sağlanmalı
5. **Validation:** Dosya sayısı input'u valide edilmeli
6. **Year Selection:** StartScreen'den gelen yıl kullanılmalı

---

## Referanslar

- 2026 Arabuluculuk Ücret Tarifesi - Madde 7/4
- 2025 Arabuluculuk Ücret Tarifesi - Madde 7/4

---

**Doküman Oluşturma Tarihi:** 31 Ocak 2026
**Versiyon:** 1.0
