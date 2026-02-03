# İşe İade Hesaplama Özelliği - Planlama Dokümanı

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

Bu özellik, **işe iade** uyuşmazlıklarında arabuluculuk ücretini hesaplamak için geliştirilecektir. İşe iade, iş hukuku kapsamında işçinin işten çıkarılmasının ardından işe iadesini talep ettiği özel bir uyuşmazlık türüdür.

### İşe İade Nedir?

İşçi, işveren tarafından iş akdinin feshedilmesi üzerine işe iadesini talep edebilir. Bu talep arabuluculuk yoluyla çözümlenebilir. Arabuluculuk sürecinde taraflar anlaşabilir veya anlaşamayabilir.

### Temel Özellikler

- **Tarife Yılları:** 2025 ve 2026 (her iki yıl için farklı oranlar ve ücretler)
- **Uyuşmazlık Türü:** İşçi-İşveren (workerEmployer)
- **Senaryolar:**
  - Anlaşma sağlanması halinde (3 bileşenli hesaplama)
  - Anlaşma sağlanamaması halinde (sabit ücret hesaplama)
- **Sonuç:** Arabuluculuk ücreti

---

## Yasal Dayanak

### İş Mahkemeleri Kanunu (7036 Sayılı Kanun) - Madde 3/13-2

> İşe iade talebiyle yapılan görüşmelerde tarafların anlaşmaları durumunda, arabuluculuk ücretinin belirlenmesinde;
> - İşçiye işe başlatılmaması halinde ödenecek tazminat miktarı ile
> - Çalıştırılmadığı süre için ödenecek ücret ve
> - Diğer hakların toplamı
>
> Tarifenin ikinci kısmı uyarınca üzerinde anlaşılan miktar olarak kabul edilir.

### İş Kanunu (4857 Sayılı Kanun) - Madde 20/2

> Arabuluculuk faaliyeti sonunda anlaşmaya varılamaması halinde, son tutanağın düzenlendiği tarihten itibaren iki hafta içinde iş mahkemesinde dava açılabilir.

### İş Kanunu (4857 Sayılı Kanun) - Madde 21/7

> Arabuluculuk faaliyeti sonunda tarafların, işçinin işe başlatılması konusunda anlaşmaları hâlinde;
> a) İşe başlatma tarihini,
> b) Üçüncü fıkrada düzenlenen ücret ve diğer hakların parasal miktarını,
> c) İşçinin işe başlatılmaması durumunda ikinci fıkrada düzenlenen tazminatın parasal miktarını,
> belirlemeleri zorunludur.

---

## Hesaplama Kuralları

### 1. Anlaşma Sağlanması Halinde

#### Girdi Bileşenleri

| # | Bileşen | Zorunluluk | Açıklama |
|---|---------|------------|----------|
| 1 | İşe başlatılmama tazminatı | Zorunlu | İşçinin işe başlatılmaması halinde ödenecek tazminat |
| 2 | Boşta geçen süre ücreti | Zorunlu | Çalıştırılmadığı süre için ödenecek ücret |
| 3 | Diğer haklar | Opsiyonel | Varsa diğer haklar (izin ücreti, ikramiye vb.) |
| 4 | Taraf sayısı | Zorunlu | Minimum 2 (işçi + işveren) |

#### Hesaplama Formülü

```
1. Toplam Miktar = Tazminat + Boşta Süre Ücreti + Diğer Haklar
2. Bracket Hesaplama (Tarife İkinci Kısım)
3. Minimum Ücret Kontrolü (9.000 TL)
4. Sonuç = max(BracketFee, MinimumFee)
```

#### Tarife İkinci Kısım - Bracket Dilimleri (2026)

| Dilim | Miktar Aralığı | Oran |
|-------|----------------|------|
| 1 | İlk 600.000 TL | %6 |
| 2 | Sonraki 960.000 TL (600.001 - 1.560.000) | %5 |
| 3 | Sonraki 1.560.000 TL (1.560.001 - 3.120.000) | %4 |
| 4 | Sonraki 3.120.000 TL (3.120.001 - 6.240.000) | %3 |
| 5 | Sonraki 9.360.000 TL (6.240.001 - 15.600.000) | %2 |
| 6 | Sonraki 12.480.000 TL (15.600.001 - 28.080.000) | %1,5 |
| 7 | Sonraki 24.960.000 TL (28.080.001 - 53.040.000) | %1 |
| 8 | 53.040.000 TL üzeri | %0,5 |

**Minimum Ücret (2026):** 9.000 TL

#### Tarife İkinci Kısım - Bracket Dilimleri (2025)

| Dilim | Miktar Aralığı | Oran |
|-------|----------------|------|
| 1 | İlk 300.000 TL | %6 |
| 2 | Sonraki 480.000 TL (300.001 - 780.000) | %5 |
| 3 | Sonraki 780.000 TL (780.001 - 1.560.000) | %4 |
| 4 | Sonraki 3.120.000 TL (1.560.001 - 4.680.000) | %3 |
| 5 | Sonraki 1.560.000 TL (4.680.001 - 6.240.000) | %2 |
| 6 | Sonraki 6.240.000 TL (6.240.001 - 12.480.000) | %1,5 |
| 7 | Sonraki 14.040.000 TL (12.480.001 - 26.520.000) | %1 |
| 8 | 26.520.000 TL üzeri | %0,5 |

**Minimum Ücret (2025):** 6.000 TL

### 2. Anlaşma Sağlanamaması Halinde

#### Girdi Bileşenleri

| # | Bileşen | Zorunluluk | Açıklama |
|---|---------|------------|----------|
| 1 | Taraf sayısı | Zorunlu | Minimum 2 (işçi + işveren) |

#### Hesaplama Formülü

```
Arabuluculuk Ücreti = Sabit Ücret × 2
```

#### Sabit Ücretler (2026 - İşçi-İşveren)

| Taraf Sayısı | Sabit Ücret | Hesaplanan Ücret (×2) |
|--------------|-------------|----------------------|
| 2 taraf | 2.260 TL | 4.520 TL |
| 3-5 taraf | 2.460 TL | 4.920 TL |
| 6-10 taraf | 2.560 TL | 5.120 TL |
| 11+ taraf | 2.660 TL | 5.320 TL |

#### Sabit Ücretler (2025 - İşçi-İşveren)

| Taraf Sayısı | Sabit Ücret | Hesaplanan Ücret (×2) |
|--------------|-------------|----------------------|
| 2 taraf | 1.570 TL | 3.140 TL |
| 3-5 taraf | 1.650 TL | 3.300 TL |
| 6-10 taraf | 1.750 TL | 3.500 TL |
| 11+ taraf | 1.850 TL | 3.700 TL |

---

## Örnek Hesaplamalar

### Örnek 1: Anlaşma - Düşük Miktar (Minimum Ücret Uygulanır)

```
Girdiler:
- İşe başlatılmama tazminatı: 50.000 TL
- Boşta geçen süre ücreti: 30.000 TL
- Diğer haklar: 0 TL
- Taraf sayısı: 2

Hesaplama:
- Toplam: 80.000 TL
- Bracket: 80.000 × %6 = 4.800 TL
- Minimum: 9.000 TL
- Sonuç: max(4.800, 9.000) = 9.000 TL
```

### Örnek 2: Anlaşma - Normal Miktar

```
Girdiler:
- İşe başlatılmama tazminatı: 100.000 TL
- Boşta geçen süre ücreti: 50.000 TL
- Diğer haklar: 10.000 TL
- Taraf sayısı: 2

Hesaplama:
- Toplam: 160.000 TL
- Bracket: 160.000 × %6 = 9.600 TL
- Minimum: 9.000 TL
- Sonuç: max(9.600, 9.000) = 9.600 TL
```

### Örnek 3: Anlaşma - Yüksek Miktar (Çoklu Dilim)

```
Girdiler:
- İşe başlatılmama tazminatı: 500.000 TL
- Boşta geçen süre ücreti: 200.000 TL
- Diğer haklar: 100.000 TL
- Taraf sayısı: 2

Hesaplama:
- Toplam: 800.000 TL
- Bracket:
  - İlk 600.000 × %6 = 36.000 TL
  - Sonraki 200.000 × %5 = 10.000 TL
  - Toplam: 46.000 TL
- Minimum: 9.000 TL
- Sonuç: max(46.000, 9.000) = 46.000 TL
```

### Örnek 4: Anlaşmama - 2 Taraf

```
Girdiler:
- Taraf sayısı: 2

Hesaplama:
- Sabit Ücret: 2.260 TL
- Sonuç: 2.260 × 2 = 4.520 TL
```

### Örnek 5: Anlaşmama - 5 Taraf

```
Girdiler:
- Taraf sayısı: 5

Hesaplama:
- Sabit Ücret: 2.460 TL (3-5 taraf dilimi)
- Sonuç: 2.460 × 2 = 4.920 TL
```

---

## Kullanıcı Akışı

### Yaklaşım: Tek Sheet (D Yaklaşımı)

```
DisputeCategoryView (Mevcut Ekran)
    └── Özel Hesaplamalar Bölümü
            └── İşe İade ──────────────────────────────────────────────┐
                                                                        ▼
                    ┌─────────────────────────────────────────────────────┐
                    │           ReinstatementSheet (SHEET)                │
                    │                                                      │
                    │  ┌────────────────────────────────────────────────┐ │
                    │  │              Yasal Referans                     │ │
                    │  │  İş Mahkemeleri Kanunu m.3/13-2                │ │
                    │  │  İş Kanunu m.20-2, m.21/7                      │ │
                    │  └────────────────────────────────────────────────┘ │
                    │                                                      │
                    │  ┌────────────────────────────────────────────────┐ │
                    │  │           Anlaşma Durumu Seçimi                 │ │
                    │  │  ┌──────────────┐  ┌──────────────┐            │ │
                    │  │  │   Anlaşma    │  │  Anlaşmama   │            │ │
                    │  │  │      ✓       │  │              │            │ │
                    │  │  └──────────────┘  └──────────────┘            │ │
                    │  └────────────────────────────────────────────────┘ │
                    │                                                      │
                    │  ┌────────────────────────────────────────────────┐ │
                    │  │        [ANLAŞMA SEÇİLDİĞİNDE]                  │ │
                    │  │                                                 │ │
                    │  │  İşe Başlatılmama Tazminatı                    │ │
                    │  │  ┌─────────────────────────────────┐           │ │
                    │  │  │                      100.000 ₺  │           │ │
                    │  │  └─────────────────────────────────┘           │ │
                    │  │                                                 │ │
                    │  │  Boşta Geçen Süre Ücreti                       │ │
                    │  │  ┌─────────────────────────────────┐           │ │
                    │  │  │                       50.000 ₺  │           │ │
                    │  │  └─────────────────────────────────┘           │ │
                    │  │                                                 │ │
                    │  │  Diğer Haklar (İsteğe Bağlı)                   │ │
                    │  │  ┌─────────────────────────────────┐           │ │
                    │  │  │                       10.000 ₺  │           │ │
                    │  │  └─────────────────────────────────┘           │ │
                    │  │                                                 │ │
                    │  │  Taraf Sayısı                                  │ │
                    │  │  ┌─────────────────────────────────┐           │ │
                    │  │  │                              2  │           │ │
                    │  │  └─────────────────────────────────┘           │ │
                    │  └────────────────────────────────────────────────┘ │
                    │                                                      │
                    │  ┌────────────────────────────────────────────────┐ │
                    │  │        [ANLAŞMAMA SEÇİLDİĞİNDE]                │ │
                    │  │                                                 │ │
                    │  │  Taraf Sayısı                                  │ │
                    │  │  ┌─────────────────────────────────┐           │ │
                    │  │  │                              2  │           │ │
                    │  │  └─────────────────────────────────┘           │ │
                    │  └────────────────────────────────────────────────┘ │
                    │                                                      │
                    │  ┌────────────────────────────────────────────────┐ │
                    │  │               [Hesapla]                         │ │
                    │  └────────────────────────────────────────────────┘ │
                    └─────────────────────────────────────────────────────┘
                                          │
                                          ▼
                    ┌─────────────────────────────────────────────────────┐
                    │        ReinstatementResultView (SONUÇ)             │
                    │                                                      │
                    │  Arabuluculuk Ücreti                                │
                    │  ═══════════════════════════                        │
                    │         ₺9.600,00                                   │
                    │                                                      │
                    │  ────────────────────────────                       │
                    │  Hesaplama Detayları:                               │
                    │  • İşe Başlatılmama Tazminatı: ₺100.000,00         │
                    │  • Boşta Geçen Süre Ücreti: ₺50.000,00             │
                    │  • Diğer Haklar: ₺10.000,00                        │
                    │  • Toplam Miktar: ₺160.000,00                      │
                    │  • Taraf Sayısı: 2                                  │
                    │  • Tarife Yılı: 2026                               │
                    │                                                      │
                    │  📋 Yasal Dayanak                                   │
                    │  İş Mahkemeleri Kanunu m.3/13-2                     │
                    │  Tarife İkinci Kısım                                │
                    │                                                      │
                    │  [Yeniden Hesapla]              [Kapat]             │
                    └─────────────────────────────────────────────────────┘
```

**Akış Açıklaması:**

1. Kullanıcı DisputeCategoryView ekranında "İşe İade" butonuna basar
2. Bir sheet açılır (SerialDisputes pattern'i)
3. Sheet içinde:
   - Yasal referans başlığı
   - Anlaşma/Anlaşmama seçimi (segmented control veya iki buton)
   - Seçime göre koşullu input alanları
   - Hesapla butonu
4. Hesapla butonuna basınca sonuç görünümü gösterilir
5. Tarife yılı StartScreen'den seçilen yıla göre otomatik belirlenir

---

## Dosya Yapısı

### Yeni Klasör Yapısı

```
Denklem/
├── Constants/
│   └── ReinstatementConstants.swift        [YENİ]
│
├── Localization/
│   ├── LocalizationKeys.swift              [GÜNCELLE]
│   └── Localizable.xcstrings               [GÜNCELLE]
│
├── Models/
│   ├── Calculation/
│   │   └── ReinstatementCalculator.swift   [YENİ]
│   └── Domain/
│       └── ReinstatementResult.swift       [YENİ]
│
└── Views/
    └── Screens/
        ├── DisputeCategory/
        │   ├── DisputeCategoryView.swift       [GÜNCELLE]
        │   └── DisputeCategoryViewModel.swift  [GÜNCELLE]
        │
        └── Reinstatement/                      [YENİ KLASÖR]
            ├── ReinstatementSheet.swift        [YENİ]
            ├── ReinstatementViewModel.swift    [YENİ]
            └── ReinstatementResultView.swift   [YENİ]
```

---

## Yeni Dosyalar

### 1. Constants/ReinstatementConstants.swift

**Amaç:** İşe iade hesaplama sabitleri

```swift
import SwiftUI

// MARK: - Reinstatement Constants
struct ReinstatementConstants {

    // MARK: - Validation
    struct Validation {
        static let minimumAmount: Double = 0.01
        static let maximumAmount: Double = 999_999_999.0
        static let minimumPartyCount: Int = 2
        static let maximumPartyCount: Int = 1000
    }

    // MARK: - Legal References
    struct LegalReferences {
        static let agreementArticle = "İş Mahkemeleri Kanunu m.3/13-2"
        static let noAgreementArticle = "İş Kanunu m.20-2"
        static let obligationsArticle = "İş Kanunu m.21/7"
        static let tariffSection = "Tarife İkinci Kısım"
    }
}
```

### 2. Models/Domain/ReinstatementResult.swift

**Amaç:** Hesaplama giriş ve sonuç modelleri

```swift
import Foundation

// MARK: - Reinstatement Input
struct ReinstatementInput: Equatable, Codable {
    let agreementStatus: AgreementStatus
    let tariffYear: TariffYear
    let partyCount: Int

    // Anlaşma durumu için (İş Mahkemeleri Kanunu m.3/13-2)
    let nonReinstatementCompensation: Double?  // İşe başlatılmama tazminatı
    let idlePeriodWage: Double?                 // Boşta geçen süre ücreti
    let otherRights: Double?                    // Diğer haklar (opsiyonel)

    // Toplam anlaşma miktarı (computed)
    var totalAgreementAmount: Double? {
        guard agreementStatus == .agreed,
              let compensation = nonReinstatementCompensation,
              let wage = idlePeriodWage else { return nil }
        return compensation + wage + (otherRights ?? 0)
    }

    func validate() -> ValidationResult { ... }
}

// MARK: - Reinstatement Result
struct ReinstatementResult: Equatable, Codable {
    let totalFee: Double
    let agreementStatus: AgreementStatus
    let tariffYear: TariffYear
    let partyCount: Int
    let breakdown: ReinstatementBreakdown?

    var formattedTotalFee: String {
        LocalizationHelper.formatCurrency(totalFee)
    }

    var legalReference: String { ... }
}

// MARK: - Reinstatement Breakdown
struct ReinstatementBreakdown: Equatable, Codable {
    let nonReinstatementCompensation: Double
    let idlePeriodWage: Double
    let otherRights: Double
    let totalAmount: Double
    let bracketFee: Double
    let minimumFee: Double
    let isMinimumApplied: Bool
}
```

### 3. Models/Calculation/ReinstatementCalculator.swift

**Amaç:** Hesaplama motoru (mevcut TariffProtocol metodlarını kullanır)

```swift
import Foundation

// MARK: - Reinstatement Calculator
struct ReinstatementCalculator {

    /// Ana hesaplama metodu
    static func calculate(input: ReinstatementInput) -> ReinstatementResult {
        guard let tariff = TariffFactory.createTariff(for: input.tariffYear.rawValue) else {
            fatalError("Tariff not found for year: \(input.tariffYear.rawValue)")
        }

        let fee: Double
        var breakdown: ReinstatementBreakdown? = nil

        if input.agreementStatus == .agreed {
            // Anlaşma: Bracket hesaplama (mevcut metodu kullan)
            guard let totalAmount = input.totalAgreementAmount else {
                fatalError("Agreement case requires amount components")
            }

            fee = tariff.calculateAgreementFee(
                disputeType: DisputeConstants.DisputeTypeKeys.workerEmployer,
                amount: totalAmount,
                partyCount: input.partyCount
            )

            // Breakdown oluştur
            let bracketFee = tariff.calculateBracketFee(for: totalAmount)
            let minimumFee = tariff.getMinimumFee(for: DisputeConstants.DisputeTypeKeys.workerEmployer)

            breakdown = ReinstatementBreakdown(
                nonReinstatementCompensation: input.nonReinstatementCompensation ?? 0,
                idlePeriodWage: input.idlePeriodWage ?? 0,
                otherRights: input.otherRights ?? 0,
                totalAmount: totalAmount,
                bracketFee: bracketFee,
                minimumFee: minimumFee,
                isMinimumApplied: bracketFee < minimumFee
            )
        } else {
            // Anlaşmama: Sabit ücret × 2 (mevcut metodu kullan)
            fee = tariff.calculateNonAgreementFee(
                disputeType: DisputeConstants.DisputeTypeKeys.workerEmployer,
                partyCount: input.partyCount
            )
        }

        return ReinstatementResult(
            totalFee: fee,
            agreementStatus: input.agreementStatus,
            tariffYear: input.tariffYear,
            partyCount: input.partyCount,
            breakdown: breakdown
        )
    }

    /// Validasyonlu hesaplama
    static func calculateWithValidation(
        input: ReinstatementInput
    ) -> Result<ReinstatementResult, ValidationResult> {
        let validation = input.validate()
        guard validation.isValid else {
            return .failure(validation)
        }
        return .success(calculate(input: input))
    }
}
```

### 4. Views/Screens/Reinstatement/ReinstatementSheet.swift

**Amaç:** Ana sheet ekranı

```swift
@available(iOS 26.0, *)
struct ReinstatementSheet: View {
    @StateObject private var viewModel: ReinstatementViewModel
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    init(selectedYear: TariffYear) {
        _viewModel = StateObject(wrappedValue: ReinstatementViewModel(selectedYear: selectedYear))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()

                if viewModel.showResult, let result = viewModel.calculationResult {
                    ReinstatementResultView(
                        result: result,
                        theme: theme,
                        onDismiss: { dismiss() },
                        onRecalculate: { viewModel.reset() }
                    )
                } else {
                    inputView
                }
            }
            .navigationTitle(viewModel.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ... }
        }
    }

    private var inputView: some View {
        ScrollView {
            VStack(spacing: theme.spacingL) {
                legalReferenceHeader
                agreementStatusSelector

                if viewModel.showAgreementInputs {
                    agreementInputFields
                }

                partyCountField

                if let error = viewModel.errorMessage {
                    errorMessageView(error)
                }

                calculateButton
            }
            .padding()
        }
    }
}
```

### 5. Views/Screens/Reinstatement/ReinstatementViewModel.swift

**Amaç:** Sheet için ViewModel

```swift
@available(iOS 26.0, *)
@MainActor
final class ReinstatementViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedYear: TariffYear
    @Published var agreementStatus: AgreementStatus? = nil

    // Anlaşma inputları
    @Published var compensationText: String = ""
    @Published var idleWageText: String = ""
    @Published var otherRightsText: String = ""

    // Ortak input
    @Published var partyCountText: String = ""

    // State
    @Published var showResult: Bool = false
    @Published var calculationResult: ReinstatementResult?
    @Published var errorMessage: String?
    @Published var isCalculating: Bool = false

    // MARK: - Computed Properties
    var showAgreementInputs: Bool {
        agreementStatus == .agreed
    }

    var isCalculateButtonEnabled: Bool {
        guard agreementStatus != nil else { return false }
        guard let partyCount = Int(partyCountText), partyCount >= 2 else { return false }

        if agreementStatus == .agreed {
            return !compensationText.isEmpty && !idleWageText.isEmpty
        }
        return true
    }

    var screenTitle: String {
        LocalizationKeys.Reinstatement.screenTitle.localized
    }

    // MARK: - Methods
    func calculate() { ... }
    func reset() { ... }
}
```

### 6. Views/Screens/Reinstatement/ReinstatementResultView.swift

**Amaç:** Sonuç görünümü

```swift
@available(iOS 26.0, *)
struct ReinstatementResultView: View {
    let result: ReinstatementResult
    let theme: Theme
    let onDismiss: () -> Void
    let onRecalculate: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacingXL) {
                mainFeeCard

                if let breakdown = result.breakdown {
                    breakdownCard(breakdown)
                }

                legalReferenceCard

                actionButtons
            }
            .padding()
        }
    }
}
```

---

## Güncellenecek Dosyalar

### 1. DisputeCategoryViewModel.swift

**Değişiklikler:**

```swift
// MARK: - Navigation Flags - [GÜNCELLE]
@Published var showReinstatementSheet: Bool = false  // [YENİ]

// MARK: - selectCategory Method - [GÜNCELLE]
func selectCategory(_ category: DisputeCategoryType) {
    switch category {
    // ... mevcut cases
    case .reinstatement:
        showReinstatementSheet = true  // [DEĞİŞTİR - coming soon yerine]
    case .rentSpecial:
        // Show coming soon popover
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            showComingSoonPopover = true
        }
    }
}

// MARK: - resetNavigation - [GÜNCELLE]
func resetNavigation() {
    // ... mevcut resets
    showReinstatementSheet = false  // [YENİ]
}
```

### 2. DisputeCategoryView.swift

**Değişiklikler:**

```swift
// MARK: - Body - [GÜNCELLE]
var body: some View {
    // ... mevcut kod
    .sheet(isPresented: $viewModel.showReinstatementSheet) {  // [YENİ]
        ReinstatementSheet(selectedYear: viewModel.selectedYear)
    }
}
```

### 3. LocalizationKeys.swift

**Yeni Eklenecek Keys:**

```swift
// MARK: - [YENİ] Reinstatement
struct Reinstatement {
    // Screen Titles
    static let screenTitle = "reinstatement.screen_title"
    static let resultTitle = "reinstatement.result_title"

    // Agreement Status
    static let selectAgreementStatus = "reinstatement.select_agreement_status"
    static let agreementDescription = "reinstatement.agreement_description"
    static let noAgreementDescription = "reinstatement.no_agreement_description"

    // Input Labels
    static let compensation = "reinstatement.compensation"
    static let compensationPlaceholder = "reinstatement.compensation_placeholder"
    static let compensationHint = "reinstatement.compensation_hint"

    static let idleWage = "reinstatement.idle_wage"
    static let idleWagePlaceholder = "reinstatement.idle_wage_placeholder"
    static let idleWageHint = "reinstatement.idle_wage_hint"

    static let otherRights = "reinstatement.other_rights"
    static let otherRightsPlaceholder = "reinstatement.other_rights_placeholder"
    static let otherRightsOptional = "reinstatement.other_rights_optional"

    // Result Labels
    static let totalAmount = "reinstatement.total_amount"
    static let calculatedFee = "reinstatement.calculated_fee"
    static let minimumFeeApplied = "reinstatement.minimum_fee_applied"

    // Legal References
    static let agreementLegalRef = "reinstatement.agreement_legal_ref"
    static let noAgreementLegalRef = "reinstatement.no_agreement_legal_ref"
    static let tariffSection = "reinstatement.tariff_section"
}
```

### 4. Localizable.xcstrings

**Yeni Eklenecek Çeviriler:**

| Key | Türkçe | İngilizce |
|-----|--------|-----------|
| `reinstatement.screen_title` | İşe İade Hesaplama | Reinstatement Calculation |
| `reinstatement.result_title` | Hesaplama Sonucu | Calculation Result |
| `reinstatement.select_agreement_status` | Anlaşma Durumu | Agreement Status |
| `reinstatement.agreement_description` | Taraflar anlaşma sağladı | Parties reached agreement |
| `reinstatement.no_agreement_description` | Taraflar anlaşamadı | Parties did not agree |
| `reinstatement.compensation` | İşe Başlatılmama Tazminatı | Non-Reinstatement Compensation |
| `reinstatement.compensation_placeholder` | Tazminat miktarını girin | Enter compensation amount |
| `reinstatement.compensation_hint` | İşçinin işe başlatılmaması halinde ödenecek tazminat | Compensation if worker is not reinstated |
| `reinstatement.idle_wage` | Boşta Geçen Süre Ücreti | Idle Period Wage |
| `reinstatement.idle_wage_placeholder` | Ücret miktarını girin | Enter wage amount |
| `reinstatement.idle_wage_hint` | Çalıştırılmadığı süre için ödenecek ücret | Wage for the period not worked |
| `reinstatement.other_rights` | Diğer Haklar | Other Rights |
| `reinstatement.other_rights_placeholder` | Varsa diğer hakları girin | Enter other rights if any |
| `reinstatement.other_rights_optional` | (İsteğe bağlı) | (Optional) |
| `reinstatement.total_amount` | Toplam Miktar | Total Amount |
| `reinstatement.calculated_fee` | Arabuluculuk Ücreti | Mediation Fee |
| `reinstatement.minimum_fee_applied` | Asgari ücret uygulandı | Minimum fee applied |
| `reinstatement.agreement_legal_ref` | İş Mahkemeleri Kanunu m.3/13-2 | Labor Courts Law Art. 3/13-2 |
| `reinstatement.no_agreement_legal_ref` | İş Kanunu m.20-2 | Labor Law Art. 20-2 |
| `reinstatement.tariff_section` | Tarife İkinci Kısım | Tariff Second Part |

---

## Uygulama Planı

### Aşama 1: Temel Yapı (Constants & Models)

1. [ ] `ReinstatementConstants.swift` oluştur
2. [ ] `ReinstatementResult.swift` oluştur (input + result + breakdown modelleri)
3. [ ] `ReinstatementCalculator.swift` oluştur

### Aşama 2: Lokalizasyon Güncellemeleri

4. [ ] `LocalizationKeys.swift` güncelle (Reinstatement struct ekle)
5. [ ] `Localizable.xcstrings` güncelle (TR/EN çeviriler)

### Aşama 3: View & ViewModel

6. [ ] `ReinstatementViewModel.swift` oluştur
7. [ ] `ReinstatementSheet.swift` oluştur
8. [ ] `ReinstatementResultView.swift` oluştur

### Aşama 4: Navigation Entegrasyonu

9. [ ] `DisputeCategoryViewModel.swift` güncelle (showReinstatementSheet)
10. [ ] `DisputeCategoryView.swift` güncelle (sheet modifier ekle)

### Aşama 5: Test

11. [ ] Hesaplama testleri
12. [ ] UI akış testi

---

## Hesaplama Test Senaryoları

| # | Senaryo | Yıl | Durum | Girdiler | Beklenen Sonuç |
|---|---------|-----|-------|----------|----------------|
| 1 | Anlaşma - Minimum | 2026 | Anlaşma | 50K + 30K + 0 = 80K | 9.000 TL (minimum) |
| 2 | Anlaşma - Normal | 2026 | Anlaşma | 100K + 50K + 10K = 160K | 9.600 TL |
| 3 | Anlaşma - Yüksek | 2026 | Anlaşma | 500K + 200K + 100K = 800K | 46.000 TL |
| 4 | Anlaşmama - 2 taraf | 2026 | Anlaşmama | 2 taraf | 4.520 TL |
| 5 | Anlaşmama - 5 taraf | 2026 | Anlaşmama | 5 taraf | 4.920 TL |
| 6 | Anlaşma - Minimum | 2025 | Anlaşma | 50K + 30K + 0 = 80K | 6.000 TL (minimum) |
| 7 | Anlaşma - Normal | 2025 | Anlaşma | 100K + 50K + 10K = 160K | 9.600 TL |
| 8 | Anlaşmama - 2 taraf | 2025 | Anlaşmama | 2 taraf | 3.140 TL |

---

## Dikkat Edilecek Noktalar

1. **iOS 26.0+ Requirement:** Tüm view'lar `@available(iOS 26.0, *)` ile işaretlenmeli
2. **Theme Injection:** `@Environment(\.theme) var theme` kullanılmalı
3. **Localization:** Hiçbir string hardcoded olmamalı
4. **Liquid Glass:** Mevcut UI pattern'lere (SerialDisputes) uyum sağlanmalı
5. **Validation:** Tüm inputlar valide edilmeli
6. **Mevcut Metodları Kullan:** `TariffProtocol.calculateAgreementFee()` ve `calculateNonAgreementFee()` metodları kullanılmalı, yeni formül yazılmamalı
7. **Year Selection:** StartScreen'den gelen yıl kullanılmalı

---

## Referanslar

- 7036 Sayılı İş Mahkemeleri Kanunu - Madde 3/13-2
- 4857 Sayılı İş Kanunu - Madde 20/2, Madde 21/7
- 2026 Arabuluculuk Ücret Tarifesi - İkinci Kısım
- 2025 Arabuluculuk Ücret Tarifesi - İkinci Kısım

---

**Doküman Oluşturma Tarihi:** 2 Şubat 2026
**Versiyon:** 1.0
