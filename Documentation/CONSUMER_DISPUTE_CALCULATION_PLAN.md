# Tüketici Uyuşmazlığı Arabuluculuk Ücreti Hesaplama - Planlama Dokümanı

> **Durum: Tüm aşamalar tamamlandı, cihazda test edildi, PDF bundle'a eklendi.** Bu doküman özelliğin tasarımını ve nihai uygulamayı yansıtır. Uygulama sırasında bazı kararlar değişti — değişiklikler ilgili bölümlerde belirtilmiştir.

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
  ├── [Arabuluculuk Ücreti] → MediationFeeView (mevcut - toplam ücret)
  ├── Özel Hesaplamalar kartı
  │   ├── Grid (2-column, 3 satır = 6 buton):
  │   │   ├── Kira (Tahliye/Tespit)        → TenancySelectionView
  │   │   ├── Avukatlık Ücreti             → AttorneyFeeView
  │   │   ├── İşe İade                     → ReinstatementSheet
  │   │   ├── Seri Uyuşmazlıklar          → SerialDisputesSheet
  │   │   ├── Tüketici Uyuşmazlığı        → ConsumerDisputeView  ← üst SMM slot'unun yerine
  │   │   └── Özel Hesaplama (placeholder) → "Yakında" alert       ← üst Süre slot'unun yerine
  │   └── Shortcut row (HStack, 2 buton — grid altında):
  │       ├── SMM Hesaplama                → SMMCalculationView (değişmedi)
  │       └── Süre Hesaplama               → TimeCalculationSheet (dinamik takvim ikonu)
  └──
```

> **Uygulama notu (değişiklik):** Plandaki "Süre Hesaplama overlay calendar ikonu" yaklaşımı uygulanmadı. Yerine:
> - Süre Hesaplama, grid altındaki **shortcut row**'da kaldı (dinamik takvim ikonuyla — bugünün gününü gösteren `"\(day).calendar"`).
> - Üst Time slot'u **Özel Hesaplama** placeholder'ı oldu (`star.circle` ikon, dokunulunca "Yakında" alert) — yeni bir özel hesaplama özelliği için yer ayrılmış durumda.
> - Üst SMM slot'u **Tüketici Uyuşmazlığı** oldu (planın orijinal niyeti).
> - Alt SMM Hesaplama shortcut'u olduğu gibi kaldı.
> - Bu sayede DisputeSectionCard'a yeni bir `shortcutCategories` parametresi eklendi; grid ve shortcut artık bağımsız.

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

### Ekran Layout — Final

```
DisputeCategoryView ekranı:
  ┌──────────────────────────────────────┐
  │  Hesaplama Araçları                  │
  │                                      │
  │  [Arabuluculuk Ücreti]               │  ← full-width
  │                                      │
  │  Özel Hesaplamalar (başlık yok)      │
  │  [Kira]            [Avukatlık]       │  ← grid
  │  [İşe İade]        [Seri Uy.]       │
  │  [Tüketici Uyşmz.] [Özel Hesap.]    │
  │  [SMM Hesaplama]   [Süre Hesaplama]  │  ← shortcut row
  └──────────────────────────────────────┘
```

> **Pattern notu:** Süre Hesaplama, grid altındaki shortcut row'da bağımsız bir `RectangleButton` olarak kaldı. Mevcut `TimeCalculationView` ve `TimeCalculationViewModel` hiç değişmedi. Dinamik takvim ikonu (`capsuleSystemImage` üzerinden) sadece shortcut'taki Süre butonu için kullanılıyor.

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
┌──────────────────────────────────────────────┐
│  [↑ Paylaş]                       [✓ Tamam] │  ← toolbar
│                                              │
│  ┌────────────────────────────────────┐     │  ← FeeResultCard
│  │ Arabuluculuk Ücreti                │     │     (tap to expand/collapse)
│  │              9.000 TL              │     │
│  └────────────────────────────────────┘     │
│                                              │
│  ┌────────────────────────────────────┐     │  ← Hesaplama Bilgileri
│  │ Hesaplama Bilgileri                │     │
│  │ ────────────────────────────────── │     │
│  │ Tarife Yılı:           2026        │     │
│  │ Anlaşma Tutarı:        14.000 TL   │     │
│  │ Ücreti kim öder?:      Tüketici    │     │
│  │ Bakanlık katkısı:      2.000 TL    │     │
│  └────────────────────────────────────┘     │
│                                              │
│  ┌────────────────────────────────────┐     │  ← Tam Ücret Sonucu (Yorum B — dar)
│  │ Tam Ücret Sonucu                   │     │     mediator gets FULL fee
│  │ ────────────────────────────────── │     │
│  │ Tüketici:                7.000 TL  │     │
│  │ Satıcı (Karşı Taraf):    0 TL      │     │
│  │ T.C. Adalet Bakanlığı:   2.000 TL  │     │
│  │ Arabuluculuk Ücreti (Tam): 9.000 TL│     │  ← highlighted
│  └────────────────────────────────────┘     │
│                                              │
│  ┌────────────────────────────────────┐     │  ← Kısmi Ücret Sonucu (Yorum A — geniş)
│  │ Kısmi Ücret Sonucu                 │     │     mediator gets PARTIAL fee
│  │ ────────────────────────────────── │     │
│  │ Tüketici:                4.500 TL  │     │
│  │ Satıcı (Karşı Taraf):    0 TL      │     │
│  │ T.C. Adalet Bakanlığı:   2.000 TL  │     │
│  │ Arabuluculuk Ücreti (Kısmi):       │     │
│  │                          6.500 TL  │     │  ← highlighted
│  └────────────────────────────────────┘     │
│                                              │
│  ┌────────────────────────────────────┐     │  ← Bilgilendirme + PDF link
│  │ ℹ Sonuç kısmı arabulucunun         │     │
│  │   takdirindedir.                   │     │
│  │ Ayrıntılar için tıklayınız ↗       │     │  ← .isLink trait, açar:
│  └────────────────────────────────────┘     │     ConsumerDisputeOpinionSheet
│                                              │
│  ┌────────────────────────────────────┐     │  ← Bracket breakdown (varsa)
│  │ Hesaplama Yöntemi                  │     │
│  │ ────────────────────────────────── │     │
│  │ İlk 600.000: ×%6 = 840 TL          │     │
│  │ ────────────────────────────────── │     │
│  │ Bracket Toplam:   840 TL           │     │
│  │ Asgari Ücret:     9.000 TL         │     │
│  │ ────────────────────────────────── │     │
│  │ ℹ Asgari ücret uygulandı           │     │
│  └────────────────────────────────────┘     │
└──────────────────────────────────────────────┘
```

**Yapısal notlar:**
- `.presentationBackground(.clear)` + `.animatedBackground()` (MediationFeeResultSheet ile aynı)
- `.presentationDetents([.large])` + `.presentationDragIndicator(.visible)`
- Tap to expand/collapse (mainFeeCard), staggered revealRow() animasyonu (her satır 50ms gecikme)
- Toolbar: paylaş (topBarLeading) + tamam/dismiss (topBarTrailing)
- Paylaş butonu TXT dosyası oluşturur (shareFileURL pattern, ConsumerDispute özelinde)
- Disclaimer link `ConsumerDisputeOpinionSheet`'i açar — PDFKit ile bundled PDF görüntülenir, PDF yoksa fallback mesajı

**İsimlendirme kararları (final):**
- **"Tam Ücret Sonucu"** = mediator tam ücret alır. Tüketici-öder senaryosunda üstte (dar yorum, Bakanlık 2024 görüş yazısının desteklediği yorum); Satıcı-öder senaryosunda tek kart olarak (her iki yorum da burada aynı sonucu verir).
- **"Kısmi Ücret Sonucu"** = mediator kısmi ücret alır. Tüketici-öder senaryosunda altta (geniş yorum); Eşit Bölüşüm senaryosunda tek kart olarak.
- Kart başlığı, **payer seçimine değil arabulucunun tahsil senaryosuna** göre adlandırılır — alttaki "Arabuluculuk Ücreti (Tam)/(Kısmi)" satır etiketiyle birebir tutarlı.
- Devlet katkısı satırı: **"T.C. Adalet Bakanlığı"**
- Bakanlık katkısı (info kartında): **"Bakanlık katkısı"**
- Arabulucuya geçen miktar: **"Arabuluculuk Ücreti (Tam)"** veya **"Arabuluculuk Ücreti (Kısmi)"** (highlighted satır)
- Disclaimer: **"Sonuç seçimi arabulucunun takdirindedir."** + **"Ayrıntılar için tıklayınız"** linki (yalnızca tüketici-öder senaryosunda gösterilir)

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
├── ConsumerDisputeView.swift              // Girdi ekranı (YearPicker, amount, payer Menu)
├── ConsumerDisputeViewModel.swift         // İş mantığı + iki yorumun hesabı
├── ConsumerDisputeResultSheet.swift       // Sonuç sheet'i (1./2. Sonuç + bracket breakdown)
└── ConsumerDisputeOpinionSheet.swift      // PDFKit görüntüleyici (görüş yazısı)

Denklem/Models/Domain/
└── ConsumerDisputeResult.swift            // PaymentResponsibility + InterpretationResult + ConsumerDisputeResult

Denklem/Resources/Legal/                   // YENİ klasör (Xcode synchronized — otomatik bundle)
├── README.md                              // Hangi PDF nereye konacak, nasıl referans alınır
└── consumer_dispute_opinion.pdf           // Adalet Bakanlığı görüş yazısı (kullanıcı tarafından eklenecek)
```

### Değiştirilen Mevcut Dosyalar

```
DisputeCategoryViewModel.swift    → .consumerDispute + .customCalculation enum case'leri eklendi
                                    Tüm switch'ler güncellendi (displayName/description/systemImage/iconColor)
                                    navigateToConsumerDispute + showComingSoonAlert published flag'leri eklendi
                                    selectCategory + resetNavigation güncellendi
                                    specialCalculations array: [rentSpecial, attorneyFee, reinstatement,
                                      serialDisputes, consumerDispute, customCalculation]
                                    shortcutCalculations: [smmCalculation, timeCalculation] (yeni computed)

DisputeSectionCard.swift          → shortcutCategories parametresi eklendi (grid ve shortcut bağımsız)
                                    capsule render mantığı kaldırıldı — hepsi RectangleButton
                                    accessibilityHint(for:) helper'ı (consumerDispute hint'i için)

DisputeCategoryView.swift         → shortcutCategories: viewModel.shortcutCalculations parametresi
                                    ConsumerDispute .navigationDestination eklendi
                                    Coming Soon .alert modifier'ı eklendi
                                    Üst boşluk daraltıldı (padding tweaks)

RectangleButton.swift             → minHeight 72 → 64 (dikey boşluk azaltıldı)

LocalizationKeys.swift            → ConsumerDispute struct (12 key)
                                    DisputeCategory: consumerDispute*, customCalculation* (4 key)
                                    Accessibility: consumerDisputeButtonHint, consumerDisputePayerMenuHint
                                    General: comingSoonTitle, comingSoonMessage

Localizable.xcstrings             → Toplam ~20 yeni key × 3 dil (TR/EN/SV)
                                    "✓" kaldırıldı (Step 4 öncesi temizliği)
```

> **Değişmeyen dosyalar:** `SMMCalculationView`, `SMMCalculationViewModel`, `TimeCalculationView`, `TimeCalculationViewModel`, `TimeCalculationSheet` — bunların hiçbiri dokunulmadı. Süre Hesaplama shortcut row'da olduğu gibi çalışmaya devam ediyor.

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

### Adım 1: Model Katmanı — ✅ DONE
- [x] `PaymentResponsibility` enum oluştur (Identifiable, displayName)
- [x] `InterpretationResult` struct oluştur (consumerPays, sellerPays, governmentPays, mediatorReceives)
- [x] `ConsumerDisputeResult` struct oluştur (totalFee, governmentPayment, iki yorum, bracket breakdown)

### Adım 2: ViewModel — ✅ DONE
- [x] `ConsumerDisputeViewModel` oluştur
  - Girdiler: tarife yılı, anlaşma tutarı, ücret sorumlusu
  - `selectedYear.getTariffProtocol()` üzerinden tariff erişimi
  - `tariff.calculateAgreementFeeWithBreakdown(disputeType: "consumer", amount, partyCount: 2)` toplam ücret
  - `tariff.getHourlyRate(for: "consumer") × 2` Bakanlık katkısı
  - `computeInterpretationA` (geniş) ve `computeInterpretationB` (dar) — pure fonksiyonlar
  - `formatAmountInput()` locale-aware live formatlama (TR `,` / EN `.`)
  - Validasyon: `parsedAmount >= ValidationConstants.Amount.minimum`

### Adım 3: Navigasyon Düzenlemesi — ✅ DONE (planlanandan farklı)
- [x] `DisputeCategoryType` güncelle:
  - `.consumerDispute` case eklendi (cart.circle.fill, .mint, displayName/description)
  - `.customCalculation` case eklendi (star.circle, .yellow — placeholder)
  - `.timeCalculation` enum'da kaldı, sadece grid'deki üst slot'tan çıktı
  - `capsuleSystemImage` computed property (Time için dinamik takvim ikonu) eklendi
- [x] `DisputeCategoryViewModel` güncelle:
  - `navigateToConsumerDispute` + `showComingSoonAlert` published flag'leri eklendi
  - `specialCalculations`: [rentSpecial, attorneyFee, reinstatement, serialDisputes, **consumerDispute**, **customCalculation**]
  - `shortcutCalculations`: [smmCalculation, timeCalculation] (yeni computed)
  - `navigateToTimeCalculation` korunur (shortcut row için, eskisi gibi çalışıyor)
- [x] `DisputeSectionCard` refactor: `shortcutCategories` parametresi eklendi
- [x] `DisputeCategoryView` güncelle:
  - `.navigationDestination(isPresented: $viewModel.navigateToConsumerDispute)` → ConsumerDisputeView
  - `.alert(isPresented: $viewModel.showComingSoonAlert)` (Özel Hesaplama için "Yakında" alert)
  - Calendar overlay ikonu YAPILMADI (plan değişti — Süre, shortcut row'da kaldı)
- [x] SMMCalculationView, TimeCalculationView ve ViewModel'leri değişmedi ✓

### Adım 4: Girdi Ekranı — ✅ DONE
- [x] `ConsumerDisputeView` oluştur
  - `YearPickerSection` (paylaşılan bileşen)
  - Anlaşma tutarı: header + TextField (decimalPad, live format, glass effect)
  - Ücret sorumlusu: header + `Menu` (3 seçenek, checkmark ile aktif değer)
  - `ErrorBannerView` validasyon mesajı için
  - `CalculateButton` (paylaşılan bileşen)
  - Inline result card (tap → sheet açar, MediationFee pattern)

### Adım 5: Sonuç Sheet'i — ✅ DONE
- [x] `ConsumerDisputeResultSheet` oluştur (MediationFeeResultSheet pattern)
  - Main fee card (FeeResultCard, expand/collapse, glow shadow)
  - Hesaplama Bilgileri kartı (4 satır: yıl, tutar, payer, Bakanlık katkısı)
  - **1. Sonuç** kartı = Yorum B (dar, mediator tam ücret) — üstte
  - **2. Sonuç** kartı = Yorum A (geniş, mediator kısmi ücret) — altta
  - Disclaimer kartı: "Sonuç kısmı arabulucunun takdirindedir." + "Ayrıntılar için tıklayınız" linki
  - Bracket breakdown kartı (sadece bracketSteps boş değilse)
  - Toolbar: paylaş (TXT export) + tamam (dismiss)
  - Staggered revealRow() animasyonu (50ms gecikme)
- [x] `ConsumerDisputeOpinionSheet` oluştur — PDFKit görüntüleyici
  - `Bundle.main.url(forResource:withExtension:)` ile yüklenir
  - PDF yoksa graceful fallback (doc.questionmark + "henüz eklenmemiş" mesajı)

### Adım 6: Lokalizasyon — ✅ DONE
- [x] `LocalizationKeys.swift`'e tüm anahtarlar eklendi
  - `ConsumerDispute` struct: agreementAmountLabel, payerLabel, 3 payer option, 2 result title, 4 row label, 2 disclaimer, opinionSheetTitle, opinionPdfMissing (12 key)
  - `DisputeCategory`: consumerDispute*, customCalculation* (4 key)
  - `Accessibility`: consumerDisputeButtonHint, consumerDisputePayerMenuHint (2 key)
  - `General`: comingSoonTitle, comingSoonMessage (2 key)
- [x] `Localizable.xcstrings`'e tüm çeviriler eklendi (TR/EN/SV, alfabetik sıraya yerleştirildi)

### Adım 7: Erişilebilirlik — ✅ DONE
- [x] Tüm input alanlarına label + hint + value
- [x] Header text'ler `.accessibilityAddTraits(.isHeader)`
- [x] Dekoratif ikonlar `.accessibilityHidden(true)` (chevron, info, doc.questionmark)
- [x] Inline result card + main fee card `.combine` + `.isButton` + expand/collapse hint
- [x] Disclaimer link `.accessibilityAddTraits(.isLink)`
- [x] DisputeSectionCard'a per-category hint helper'ı eklendi (Consumer Dispute butonu için hint)
- [x] Result-loaded announcement (ViewModel'de hesaplama bitince + ResultSheet açılınca)
- [x] Error onChange announcement, isExpanded onChange announcement
- [x] PDFKit görüntüleyici kendi a11y'sini hallediyor (text content, page nav otomatik)

### Adım 8: Test ve İnceleme — ✅ DONE
- [x] Cihazda 3 ücret sorumlusu × 2 yıl × 3 farklı tutar senaryosu
- [x] PDF dosyası `Resources/Legal/consumer_dispute_opinion.pdf` konumuna eklendi ve linkten açılıyor
- [x] VoiceOver akışı doğrulandı
- [x] 3 dil arasında geçiş (TR/EN/SV) — UI taraması
- [x] Özel Hesaplama → "Yakında" alert çalışıyor

---

## Kararlar (Kesinleşmiş)

1. **Taraf sayısı alınmaz.** Anlaşma durumunda toplam ücret sadece anlaşma tutarı üzerinden yüzde (bracket) hesabıyla bulunur — taraf sayısı sonucu etkilemez. Devlet payı hesabında da her zaman 2 taraf (1 tüketici + 1 satıcı) varsayılır. Tüketici tarafında birden fazla kişi olsa bile devletin ödeyeceği miktar artmaz, kendi aralarında paylaşırlar.

2. **Satıcı tamamını öderse devlet payı devreye girmez.** 6502/73A-3 sadece tüketiciyi korur. Tüketicinin ödeme yükümlülüğü yoksa devlet de ödemez. Bu durumda her iki yorum da aynı sonucu verir: satıcı 9.000 TL, devlet 0 TL, tüketici 0 TL.

3. **NavigationDestination olarak açılır.** Sheet'ler hafif/hızlı hesaplamalar için (Reinstatement, Serial Disputes). Tüketici Uyuşmazlığı daha kapsamlı bir hesaplama — SMM, Avukatlık, Kira gibi navigationDestination ile açılır.

4. **Sadece anlaşma durumu.** Anlaşmama durumunda zaten MediationFee butonundaki hesaplama yeterli — Birinci Kısım ücreti uygulanır ve devlet tamamını karşılar. Bu özelliğe eklenmeyecek.

5. **3'lü seçim menü (dropdown) olarak.** Segmented picker yerine SwiftUI Menu bileşeni kullanılacak.

6. **Mevcut MediationFee hesaplama mantığı kullanılacak.** Toplam ücret için aynı bracket hesabı + asgari ücret kontrolü. Ek olarak devlet payı ve sonuç hesaplamaları yapılacak.

7. **Süre Hesaplama shortcut row'da kaldı.** Plandaki "overlay calendar icon" yaklaşımı uygulanmadı. Yerine `DisputeSectionCard`'a `shortcutCategories` parametresi eklendi ve grid'in altında SMM + Süre kısayolları olarak kaldılar. Süre butonu hâlâ dinamik takvim ikonu kullanıyor (`"\(day).calendar"`).

8. **Tüketici Uyuşmazlığı, ÜST SMM slot'unun yerine geçti** (Süre değil). Üst Süre slot'una ise `customCalculation` placeholder'ı yerleştirildi (`star.circle` ikonu, dokunulunca "Yakında" alert). Bu sayede gelecekte başka bir özel hesaplama özelliği için yer ayrılmış oldu. Buton sayısı 6'da kaldı (3×2 grid) + 2 shortcut.

9. **İsimlendirmeler — FINAL:**
   - **"1. Sonuç"** = Yorum B (dar/mediator-favourable, mediator tam ücret alır). Üstte gösterilir — Adalet Bakanlığı'nın 2024 görüş yazısı bu yorumu destekliyor.
   - **"2. Sonuç"** = Yorum A (geniş/consumer-favourable, mediator kısmi ücret alır). Altta gösterilir.
   - Devlet katkısı satırı: **"T.C. Adalet Bakanlığı"**
   - Mediator satırı: **"Arabuluculuk Ücreti (Tam)"** / **"Arabuluculuk Ücreti (Kısmi)"**
   - Info kartında devlet katkısı: **"Bakanlık katkısı"**
   - Disclaimer: **"Sonuç kısmı arabulucunun takdirindedir."** + **"Ayrıntılar için tıklayınız"** linki (PDFKit ile orijinal görüş yazısını açar)

10. **Görüş yazısı PDF olarak bundle'lanır.** `Denklem/Resources/Legal/consumer_dispute_opinion.pdf` konumuna konur, Xcode synchronized folders otomatik dahil eder. `ConsumerDisputeOpinionSheet` PDFKit ile görüntüler. PDF eksikse "henüz eklenmemiş" mesajı görünür (graceful fallback).

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
| Planlama dokümanı | ✅ Tamamlandı |
| Model katmanı | ✅ Tamamlandı |
| ViewModel | ✅ Tamamlandı |
| Navigasyon düzenlemesi | ✅ Tamamlandı (overlay yerine shortcut row pattern'i kullanıldı) |
| Girdi ekranı (ConsumerDisputeView) | ✅ Tamamlandı |
| Sonuç sheet'i (ConsumerDisputeResultSheet) | ✅ Tamamlandı |
| PDF görüntüleyici (ConsumerDisputeOpinionSheet) | ✅ Tamamlandı |
| Lokalizasyon (TR/EN/SV) | ✅ Tamamlandı |
| Erişilebilirlik (VoiceOver audit) | ✅ Tamamlandı |
| İsimlendirme kararları | ✅ Tamamlandı (1./2. Sonuç, T.C. Adalet Bakanlığı, Tam/Kısmi) |
| Custom Calculation placeholder (üst Süre slot'u) | ✅ Tamamlandı |
| Cihaz testi | ✅ Tamamlandı |
| PDF dosyasının eklenmesi | ✅ Tamamlandı |
