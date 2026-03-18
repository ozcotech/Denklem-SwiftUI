# Tüketici Uyuşmazlığı Arabuluculuk Ücreti Hesaplama - Planlama Dokümanı

## İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Yasal Dayanak](#yasal-dayanak)
3. [Yorum Farklılıkları](#yorum-farklılıkları)
4. [Hesaplama Kuralları](#hesaplama-kuralları)
5. [Kullanıcı Akışı](#kullanıcı-akışı)
6. [UI Tasarımı](#ui-tasarımı)
7. [Dosya Yapısı](#dosya-yapısı)
8. [Uygulama Adımları](#uygulama-adımları)

---

## Genel Bakış

Bu özellik, **tüketici uyuşmazlıklarında** arabuluculuk sürecinde **kimin ne kadar ödeyeceğini** hesaplar. Mevcut arabuluculuk ücreti hesaplaması toplam ücreti bulurken, bu özellik bir adım ileriye giderek:

- Toplam arabuluculuk ücretini (mevcut hesaplama ile aynı)
- Devletin karşıladığı miktarı (6502 sayılı Kanun MADDE 73/A-3)
- Tüketicinin cebinden ödeyeceği miktarı
- **İki farklı hukuki yorumu** yan yana gösterir

### Neden Ayrı Bir Özellik?

- Mevcut "Arabuluculuk Ücreti" butonu tüm uyuşmazlık türleri için **toplam arabuluculuk ücretini** hesaplıyor
- Tüketici uyuşmazlığında ek bir katman var: **6502/73A-3 gereği devlet sübvansiyonu**
- Bu sübvansiyonun yorumlanmasında uygulamada **iki farklı yaklaşım** mevcut
- Kullanıcıya her iki yorumu da göstermek, doğru kararı kendi hukuki değerlendirmesine bırakmak amacıyla tasarlanmıştır

---

## Yasal Dayanak

### A. Toplam Arabuluculuk Ücreti

**6325 sayılı Kanun MADDE 18/A fıkra 12:**
> Tarafların arabuluculuk faaliyeti sonunda anlaşmaları hâlinde, arabuluculuk ücreti, Arabuluculuk Asgari Ücret Tarifesinin eki Arabuluculuk Ücret Tarifesinin **İkinci Kısmına** göre aksi kararlaştırılmadıkça taraflarca **eşit şekilde** karşılanır. Bu durumda ücret, Tarifenin Birinci Kısmında belirlenen **iki saatlik ücret tutarından az olamaz**.

**2026 Arabuluculuk Asgari Ücret Tarifesi MADDE 7/7:**
> Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, anlaşma bedeline bakılmaksızın arabuluculuk ücreti **9.000,00 TL**'den az olamaz.

### B. Tüketici Koruma Hükmü

**6502 sayılı Tüketicinin Korunması Hakkında Kanun MADDE 73/A fıkra 3:**
> Arabuluculuk faaliyeti sonunda taraflara ulaşılamaması, taraflar katılmadığı için görüşme yapılamaması veya tarafların **anlaşmaları** ya da **anlaşamamaları** hâlinde **tüketicinin ödemesi gereken arabuluculuk ücreti, Adalet Bakanlığı bütçesinden karşılanır**. Ancak belirtilen hâllerde arabuluculuk ücreti, Arabuluculuk Asgari Ücret Tarifesinin eki Arabuluculuk Ücret Tarifesinin **Birinci Kısmına göre iki saatlik ücret tutarını geçemez**.

### C. Birinci Kısım - Tüketici Uyuşmazlıkları Saatlik Ücretler

| Taraf Durumu | 2026 Ücreti | 2025 Ücreti |
|---|---|---|
| 2 kişinin taraf olması, taraf başına (1 saat) | 1.000,00 TL | 785,00 TL |
| 3-5 kişi, taraf sayısı gözetmeksizin (1 saat) | 2.200,00 TL | 1.650,00 TL |
| 6-10 kişi, taraf sayısı gözetmeksizin (1 saat) | 2.300,00 TL | 1.750,00 TL |
| 11+ kişi, taraf sayısı gözetmeksizin (1 saat) | 2.400,00 TL | 1.850,00 TL |

---

## Yorum Farklılıkları

73/A-3'teki ifade uygulamada iki farklı şekilde yorumlanmaktadır:

### Yorum A — "Geniş Yorum" (Tüketici Lehine)

**Mantık:** Kanun "tüketicinin ödemesi gereken arabuluculuk ücreti... karşılanır" diyor. "Karşılanır" ifadesi tüketicinin **kendi payı yükümlülüğünü tamamen ortadan kaldırır**. Devlet 2 saatlik ücreti öder, kalan fark (varsa) tüketiciden talep edilemez.

**Sonuç:** Tüketici kendi payından **hiçbir şey ödemez**. Eğer tamamını ödemeyi üstlenmişse, sadece **karşı tarafın payını** öder.

**Örnek (14.000 TL anlaşma, 2 taraf, 2026):**

| Kalem | Tutar |
|---|---|
| Toplam arabuluculuk ücreti | 9.000 TL |
| Tüketicinin payı (eşit bölüşüm) | 4.500 TL |
| Satıcının payı | 4.500 TL |
| Devlet öder (tüketici adına, max 2.000 TL) | 2.000 TL |
| Tüketicinin kalan payı yükümlülüğü | **0 TL** (karşılanmış) |
| **Tüketici cebinden (sadece satıcı payı)** | **4.500 TL** |
| **Arabulucunun eline geçen toplam** | **6.500 TL** |

### Yorum B — "Dar Yorum" (Arabulucu Lehine)

**Mantık:** 73/A-3'teki "iki saatlik ücret tutarını geçemez" ifadesi, **devletin ödeme tavanını** belirler. Tüketicinin yükümlülüğünü tamamen kaldırmaz. Devlet 2.000 TL öder, tüketici kalan payından da sorumludur.

**Sonuç:** Toplam arabuluculuk ücretinden devletin ödediği miktar çıkarılır, kalan tüketiciden tahsil edilir.

**Örnek (14.000 TL anlaşma, 2 taraf, 2026):**

| Kalem | Tutar |
|---|---|
| Toplam arabuluculuk ücreti | 9.000 TL |
| Devlet öder (max 2.000 TL) | 2.000 TL |
| **Tüketici cebinden** | **7.000 TL** |
| **Arabulucunun eline geçen toplam** | **9.000 TL** |

### Devletin Ödediği Miktar Hesabı

Her iki yorumda da devletin ödediği miktar aynıdır.

**Sabit varsayım:** Her zaman **2 taraf** (1 tüketici + 1 satıcı) üzerinden hesaplanır. Tüketici tarafında birden fazla kişi olsa bile devletin ödeyeceği miktar artmaz — kanun **tüketici tarafını** korur, kişi sayısını değil.

**Formül:** Birinci Kısım, Tüketici, 2 taraf, taraf başına saatlik ücret × 2 saat

| Tarife Yılı | Saatlik Ücret (taraf başına) | Devletin Ödediği (2 saat) |
|---|---|---|
| 2026 | 1.000 TL | **2.000 TL** |
| 2025 | 785 TL | **1.570 TL** |

> Bu hesaplama `tariff.getHourlyRate(for: "consumer") × 2` ile kodda yapılabilir.

---

## Hesaplama Kuralları

### Girdi Parametreleri

| Parametre | Açıklama | Değerler |
|---|---|---|
| Tarife Yılı | 2025 veya 2026 | YearPicker ile seçim |
| Anlaşma Tutarı | Tarafların üzerinde anlaştığı miktar (TL) | Manuel giriş |
| Ücret Sorumlusu | Arabuluculuk ücretini kim ödeyecek | Tüketici / Satıcı (Karşı Taraf) / Eşit Bölüşüm |

> **Not:** Taraf sayısı girdi olarak alınmaz. Anlaşma durumunda toplam ücret sadece anlaşma tutarı üzerinden bracket (yüzde) hesabıyla bulunur — taraf sayısı sonucu etkilemez. Mevcut MediationFee hesaplama mantığı ile aynıdır. Devlet payı hesabında ise her zaman 2 taraf (1 tüketici + 1 satıcı) varsayılır; çünkü 73/A-3 tüketici tarafını korur, tüketici tarafında birden fazla kişi olsa da devletin ödeyeceği miktar artmaz (1 taraf = tüketici tarafı).

### Hesaplama Adımları

```
1. TOPLAM ARABULUCULUK ÜCRETİ HESAPLA
   → İkinci Kısım bracket hesabı (anlaşma tutarı üzerinden)
   → max(bracket sonucu, asgari ücret 9.000 TL)
   → Sonuç: toplamUcret

2. DEVLET PAYI HESAPLA
   → Birinci Kısım, tüketici, 2 taraf (sabit varsayım)
   → hourlyRate = tariff.getHourlyRate(for: "consumer")  // 2026: 1.000 TL
   → devletOder = hourlyRate × 2 saat = 2.000 TL (2026) / 1.570 TL (2025)
   → Sonuç: devletOder (sabit, her iki yorumda aynı)

3. TARAF PAYLARI HESAPLA
   → tüketiciPayi = toplamUcret / 2
   → saticiPayi = toplamUcret / 2

4. YORUM A HESAPLA (Tüketici Lehine / Geniş Yorum)
   → Tüketicinin kendi payı yükümlülüğü tamamen karşılanmış (devlet + kanun koruması)
   → if ücretSorumlusu == .consumer:
       devletPayi = devletOder
       tüketiciÖder = saticiPayi          // sadece satıcının payını üstlenir
       saticiÖder = 0
   → if ücretSorumlusu == .equal:
       devletPayi = devletOder
       tüketiciÖder = 0                   // kendi payı karşılanmış
       saticiÖder = saticiPayi
   → if ücretSorumlusu == .seller:
       devletPayi = 0                     // tüketicinin yükümlülüğü yok → devlet devreye girmez
       tüketiciÖder = 0
       saticiÖder = toplamUcret
   → arabulucuyaGeçen = devletPayi + tüketiciÖder + saticiÖder

5. YORUM B HESAPLA (Arabulucu Lehine / Dar Yorum)
   → Devlet sadece 2.000 TL öder, kalan tüketici/satıcıdan tahsil
   → if ücretSorumlusu == .consumer:
       devletPayi = devletOder
       tüketiciÖder = toplamUcret - devletOder
       saticiÖder = 0
   → if ücretSorumlusu == .equal:
       devletPayi = devletOder
       tüketiciÖder = tüketiciPayi - devletOder  // kendi payı - devlet katkısı
       saticiÖder = saticiPayi
   → if ücretSorumlusu == .seller:
       devletPayi = 0                     // tüketicinin yükümlülüğü yok → devlet devreye girmez
       tüketiciÖder = 0
       saticiÖder = toplamUcret
   → arabulucuyaGeçen = devletPayi + tüketiciÖder + saticiÖder
```

### Örnek Hesaplama Tablosu (14.000 TL, 2 taraf, 2026)

#### Tüketici Tamamını Öderse:

| | Yorum A (Geniş) | Yorum B (Dar) |
|---|---|---|
| Toplam ücret | 9.000 TL | 9.000 TL |
| Devlet öder | 2.000 TL | 2.000 TL |
| Tüketici cebinden | **4.500 TL** | **7.000 TL** |
| Satıcı öder | 0 TL | 0 TL |
| Arabulucuya geçen | 6.500 TL | 9.000 TL |

#### Eşit Bölüşüm:

| | Yorum A (Geniş) | Yorum B (Dar) |
|---|---|---|
| Toplam ücret | 9.000 TL | 9.000 TL |
| Devlet öder | 2.000 TL | 2.000 TL |
| Tüketici cebinden | **0 TL** | **2.500 TL** |
| Satıcı öder | 4.500 TL | 4.500 TL |
| Arabulucuya geçen | 6.500 TL | 9.000 TL |

#### Satıcı Tamamını Öderse:

| | Yorum A (Geniş) | Yorum B (Dar) |
|---|---|---|
| Toplam ücret | 9.000 TL | 9.000 TL |
| Devlet öder | **0 TL** | **0 TL** |
| Tüketici cebinden | **0 TL** | **0 TL** |
| Satıcı öder | **9.000 TL** | **9.000 TL** |
| Arabulucuya geçen | **9.000 TL** | **9.000 TL** |

> Satıcı tamamını öderse tüketicinin ödeme yükümlülüğü zaten yoktur. 73/A-3 devreye girmez çünkü "tüketicinin ödemesi gereken" bir ücret bulunmaz. Devlet payı = 0. Her iki yorum aynı sonucu verir.

---

## Kullanıcı Akışı

### Navigasyon

```
DisputeCategoryView
  ├── 📅 Calendar ikonu (sağ üst köşe, overlay) → TimeCalculationView
  ├── [Arabuluculuk Ücreti] → MediationFeeView (mevcut - toplam ücret)
  ├── Özel Hesaplamalar kartı (2-column grid, 3 satır = 6 buton)
  │   ├── Kira (Tahliye/Tespit)      → TenancySelectionView
  │   ├── Avukatlık Ücreti            → AttorneyFeeView
  │   ├── İşe İade                    → ReinstatementSheet
  │   ├── Seri Uyuşmazlıklar         → SerialDisputesSheet
  │   ├── SMM Hesaplama               → SMMCalculationView (değişmedi)
  │   └── Tüketici Uyuşmazlığı       → ConsumerDisputeView ← Süre'nin YERİNE
  └──
```

> **Değişiklik:** Süre Hesaplama grid'den çıkarıldı, yerine Tüketici Uyuşmazlığı girdi. Grid buton sayısı 6'da kaldı (3 satır × 2 sütun). Süre Hesaplama ekranın sağ üst köşesine calendar ikonu olarak taşındı — StartScreen'deki survey butonu pattern'ı ile:
> - `.overlay(alignment: .topTrailing)` ile yerleştirilir
> - `.buttonStyle(.glass(.clear))` + `.buttonBorderShape(.circle)`
> - Dinamik calendar ikonu (`"\(day).calendar"` — SF Symbols 7.0, iOS 26+), metin yok
> - Günün tarihini gösterir: 18 Mart → `18.calendar`, 19 Mart → `19.calendar`
> - `.navigationDestination` ile TimeCalculationView'a yönlendirir
> - Süre hesaplama küçük/basit bir hesaplama, ayrı grid butonu gerektirmez

### Ekran Akışı — Tüketici Uyuşmazlığı

```
[Tüketici Uyuşmazlığı Butonu]
        ↓
ConsumerDisputeView (.navigationDestination)
  ├── Tarife Yılı Seçimi (YearPicker)
  ├── Anlaşma Tutarı Girişi (TextField)
  ├── Ücret Sorumlusu Seçimi:
  │   ├── Menü: Tüketici / Eşit Bölüşüm / Satıcı (Karşı Taraf)
  ├── [Hesapla] butonu
        ↓
ConsumerDisputeResultSheet (.sheet)
  ├── Toplam Arabuluculuk Ücreti kartı
  ├── Hesaplama Bilgileri kartı
  ├── Sonuç 1 kartı
  │   ├── Tüketici öder: X TL
  │   ├── Satıcı öder: Y TL
  │   └── Arabulucuya geçen: Z TL
  ├── Sonuç 2 kartı
  │   ├── Tüketici öder: X TL
  │   ├── Satıcı öder: Y TL
  │   └── Arabulucuya geçen: Z TL
  └── Bracket breakdown kartı
```

### Ekran Akışı — Süre Hesaplama (Sağ Üst Köşe İkonu)

```
DisputeCategoryView ekranı:
  ┌──────────────────────────────┐
  │  Hesaplama Araçları    📅   │  ← calendar ikonu, overlay, sağ üst
  │                              │     dokunulunca → TimeCalculationView
  │  [Arabuluculuk Ücreti]       │
  │                              │
  │  Özel Hesaplamalar           │
  │  [Kira]    [Avukatlık]       │
  │  [İşe İade][Seri Uy.]       │
  │  [SMM]     [Tüketici]       │  ← Süre'nin yerine Tüketici
  └──────────────────────────────┘
```

> **Pattern:** StartScreen'deki survey butonu ile birebir aynı:
> - `.overlay(alignment: .topTrailing)` — toolbar değil (toolbar glass efekt sorunu)
> - `.buttonStyle(.glass(.clear))` + `.buttonBorderShape(.circle)`
> - İkon: Dinamik `"\(day).calendar"`, `.font(.title3)`, `.symbolRenderingMode(.hierarchical)`
> - Metin yok, sadece ikon
> - `.navigationDestination` ile TimeCalculationView'a yönlendirir
> - Mevcut TimeCalculationView ve TimeCalculationViewModel hiç değişmez

---

## UI Tasarımı

### ConsumerDisputeView — Girdi Ekranı

```
┌─────────────────────────────┐
│       Tarife Yılı           │
│    [2025]    [2026]         │  ← YearPicker
├─────────────────────────────┤
│                             │
│   Anlaşma Tutarı            │
│   ┌───────────────────┐     │
│   │ 14.000             │     │  ← CurrencyTextField
│   └───────────────────┘     │
│                             │
│   Ücretini Kim Ödeyecek?    │
│   ┌───────────────────┐     │
│   │ Tüketici        ▼ │     │  ← Menu (dropdown)
│   └───────────────────┘     │
│   Seçenekler:               │
│   • Tüketici                │
│   • Eşit Bölüşüm            │
│   • Satıcı (Karşı Taraf)    │
│                             │
│   ┌───────────────────┐     │
│   │     Hesapla        │     │  ← CalculateButton
│   └───────────────────┘     │
│                             │
│   ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─┐    │
│   │  Sonuç Kartı       │    │  ← FeeResultCard (inline özet)
│   └ ─ ─ ─ ─ ─ ─ ─ ─ ─┘    │
└─────────────────────────────┘
```

### ConsumerDisputeResultSheet — Sonuç Ekranı

MediationFeeResultSheet ile aynı yapı: NavigationStack + toolbar (paylaş/tamam), expand/collapse, staggered reveal animasyonu.

```
┌──────────────────────────────────┐
│  [↑ Paylaş]            [✓ Tamam] │  ← toolbar (topBarLeading / topBarTrailing)
│                                   │
│  ┌───────────────────────────┐   │
│  │ Toplam Arabuluculuk        │   │
│  │ Ücreti          9.000 TL   │   │  ← FeeResultCard (tap to expand/collapse)
│  └───────────────────────────┘   │
│                                   │
│  ┌───────────────────────────┐   │  ← calculationInfoCard (glass)
│  │ Hesaplama Bilgileri        │   │
│  │ ─────────────────────────  │   │
│  │ Anlaşma Tutarı:  14.000 TL│   │
│  │ Tarife Yılı:     2026     │   │
│  │ Ücret Sorumlusu: Tüketici │   │
│  │ [isimlendirme]:  2.000 TL │   │  ← devletin karşıladığı (isim beklemede)
│  └───────────────────────────┘   │
│                                   │
│  ┌───────────────────────────┐   │  ← Sonuç 1 kartı (glass)
│  │ Sonuç 1                    │   │  ← başlık (isimlendirme beklemede)
│  │ ─────────────────────────  │   │
│  │ Tüketici öder:    4.500 TL│   │
│  │ Satıcı öder:      0 TL    │   │
│  │ Arabulucuya:      6.500 TL│   │
│  └───────────────────────────┘   │
│                                   │
│  ┌───────────────────────────┐   │  ← Sonuç 2 kartı (glass)
│  │ Sonuç 2                    │   │  ← başlık (isimlendirme beklemede)
│  │ ─────────────────────────  │   │
│  │ Tüketici öder:    7.000 TL│   │
│  │ Satıcı öder:      0 TL    │   │
│  │ Arabulucuya:      9.000 TL│   │
│  └───────────────────────────┘   │
│                                   │
│  ┌───────────────────────────┐   │  ← bracket breakdown kartı (glass)
│  │ Hesaplama Yöntemi          │   │     MediationFeeResultSheet'teki
│  │ ─────────────────────────  │   │     calculationMethodCard ile aynı
│  │ İlk 600.000: ×%6 = 840 TL │   │
│  │ ─────────────────────────  │   │
│  │ Bracket Toplam:    840 TL  │   │
│  │ Asgari Ücret:    9.000 TL  │   │
│  │ ─────────────────────────  │   │
│  │ ℹ Asgari ücret uygulandı   │   │
│  └───────────────────────────┘   │
└──────────────────────────────────┘
```

**Yapısal notlar:**
- `.presentationBackground(.clear)` + `.animatedBackground()` (MediationFeeResultSheet ile aynı)
- `.presentationDetents([.large])` + `.presentationDragIndicator(.visible)`
- Tap to expand/collapse (mainFeeCard), staggered revealRow() animasyonu
- Toolbar: paylaş (topBarLeading) + tamam/dismiss (topBarTrailing)
- Paylaş butonu txt dosyası oluşturur (shareFileURL pattern)
- **İsimlendirmeler beklemede:** Sonuç 1/2 başlıkları ve "devletin karşıladığı miktar" ifadesi kullanıcının kararına bağlı

### Ücret Sorumlusu Seçimi — Menu (Dropdown)

SwiftUI `Menu` bileşeni ile 3 seçenek sunulacak:
- Tüketici
- Eşit Bölüşüm
- Satıcı (Karşı Taraf)

Glass efektli buton içinde seçili değer gösterilir, dokunulduğunda menü açılır. Mevcut uygulamadaki dispute type dropdown menüsü ile benzer pattern.

---

## Dosya Yapısı

### Yeni Dosyalar

```
Denklem/Views/Screens/ConsumerDispute/
├── ConsumerDisputeView.swift           // Girdi ekranı
├── ConsumerDisputeViewModel.swift      // İş mantığı + hesaplama
└── ConsumerDisputeResultSheet.swift    // Sonuç sheet'i
```

### Değiştirilecek Mevcut Dosyalar

```
DisputeCategoryType enum          → .consumerDispute case ekle
                                    .timeCalculation → specialCalculations'dan çıkar (enum'da kalır)
DisputeCategoryViewModel.swift    → navigateToConsumerDispute ekle
                                    specialCalculations array güncelle (timeCalculation → consumerDispute)
                                    navigateToTimeCalculation korunur (overlay buton için)
DisputeCategoryView.swift         → Calendar ikonu overlay ekle (StartScreen survey pattern)
                                    ConsumerDispute .navigationDestination ekle
LocalizationKeys.swift            → consumer_dispute.* anahtarları ekle
Localizable.xcstrings             → 3 dil çevirisi (TR, EN, SV)
```

> **Not:** SMMCalculationView, SMMCalculationViewModel, TimeCalculationView, TimeCalculationViewModel **hiç değişmez**. Süre sadece grid'den çıkıp sağ üst köşeye taşınıyor.

### Model (Yeni veya Mevcut Genişletme)

```
Models/Domain/ConsumerDisputeResult.swift   // Sonuç modeli
```

```swift
// ConsumerDisputeResult.swift
struct ConsumerDisputeResult {
    let totalFee: Double                    // Toplam arabuluculuk ücreti
    let governmentPayment: Double           // Devletin ödediği (max 2 saatlik)
    let consumerShareNormal: Double         // Tüketici payı (eşit bölüşüm)
    let sellerShareNormal: Double           // Satıcı payı (eşit bölüşüm)
    let paymentResponsibility: PaymentResponsibility  // Kim ödüyor

    // Yorum A sonuçları
    let interpretationA: InterpretationResult
    // Yorum B sonuçları
    let interpretationB: InterpretationResult

    // Hesaplama detayları (bracket breakdown vs.)
    let bracketSteps: [BracketBreakdownStep]
    let usedMinimumFee: Bool
    let minimumFee: Double
    let bracketTotal: Double
}

struct InterpretationResult {
    let consumerPays: Double        // Tüketici cebinden
    let sellerPays: Double          // Satıcı öder
    let governmentPays: Double      // Devlet öder
    let mediatorReceives: Double    // Arabulucuya geçen toplam
}

enum PaymentResponsibility: String, CaseIterable {
    case consumer   // Tüketici ödeyecek
    case equal      // Eşit bölüşüm
    case seller     // Satıcı (karşı taraf) ödeyecek
}
```

---

## Uygulama Adımları

### Adım 1: Model Katmanı
- [ ] `PaymentResponsibility` enum oluştur
- [ ] `InterpretationResult` struct oluştur
- [ ] `ConsumerDisputeResult` struct oluştur

### Adım 2: ViewModel
- [ ] `ConsumerDisputeViewModel` oluştur
  - Girdiler: tarife yılı, anlaşma tutarı, ücret sorumlusu
  - Mevcut `TariffProtocol.calculateAgreementFeeWithBreakdown()` kullanarak toplam ücreti hesapla
  - Devlet payını `tariff.getHourlyRate(for: "consumer") × 2` ile hesapla
  - Her iki yorumu ayrı ayrı hesapla
  - Validasyon (tutar > 0)

### Adım 3: Navigasyon Düzenlemesi
- [ ] `DisputeCategoryType` güncelle:
  - `.timeCalculation` grid'den çıkar (enum'da kalır ama specialCalculations'dan çıkar)
  - `.consumerDispute` ekle (ikon, renk, displayName, description)
- [ ] `DisputeCategoryViewModel` güncelle:
  - `navigateToTimeCalculation` korunur (overlay buton kullanacak)
  - `navigateToConsumerDispute` ekle (@Published var)
  - `specialCalculations` array: [rentSpecial, attorneyFee, reinstatement, serialDisputes, smmCalculation, consumerDispute]
- [ ] `DisputeCategoryView` güncelle:
  - Süre Hesaplama calendar ikonu: `.overlay(alignment: .topTrailing)` ekle
    - StartScreen survey butonu pattern'ı: `.glass(.clear)` + `.buttonBorderShape(.circle)`
    - Dinamik `"\(Calendar.current.component(.day, from: Date())).calendar"` ikonu
    - Dokunulunca `viewModel.navigateToTimeCalculation = true`
  - `.navigationDestination(isPresented: $viewModel.navigateToConsumerDispute)` ekle → ConsumerDisputeView
  - Mevcut `.navigationDestination(isPresented: $viewModel.navigateToTimeCalculation)` korunur
- [ ] Mevcut SMMCalculationView, TimeCalculationView ve ViewModel'leri **hiç değişmez**

### Adım 4: Girdi Ekranı
- [ ] `ConsumerDisputeView` oluştur
  - YearPicker
  - Anlaşma tutarı TextField
  - Ücret sorumlusu seçimi (Menu/dropdown: Tüketici / Eşit Bölüşüm / Satıcı)
  - CalculateButton
  - İnline FeeResultCard (toplam ücret özeti)

### Adım 5: Sonuç Sheet'i
- [ ] `ConsumerDisputeResultSheet` oluştur (MediationFeeResultSheet pattern)
  - Toplam ücret kartı (FeeResultCard, expand/collapse)
  - Hesaplama bilgileri kartı
  - Sonuç 1 kartı (isimlendirme beklemede)
  - Sonuç 2 kartı (isimlendirme beklemede)
  - Bracket breakdown kartı
  - Toolbar: paylaş (sol) + tamam (sağ)
  - Staggered reveal animasyonu

### Adım 6: Lokalizasyon
- [ ] `LocalizationKeys.swift`'e consumer_dispute.* anahtarları ekle
- [ ] `Localizable.xcstrings`'e TR/EN/SV çevirileri ekle

### Adım 7: Erişilebilirlik
- [ ] VoiceOver label/hint/value ekle
- [ ] Mevcut erişilebilirlik kurallarına uy (VOICEOVER_ACCESSIBILITY_PLAN.md)

### Adım 8: Test ve İnceleme
- [ ] Örnek senaryolar ile doğrulama (14.000 TL / 500.000 TL / 1.000.000 TL)
- [ ] 2025 ve 2026 tarife verileri ile test
- [ ] 3 ücret sorumlusu seçeneği ile test (tüketici / eşit / satıcı)
- [ ] Edge case: çok küçük tutarlar (asgari ücret devreye girmesi)
- [ ] Edge case: büyük tutarlar (arabulucu aleyhine fark görünmesi)

---

## Kararlar (Kesinleşmiş)

1. **Taraf sayısı alınmaz.** Anlaşma durumunda toplam ücret sadece anlaşma tutarı üzerinden yüzde (bracket) hesabıyla bulunur — taraf sayısı sonucu etkilemez. Devlet payı hesabında da her zaman 2 taraf (1 tüketici + 1 satıcı) varsayılır. Tüketici tarafında birden fazla kişi olsa bile devletin ödeyeceği miktar artmaz, kendi aralarında paylaşırlar.

2. **Satıcı tamamını öderse devlet payı devreye girmez.** 6502/73A-3 sadece tüketiciyi korur. Tüketicinin ödeme yükümlülüğü yoksa devlet de ödemez. Bu durumda her iki yorum da aynı sonucu verir: satıcı 9.000 TL, devlet 0 TL, tüketici 0 TL.

3. **NavigationDestination olarak açılır.** Sheet'ler hafif/hızlı hesaplamalar için (Reinstatement, Serial Disputes). Tüketici Uyuşmazlığı daha kapsamlı bir hesaplama — SMM, Avukatlık, Kira gibi navigationDestination ile açılır.

4. **Sadece anlaşma durumu.** Anlaşmama durumunda zaten MediationFee butonundaki hesaplama yeterli — Birinci Kısım ücreti uygulanır ve devlet tamamını karşılar. Bu özelliğe eklenmeyecek.

5. **3'lü seçim menü (dropdown) olarak.** Segmented picker yerine SwiftUI Menu bileşeni kullanılacak.

6. **Mevcut MediationFee hesaplama mantığı kullanılacak.** Toplam ücret için aynı bracket hesabı + asgari ücret kontrolü. Ek olarak devlet payı ve sonuç hesaplamaları yapılacak.

7. **Süre Hesaplama grid'den çıkar, sağ üst köşeye taşınır.** StartScreen'deki survey butonu pattern'ı ile `.overlay(alignment: .topTrailing)`, dinamik calendar ikonu (`"\(day).calendar"`), `.glass(.clear)` + `.buttonBorderShape(.circle)`. Metin yok, sadece ikon. Süre hesaplama basit bir hesaplama, ayrı grid butonu gerektirmez.

8. **Tüketici Uyuşmazlığı, Süre'nin yerine geçer.** Grid'de aynı pozisyona yerleşir. Buton sayısı 6'da kalır (3×2).

9. **İsimlendirmeler beklemede.** Sonuç 1/2 kart başlıkları ve "devletin karşıladığı miktar" ifadesi henüz kesinleşmedi — kullanıcı karar verecek.

### Arabulucu Aleyhine Durum (Not)

Özellikle Yorum A'da (tüketici lehine), büyük anlaşma tutarlarında arabulucunun eline geçen miktar toplam ücretin çok altında kalabilir. Örneğin 1.000.000 TL anlaşma:
- Toplam ücret: 60.000 TL (bracket hesabı)
- Tüketici tamamını öderse (Yorum A): satıcı payı 30.000 + devlet 2.000 = arabulucuya 32.000 TL
- Fark: 28.000 TL arabulucu alamaz

Bu durum uygulamada bilgilendirme amaçlı gösterilecek — kullanıcı hangi yorumu uygulayacağına kendisi karar verir.

---

## Uygulama Durumu

| Adım | Durum |
|---|---|
| Planlama dokümanı | Tamamlandı |
| Model katmanı | Beklemede |
| ViewModel | Beklemede |
| Navigasyon düzenlemesi (Süre → overlay, Tüketici → grid) | Beklemede |
| Girdi ekranı | Beklemede |
| Sonuç sheet'i | Beklemede |
| Lokalizasyon | Beklemede |
| Erişilebilirlik | Beklemede |
| İsimlendirme kararları | Beklemede (kullanıcıdan bekleniyor) |
| Test | Beklemede |
