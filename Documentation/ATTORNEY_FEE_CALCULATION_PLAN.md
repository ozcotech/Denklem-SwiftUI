# Avukatlık Ücreti Hesaplama Özelliği - Planlama Dokümanı

## 📋 İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Yasal Dayanak](#yasal-dayanak)
3. [Hesaplama Kuralları](#hesaplama-kuralları)
4. [Kullanıcı Akışı (User Flow)](#kullanıcı-akışı)
5. [Dosya Yapısı](#dosya-yapısı)
6. [Yeni Dosyalar](#yeni-dosyalar)
7. [Güncellenecek Dosyalar](#güncellenecek-dosyalar)
8. [Uygulama Planı](#uygulama-planı)

---

## 🎯 Genel Bakış

Bu özellik, arabuluculuk sürecinde avukatların müvekkillerinden alacakları **asgari vekalet ücretini** hesaplamak için geliştirilecektir. Hesaplama, 2026 yılı Avukatlık Asgari Ücret Tarifesi'nin 16. maddesi kapsamında yapılacaktır.

### Temel Özellikler

- **Tarife Yılı:** 2026 (şimdilik tek yıl, ileride 2025 eklenebilir)
- **Hesaplama Türleri:**
  - Parasal uyuşmazlıklar (anlaşma/anlaşmama)
  - Parasal olmayan uyuşmazlıklar (anlaşma/anlaşmama)
- **Sonuç:** Avukatlık ücreti (müvekkilden alınacak asgari ücret)

---

## ⚖️ Yasal Dayanak

### Avukatlık Asgari Ücret Tarifesi 2026 - Madde 16

**"Arabuluculuk, uzlaşma ve her türlü sulh anlaşmasında ücret"**

**Fıkra 2:** Arabuluculuğun dava şartı olması halinde, arabuluculuk aşamasında avukat aracılığı ile takip edilen işlerde aşağıdaki hükümler uygulanır:

| Bent | Durum | Hesaplama Yöntemi |
|------|-------|-------------------|
| **a** | Parasal + Anlaşma | Üçüncü kısım × 1.25 (50.000 TL altı için maktu × 1.25) |
| **b** | Parasal Olmayan + Anlaşma | Mahkemeye göre maktu ücret × 1.25 |
| **c** | Anlaşmama (tümü) | Maktu ücret: 8.000 TL |
| **ç** | Anlaşmama + Dava | Maktu ücret mahsup edilir (uygulama dışı) |

---

## 🧮 Hesaplama Kuralları

### 1. Parasal Uyuşmazlıklar (Anlaşma Var)

#### Üçüncü Kısım Hesaplama Dilimleri (2026 Yılı)

| Dilim | Üst Limit | Oran |
|-------|-----------|------|
| 1 | İlk 600.000 TL | %16 |
| 2 | Sonraki 600.000 TL | %15 |
| 3 | Sonraki 1.200.000 TL | %14 |
| 4 | Sonraki 1.200.000 TL | %13 |
| 5 | Sonraki 1.800.000 TL | %11 |
| 6 | Sonraki 2.400.000 TL | %8 |
| 7 | Sonraki 3.000.000 TL | %5 |
| 8 | Sonraki 3.600.000 TL | %3 |
| 9 | Sonraki 4.200.000 TL | %2 |
| 10 | 18.600.000 TL üzeri | %1 |

#### Hesaplama Formülü

```
1. Üçüncü kısma göre ücret hesapla
2. Ücretin 1/4 fazlasını ekle (× 1.25)
3. Eğer sonuç < 10.000 TL (50.000 TL altı işlemler): 8.000 × 1.25 = 10.000 TL
4. Eğer sonuç > anlaşma miktarı: sonuç = anlaşma miktarı
```

#### Özel Kurallar

- **50.000 TL'ye kadar anlaşmalar:** Sabit 10.000 TL (8.000 × 1.25)
- **Üst limit:** Avukatlık ücreti, anlaşma miktarını geçemez

### 2. Parasal Uyuşmazlıklar (Anlaşma Yok)

```
Sabit Ücret: 8.000 TL
Uyarı: "Bu ücret asıl alacağı geçemez"
```

### 3. Parasal Olmayan Uyuşmazlıklar (Anlaşma Var)

#### Mahkeme Türüne Göre Ücretler (2026 Yılı)

| Mahkeme Türü | Maktu Ücret | 1/4 Fazlası |
|--------------|-------------|-------------|
| Sulh Hukuk Mahkemesi | 30.000 TL | **37.500 TL** |
| Asliye Mahkemeleri | 45.000 TL | **56.250 TL** |
| Tüketici Mahkemesi | 22.500 TL | **28.125 TL** |
| Fikri ve Sınai Haklar Mahkemesi | 55.000 TL | **68.750 TL** |

#### Mahkeme Eşleştirmeleri (Uyuşmazlık Türüne Göre Öneri)

| Uyuşmazlık Türü | Önerilen Mahkeme |
|-----------------|------------------|
| Ticari | Asliye Ticaret → Asliye |
| Ortaklığın Giderilmesi | Sulh Hukuk |
| Kira | Sulh Hukuk |
| Tüketici | Tüketici Mahkemesi |
| Fikri Haklar | Fikri ve Sınai Haklar |
| Aile | Aile Mahkemesi → Asliye |
| Diğer | Asliye |

### 4. Parasal Olmayan Uyuşmazlıklar (Anlaşma Yok)

```
Sabit Ücret: 8.000 TL
Uyarı: "Bu ücret asıl alacağı geçemez"
```

---

## 🔄 Kullanıcı Akışı (User Flow)

```
DisputeCategoryView (Mevcut Ekran)
    ├── Parasal
    ├── Parasal Olmayan
    ├── Süre Hesaplama
    ├── SMM Hesaplama
    └── [YENİ] Özel Hesaplamalar Bölümü
            ├── [YENİ] Kira (Tahliye + Tespit) - Gelecek özellik
            └── [YENİ] Avukatlık Ücreti ──────────────────────────┐
                                                                   ▼
                    ┌──────────────────────────────────────────────┐
                    │     AttorneyFeeTypeView (YENİ EKRAN)        │
                    │  "Uyuşmazlık parasal mı, değil mi?"          │
                    │                                              │
                    │  ┌─────────────┐    ┌──────────────────┐    │
                    │  │   Parasal   │    │ Parasal Olmayan  │    │
                    │  └──────┬──────┘    └────────┬─────────┘    │
                    └─────────┼────────────────────┼───────────────┘
                              │                    │
                              ▼                    ▼
                    ┌──────────────────────────────────────────────┐
                    │  AttorneyFeeAgreementView (YENİ EKRAN)      │
                    │  "Anlaşma durumu nedir?"                     │
                    │                                              │
                    │  ┌─────────────┐    ┌──────────────────┐    │
                    │  │   Anlaşma   │    │    Anlaşmama     │    │
                    │  └──────┬──────┘    └────────┬─────────┘    │
                    └─────────┼────────────────────┼───────────────┘
                              │                    │
              ┌───────────────┴───────┐            │
              │                       │            │
              ▼                       ▼            ▼
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │ PARASAL ANLAŞMA │    │ PARASAL OLMAYAN │    │    ANLAŞMAMA    │
    │     GİRİŞ       │    │     ANLAŞMA     │    │    (Sabit)      │
    │                 │    │                 │    │                 │
    │ Anlaşma Miktarı │    │ Mahkeme Seçimi  │    │ Sonuç: 8.000 TL │
    │ [___________]   │    │ ○ Sulh Hukuk    │    │                 │
    │                 │    │ ○ Asliye        │    │ ⚠️ Uyarı:       │
    │ [Hesapla]       │    │ ○ Tüketici      │    │ "Bu ücret asıl  │
    └────────┬────────┘    │ ○ Fikri Sınai   │    │ alacağı geçemez"│
             │             │                 │    └─────────────────┘
             │             │ [Hesapla]       │
             │             └────────┬────────┘
             │                      │
             └──────────┬───────────┘
                        ▼
            ┌─────────────────────────────┐
            │   AttorneyFeeResultSheet   │
            │       (SONUÇ SHEET)         │
            │                             │
            │  Avukatlık Ücreti           │
            │  ═══════════════════        │
            │  ₺20.000,00                 │
            │                             │
            │  ────────────────────       │
            │  Detaylar:                  │
            │  • Anlaşma Miktarı: ...     │
            │  • Hesaplama Yöntemi: ...   │
            │                             │
            │  ⚠️ Bu ücret asıl alacağı   │
            │     geçemez (uyarı)         │
            │                             │
            │  [Kapat] [Paylaş]           │
            └─────────────────────────────┘
```

---

## 📁 Dosya Yapısı

### Yeni Klasör Yapısı

```
Denklem/
├── Constants/
│   └── AttorneyFeeConstants.swift     [YENİ]
│
├── Localization/
│   ├── LocalizationKeys.swift         [GÜNCELLE]
│   └── Localizable.xcstrings          [GÜNCELLE]
│
├── Models/
│   ├── Calculation/
│   │   └── AttorneyFeeCalculator.swift [YENİ]
│   ├── Data/
│   │   └── AttorneyFeeTariff2026.swift [YENİ]
│   └── Domain/
│       └── AttorneyFeeResult.swift     [YENİ]
│
└── Views/
    └── Screens/
        ├── DisputeCategory/
        │   ├── DisputeCategoryView.swift     [GÜNCELLE]
        │   └── DisputeCategoryViewModel.swift [GÜNCELLE]
        │
        └── AttorneyFee/                       [YENİ KLASÖR]
            ├── AttorneyFeeTypeView.swift      [YENİ]
            ├── AttorneyFeeTypeViewModel.swift [YENİ]
            ├── AttorneyFeeAgreementView.swift [YENİ]
            ├── AttorneyFeeAgreementViewModel.swift [YENİ]
            ├── AttorneyFeeInputView.swift     [YENİ]
            ├── AttorneyFeeInputViewModel.swift [YENİ]
            └── AttorneyFeeResultSheet.swift   [YENİ]
```

---

## 📄 Yeni Dosyalar

### 1. Constants/AttorneyFeeConstants.swift

**Amaç:** Avukatlık ücreti hesaplama sabitleri

```swift
struct AttorneyFeeConstants {
    
    // MARK: - Tariff Year
    static let supportedYear = 2026
    
    // MARK: - Fixed Fees (Maktu Ücretler)
    struct FixedFees2026 {
        /// Anlaşmama durumunda sabit ücret (Madde 16/2-c)
        static let noAgreementFee: Double = 8_000.0
        
        /// 50.000 TL altı anlaşmalar için sabit ücret hesabı
        static let monetaryMinimumThreshold: Double = 50_000.0
        static let monetaryMinimumFee: Double = 10_000.0 // 8.000 × 1.25
    }
    
    // MARK: - Court Types (Mahkeme Türleri)
    struct CourtFees2026 {
        /// Sulh Hukuk Mahkemesi maktu ücreti
        static let civilPeaceCourt: Double = 30_000.0
        static let civilPeaceCourtWithBonus: Double = 37_500.0
        
        /// Asliye Mahkemeleri maktu ücreti  
        static let firstInstanceCourt: Double = 45_000.0
        static let firstInstanceCourtWithBonus: Double = 56_250.0
        
        /// Tüketici Mahkemesi maktu ücreti
        static let consumerCourt: Double = 22_500.0
        static let consumerCourtWithBonus: Double = 28_125.0
        
        /// Fikri ve Sınai Haklar Mahkemesi maktu ücreti
        static let intellectualPropertyCourt: Double = 55_000.0
        static let intellectualPropertyCourtWithBonus: Double = 68_750.0
    }
    
    // MARK: - Third Part Brackets (Üçüncü Kısım Dilimleri)
    struct ThirdPartBrackets2026 {
        static let brackets: [(limit: Double, rate: Double, cumulativeLimit: Double)] = [
            (600_000.0, 0.16, 600_000.0),
            (600_000.0, 0.15, 1_200_000.0),
            (1_200_000.0, 0.14, 2_400_000.0),
            (1_200_000.0, 0.13, 3_600_000.0),
            (1_800_000.0, 0.11, 5_400_000.0),
            (2_400_000.0, 0.08, 7_800_000.0),
            (3_000_000.0, 0.05, 10_800_000.0),
            (3_600_000.0, 0.03, 14_400_000.0),
            (4_200_000.0, 0.02, 18_600_000.0),
            (Double.infinity, 0.01, Double.infinity)
        ]
    }
    
    // MARK: - Bonus Multiplier
    /// 1/4 fazlası çarpanı (Madde 16/2-a,b)
    static let bonusMultiplier: Double = 1.25
}

// MARK: - Court Type Enum
enum CourtType: String, CaseIterable, Identifiable {
    case civilPeace = "civil_peace"           // Sulh Hukuk
    case firstInstance = "first_instance"     // Asliye Hukuk
    case consumer = "consumer"                // Tüketici
    case intellectualProperty = "intellectual_property" // Fikri Sınai
    
    var id: String { rawValue }
    
    var displayName: String { ... }
    var baseFee: Double { ... }
    var feeWithBonus: Double { ... }
}
```

### 2. Models/Calculation/AttorneyFeeCalculator.swift

**Amaç:** Hesaplama motoru

```swift
struct AttorneyFeeCalculator {
    
    // MARK: - Main Calculation Method
    
    /// Avukatlık ücreti hesapla
    static func calculate(input: AttorneyFeeInput) -> AttorneyFeeResult
    
    // MARK: - Private Methods
    
    /// Üçüncü kısma göre ücret hesapla (dilimli hesaplama)
    private static func calculateThirdPartFee(amount: Double) -> Double
    
    /// 1/4 fazlasını ekle
    private static func applyBonus(_ amount: Double) -> Double
    
    /// Mahkeme türüne göre maktu ücret getir
    private static func getCourtFee(courtType: CourtType) -> Double
}
```

### 3. Models/Domain/AttorneyFeeResult.swift

**Amaç:** Hesaplama sonuç modeli

```swift
struct AttorneyFeeInput {
    let isMonetary: Bool
    let hasAgreement: Bool
    let agreementAmount: Double?
    let courtType: CourtType?
}

struct AttorneyFeeResult {
    let fee: Double
    let calculationType: AttorneyFeeCalculationType
    let breakdown: AttorneyFeeBreakdown
    let warnings: [String]
    
    var formattedFee: String { ... }
}

struct AttorneyFeeBreakdown {
    let baseAmount: Double?
    let thirdPartFee: Double?
    let bonusAmount: Double?
    let courtType: CourtType?
    let isMinimumApplied: Bool
    let isMaximumApplied: Bool
}

enum AttorneyFeeCalculationType: String {
    case monetaryAgreement = "monetary_agreement"
    case monetaryNoAgreement = "monetary_no_agreement"
    case nonMonetaryAgreement = "non_monetary_agreement"
    case nonMonetaryNoAgreement = "non_monetary_no_agreement"
}
```

### 4. Models/Data/AttorneyFeeTariff2026.swift

**Amaç:** 2026 tarife verileri (ileride 2025 eklenebilir)

```swift
struct AttorneyFeeTariff2026 {
    // Constants'tan veri çeker, factory pattern uygular
    static func getThirdPartBrackets() -> [(limit: Double, rate: Double)]
    static func getCourtFees() -> [CourtType: Double]
    static func getNoAgreementFee() -> Double
}
```

### 5-11. Views/Screens/AttorneyFee/ Klasörü

| Dosya | Amaç |
|-------|------|
| `AttorneyFeeTypeView.swift` | Parasal/Parasal Olmayan seçim ekranı |
| `AttorneyFeeTypeViewModel.swift` | Type view için ViewModel |
| `AttorneyFeeAgreementView.swift` | Anlaşma/Anlaşmama seçim ekranı |
| `AttorneyFeeAgreementViewModel.swift` | Agreement view için ViewModel |
| `AttorneyFeeInputView.swift` | Miktar veya mahkeme girişi ekranı |
| `AttorneyFeeInputViewModel.swift` | Input view için ViewModel |
| `AttorneyFeeResultSheet.swift` | Sonuç sheet komponenti |

---

## 📝 Güncellenecek Dosyalar

### 1. DisputeCategoryView.swift

**Değişiklikler:**

```swift
// MARK: - Body
var body: some View {
    ScrollView {
        VStack(spacing: theme.spacingXL) {
            mainCategoriesGrid        // Mevcut
            otherCalculationsGrid     // Mevcut
            specialCalculationsGrid   // [YENİ] Özel Hesaplamalar
        }
    }
    .navigationDestination(isPresented: $viewModel.navigateToAttorneyFee) { // [YENİ]
        AttorneyFeeTypeView()
    }
}

// MARK: - [YENİ] Special Calculations Grid
private var specialCalculationsGrid: some View {
    VStack(spacing: theme.spacingM) {
        // Section Title
        Text(viewModel.specialCalculationsTitle)
            .font(theme.title3)
            .fontWeight(.semibold)
        
        // Grid with 2 buttons
        LazyVGrid(...) {
            ForEach(viewModel.specialCalculations) { ... }
        }
    }
}
```

### 2. DisputeCategoryViewModel.swift

**Değişiklikler:**

```swift
// MARK: - Dispute Category Enum - [GÜNCELLE]
enum DisputeCategoryType: String, CaseIterable, Identifiable {
    case monetary
    case nonMonetary
    case timeCalculation
    case smmCalculation
    case rentSpecial          // [YENİ] - Gelecek özellik
    case attorneyFee          // [YENİ]
    
    var displayName: String { ... }
    var description: String { ... }
    var systemImage: String { 
        case .attorneyFee: return "person.badge.shield.checkmark.fill"
    }
    var iconColor: Color {
        case .attorneyFee: return .indigo
    }
}

// MARK: - ViewModel - [GÜNCELLE]
class DisputeCategoryViewModel {
    
    // [YENİ] Navigation flag
    @Published var navigateToAttorneyFee: Bool = false
    
    // [YENİ] Special calculations section
    var specialCalculations: [DisputeCategoryType] {
        return [.attorneyFee] // .rentSpecial ileride eklenecek
    }
    
    var specialCalculationsTitle: String {
        return LocalizationKeys.DisputeCategory.specialCalculations.localized
    }
    
    // [GÜNCELLE] selectCategory method
    func selectCategory(_ category: DisputeCategoryType) {
        switch category {
        // ... mevcut cases
        case .attorneyFee:
            navigateToAttorneyFee = true
        case .rentSpecial:
            // Gelecek özellik - şimdilik boş
            break
        }
    }
}
```

### 3. LocalizationKeys.swift

**Yeni Eklenecek Keys:**

```swift
// MARK: - Dispute Categories [GÜNCELLE]
struct DisputeCategory {
    // ... mevcut keys
    
    // Special Calculations Section
    static let specialCalculations = "dispute_category.special_calculations"
    static let rentSpecial = "dispute_category.rent_special"
    static let rentSpecialDescription = "dispute_category.rent_special.description"
    static let attorneyFee = "dispute_category.attorney_fee"
    static let attorneyFeeDescription = "dispute_category.attorney_fee.description"
}

// MARK: - [YENİ] Attorney Fee
struct AttorneyFee {
    // Screen Titles
    static let typeScreenTitle = "attorney_fee.type_screen_title"
    static let agreementScreenTitle = "attorney_fee.agreement_screen_title"
    static let inputScreenTitle = "attorney_fee.input_screen_title"
    static let resultTitle = "attorney_fee.result_title"
    
    // Type Selection
    static let monetaryType = "attorney_fee.monetary_type"
    static let monetaryTypeDescription = "attorney_fee.monetary_type.description"
    static let nonMonetaryType = "attorney_fee.non_monetary_type"
    static let nonMonetaryTypeDescription = "attorney_fee.non_monetary_type.description"
    
    // Agreement Status
    static let agreed = "attorney_fee.agreed"
    static let agreedDescription = "attorney_fee.agreed.description"
    static let notAgreed = "attorney_fee.not_agreed"
    static let notAgreedDescription = "attorney_fee.not_agreed.description"
    
    // Input Labels
    static let agreementAmount = "attorney_fee.agreement_amount"
    static let agreementAmountHint = "attorney_fee.agreement_amount_hint"
    static let selectCourt = "attorney_fee.select_court"
    static let selectCourtHint = "attorney_fee.select_court_hint"
    
    // Court Types
    static let civilPeaceCourt = "attorney_fee.civil_peace_court"
    static let firstInstanceCourt = "attorney_fee.first_instance_court"
    static let consumerCourt = "attorney_fee.consumer_court"
    static let intellectualPropertyCourt = "attorney_fee.intellectual_property_court"
    
    // Result Labels
    static let calculatedFee = "attorney_fee.calculated_fee"
    static let calculationMethod = "attorney_fee.calculation_method"
    static let baseAmount = "attorney_fee.base_amount"
    static let thirdPartFee = "attorney_fee.third_part_fee"
    static let bonusAmount = "attorney_fee.bonus_amount"
    static let courtFee = "attorney_fee.court_fee"
    
    // Warnings
    static let feeExceedsAmountWarning = "attorney_fee.fee_exceeds_amount_warning"
    static let minimumFeeApplied = "attorney_fee.minimum_fee_applied"
    static let fixedFeeInfo = "attorney_fee.fixed_fee_info"
    
    // Legal Reference
    static let legalReference = "attorney_fee.legal_reference"
    static let tariffYear = "attorney_fee.tariff_year"
}
```

### 4. Localizable.xcstrings

**Yeni Eklenecek Çeviriler:**

| Key | Türkçe | İngilizce |
|-----|--------|-----------|
| `dispute_category.special_calculations` | Özel Hesaplamalar | Special Calculations |
| `dispute_category.attorney_fee` | Avukatlık Ücreti | Attorney Fee |
| `dispute_category.attorney_fee.description` | Arabuluculukta vekalet ücreti hesapla | Calculate attorney fee in mediation |
| `attorney_fee.type_screen_title` | Uyuşmazlık Türü | Dispute Type |
| `attorney_fee.agreement_screen_title` | Anlaşma Durumu | Agreement Status |
| `attorney_fee.input_screen_title` | Bilgi Girişi | Input Details |
| `attorney_fee.result_title` | Avukatlık Ücreti | Attorney Fee |
| `attorney_fee.monetary_type` | Parasal Uyuşmazlık | Monetary Dispute |
| `attorney_fee.non_monetary_type` | Parasal Olmayan | Non-Monetary |
| `attorney_fee.agreed` | Anlaşma | Agreement |
| `attorney_fee.not_agreed` | Anlaşmama | No Agreement |
| `attorney_fee.agreement_amount` | Anlaşma Miktarı | Agreement Amount |
| `attorney_fee.select_court` | Mahkeme Seçin | Select Court |
| `attorney_fee.civil_peace_court` | Sulh Hukuk Mahkemesi | Civil Peace Court |
| `attorney_fee.first_instance_court` | Asliye Mahkemeleri | First Instance Courts |
| `attorney_fee.consumer_court` | Tüketici Mahkemesi | Consumer Court |
| `attorney_fee.intellectual_property_court` | Fikri ve Sınai Haklar Mahkemesi | Intellectual Property Court |
| `attorney_fee.calculated_fee` | Hesaplanan Ücret | Calculated Fee |
| `attorney_fee.fee_exceeds_amount_warning` | Bu ücret asıl alacağı geçemez | This fee cannot exceed the principal claim |
| `attorney_fee.minimum_fee_applied` | Asgari ücret uygulandı | Minimum fee applied |
| `attorney_fee.legal_reference` | 2026 Avukatlık Asgari Ücret Tarifesi Madde 16 | 2026 Attorney Minimum Fee Tariff Article 16 |

---

## 📋 Uygulama Planı

### Aşama 1: Temel Yapı (Constants & Models)

1. ✅ `AttorneyFeeConstants.swift` oluştur
2. ✅ `AttorneyFeeTariff2026.swift` oluştur
3. ✅ `AttorneyFeeResult.swift` oluştur (input, result, breakdown modelleri)
4. ✅ `AttorneyFeeCalculator.swift` oluştur

### Aşama 2: Lokalizasyon Güncellemeleri

5. ✅ `LocalizationKeys.swift` güncelle (yeni keys ekle)
6. ✅ `Localizable.xcstrings` güncelle (TR/EN çeviriler)

### Aşama 3: DisputeCategory Güncellemeleri

7. ✅ `DisputeCategoryViewModel.swift` güncelle (enum, navigation, selectCategory)
8. ✅ `DisputeCategoryView.swift` güncelle (specialCalculationsGrid, navigationDestination)

### Aşama 4: Yeni Ekranlar - Type Selection

9. ✅ `AttorneyFeeTypeView.swift` oluştur
10. ✅ `AttorneyFeeTypeViewModel.swift` oluştur

### Aşama 5: Yeni Ekranlar - Agreement Selection

11. ✅ `AttorneyFeeAgreementView.swift` oluştur
12. ✅ `AttorneyFeeAgreementViewModel.swift` oluştur

### Aşama 6: Yeni Ekranlar - Input & Result

13. ✅ `AttorneyFeeInputView.swift` oluştur
14. ✅ `AttorneyFeeInputViewModel.swift` oluştur
15. ✅ `AttorneyFeeResultSheet.swift` oluştur

### Aşama 7: Test & Validasyon

16. ✅ Unit testler yaz (Calculator testleri)
17. ✅ UI testleri (flow testi)
18. ✅ Edge case'leri kontrol et

---

## 🔢 Hesaplama Örnekleri (Test Senaryoları)

### Örnek 1: Parasal + Anlaşma (100.000 TL)

```
Anlaşma Miktarı: 100.000 TL
Üçüncü Kısım: 100.000 × 0.16 = 16.000 TL
1/4 Fazlası: 16.000 × 1.25 = 20.000 TL
Sonuç: 20.000 TL
```

### Örnek 2: Parasal + Anlaşma (30.000 TL - Alt Limit)

```
Anlaşma Miktarı: 30.000 TL (< 50.000 TL)
Sabit Ücret: 8.000 × 1.25 = 10.000 TL
Sonuç: 10.000 TL
```

### Örnek 3: Parasal + Anlaşma (5.000 TL - Limit Aşımı)

```
Anlaşma Miktarı: 5.000 TL (< 50.000 TL)
Hesaplanan: 10.000 TL
Limit Kontrolü: 10.000 > 5.000 → Limit aşıldı
Sonuç: 5.000 TL (anlaşma miktarı)
Uyarı: "Bu ücret asıl alacağı geçemez"
```

### Örnek 4: Parasal + Anlaşmama

```
Sabit Ücret: 8.000 TL
Uyarı: "Bu ücret asıl alacağı geçemez"
```

### Örnek 5: Parasal Olmayan + Anlaşma (Sulh Hukuk)

```
Mahkeme: Sulh Hukuk Mahkemesi
Maktu Ücret: 30.000 TL
1/4 Fazlası: 30.000 × 1.25 = 37.500 TL
Sonuç: 37.500 TL
```

### Örnek 6: Parasal Olmayan + Anlaşmama

```
Sabit Ücret: 8.000 TL
Uyarı: "Bu ücret asıl alacağı geçemez"
```

### Örnek 7: Yüksek Miktar (2.000.000 TL)

```
Anlaşma Miktarı: 2.000.000 TL
Üçüncü Kısım Hesaplaması:
  - İlk 600.000: 600.000 × 0.16 = 96.000 TL
  - Sonraki 600.000: 600.000 × 0.15 = 90.000 TL
  - Sonraki 800.000: 800.000 × 0.14 = 112.000 TL
  - Toplam: 298.000 TL
1/4 Fazlası: 298.000 × 1.25 = 372.500 TL
Sonuç: 372.500 TL
```

---

## ⚠️ Dikkat Edilecek Noktalar

1. **iOS 26.0+ Requirement:** Tüm view'lar `@available(iOS 26.0, *)` ile işaretlenmeli
2. **Theme Injection:** `@Environment(\.theme) var theme` kullanılmalı
3. **Localization:** Hiçbir string hardcoded olmamalı
4. **Liquid Glass:** Mevcut UI pattern'lere uyum sağlanmalı
5. **Validation:** Tüm inputlar valide edilmeli
6. **Edge Cases:** Limit kontrolleri mutlaka yapılmalı
7. **Uyarılar:** "Bu ücret asıl alacağı geçemez" uyarısı uygun yerlerde gösterilmeli

---

## 📚 Referanslar

- Avukatlık Asgari Ücret Tarifesi 2026 (4 Kasım 2025 tarihli Resmi Gazete)
- Madde 16 - Arabuluculuk, uzlaşma ve her türlü sulh anlaşmasında ücret
- Üçüncü Kısım - Dava ve İşler İçin Öngörülen Oranlar

---

**Doküman Oluşturma Tarihi:** 8 Ocak 2026  
**Son Güncelleme:** 8 Ocak 2026  
**Versiyon:** 1.0
