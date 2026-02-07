# Kira (Tahliye/Tespit) Hesaplama Özelliği - Planlama Dokümanı

## İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Yasal Dayanak](#yasal-dayanak)
3. [Hesaplama Kuralları](#hesaplama-kuralları)
4. [Kullanıcı Akışı](#kullanıcı-akışı)
5. [Dosya Yapısı](#dosya-yapısı)
6. [Uygulama Durumu](#uygulama-durumu)

---

## Genel Bakış

Bu özellik, **kira tahliye ve kira tespiti** uyuşmazlıklarında hem **avukatlık ücreti** hem de **arabuluculuk ücreti** hesaplamak için geliştirilmiştir.

### Kira (Tahliye/Tespit) Nedir?

- **Tahliye:** Kiracının tahliyesine ilişkin davalar. Bir yıllık kira bedeli tutarı üzerinden hesaplama yapılır.
- **Kira Tespiti:** Kira bedelinin mahkemece belirlenmesine ilişkin davalar. Tespit olunan kira bedeli farkının bir yıllık tutarı üzerinden hesaplama yapılır.

### Temel Özellikler

- **Tarife Yılları:** 2025 ve 2026 (her iki yıl için farklı oranlar)
- **Birleşik Ekran:** Segmented picker ile Avukatlık / Arabuluculuk seçimi (tek ekran)
- **Seçim Tipi:** Tahliye ve/veya Tespit (checkbox, tek veya ikisi birlikte seçilebilir)
- **Minimum Ücret Kuralları:** Hem avukatlık hem arabuluculuk için asgari ücret uygulaması

---

## Yasal Dayanak

### A. Avukatlık Ücreti - 2026 Avukatlık Asgari Ücret Tarifesi Madde 9/1

> Tahliye davalarında bir yıllık kira bedeli tutarı, kira tespiti ve nafaka davalarında tespit olunan kira bedeli farkının veya hükmolunan nafakanın bir yıllık tutarı üzerinden bu Tarifenin üçüncü kısmı gereğince hesaplanacak miktarın tamamı, avukatlık ücreti olarak hükmolunur. Bu miktarlar, bu Tarifenin ikinci kısmının ikinci bölümünde davanın görüldüğü mahkemeye göre belirlenmiş bulunan ücretten az olamaz.

**Yorumlama:**
- Tahliye: 1 yıllık kira bedeli üzerinden Tarifenin 3. kısmına göre hesaplama
- Tespit: 1 yıllık kira bedeli farkı (yeni kira - eski kira) üzerinden hesaplama
- Her ikisi seçildiğinde: İki tutarın toplamı üzerinden tek hesaplama
- Sonuç, Sulh Hukuk Mahkemesi asgari ücretinden az olamaz (**uygulanır**)

### B. Arabuluculuk Ücreti - 2026 Arabuluculuk Asgari Ücret Tarifesi Madde 7/5

> Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, kira tespiti ve tahliye talepli uyuşmazlıklarda ücret;
> tahliye talepli uyuşmazlıklarda bir yıllık kira bedeli tutarının yarısı,
> kira tespiti uyuşmazlıklarında tespit olunan kira bedeli farkının bir yıllık tutarı üzerinden bu tarifenin ikinci kısmına göre belirlenir.

**Yorumlama:**
- Tahliye: 1 yıllık kira bedelinin **yarısı** üzerinden hesaplama (kullanıcı tam tutarı girer, uygulama yarısını alır)
- Tespit: 1 yıllık kira bedeli farkının **tamamı** üzerinden hesaplama
- Her ikisi seçildiğinde: **Ayrı ayrı** hesaplanır ve toplam gösterilir

### C. Arabuluculuk Asgari Ücret Kuralı - Madde 7/7

> Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, anlaşma bedeline bakılmaksızın arabuluculuk ücreti 9.000,00 TL'den az olamaz. (2026)

**Minimum Arabuluculuk Ücreti:**
| Yıl | Minimum Ücret |
|-----|--------------|
| 2025 | 6.000 TL |
| 2026 | 9.000 TL |

**Uygulama:** Hesaplanan toplam arabuluculuk ücreti minimum tutarın altındaysa, minimum tutar uygulanır.

### D. Avukatlık Ücreti Asgari Kuralı - Madde 9 (son cümle)

> Bu miktarlar, bu Tarifenin ikinci kısmının ikinci bölümünde davanın görüldüğü mahkemeye göre belirlenmiş bulunan ücretten az olamaz.

**Uygulama:** Tahliye ve kira tespiti davaları genellikle **Sulh Hukuk Mahkemesi**'nde görüldüğünden, hesaplanan avukatlık ücreti Sulh Hukuk Mahkemesi asgari ücretinden az olamaz.

| Yıl | Sulh Hukuk Minimum |
|-----|-------------------|
| 2025 | 18.000 TL |
| 2026 | 30.000 TL |

---

## Hesaplama Kuralları

### A. Avukatlık Ücreti Hesaplama

#### Hesaplama Mantığı

```
Senaryo 1 - Sadece Tahliye:
  hesaplamaTabanı = 1 yıllık kira bedeli
  avukatlıkÜcreti = max(bracketHesaplama(hesaplamaTabanı), sulhHukukMinimum)

Senaryo 2 - Sadece Tespit:
  hesaplamaTabanı = 1 yıllık kira farkı (yeni - eski)
  avukatlıkÜcreti = max(bracketHesaplama(hesaplamaTabanı), sulhHukukMinimum)

Senaryo 3 - Tahliye + Tespit:
  hesaplamaTabanı = 1 yıllık kira bedeli + 1 yıllık kira farkı
  avukatlıkÜcreti = max(bracketHesaplama(hesaplamaTabanı), sulhHukukMinimum)  // TEK hesaplama, TOPLAM üzerinden
```

#### Mahkeme Minimum Ücretleri (Tarifenin 2. Kısmı, 2. Bölüm)

| Mahkeme | 2026 Minimum | 2025 Minimum | Uygulama |
|---------|-------------|-------------|----------|
| Sulh Hukuk Mahkemesi | 30.000 TL | 18.000 TL | **UYGULANIR** |
| Asliye Mahkemesi | 45.000 TL | 30.000 TL | Uyarı |
| İcra Mahkemesi | 18.000 TL | 12.000 TL | Uyarı |

### B. Arabuluculuk Ücreti Hesaplama

#### Hesaplama Mantığı

```
Senaryo 1 - Sadece Tahliye:
  hesaplamaTabanı = 1 yıllık kira bedeli / 2  (YARISI)
  arabuluculukÜcreti = max(tariffBracketHesaplama(hesaplamaTabanı), minimumÜcret)

Senaryo 2 - Sadece Tespit:
  hesaplamaTabanı = 1 yıllık kira farkı (TAMAMI)
  arabuluculukÜcreti = max(tariffBracketHesaplama(hesaplamaTabanı), minimumÜcret)

Senaryo 3 - Tahliye + Tespit (AYRI AYRI HESAPLAMA):
  tahliyeTabanı = 1 yıllık kira bedeli / 2
  tespitTabanı = 1 yıllık kira farkı
  tahliyeÜcreti = tariffBracketHesaplama(tahliyeTabanı)
  tespitÜcreti = tariffBracketHesaplama(tespitTabanı)
  toplamÜcret = max(tahliyeÜcreti + tespitÜcreti, minimumÜcret)
```

> **KRİTİK FARK:** Avukatlık ücretinde tutarlar TOPLANIP tek hesaplama yapılırken, arabuluculuk ücretinde AYRI AYRI hesaplanıp sonuçlar toplanır.

---

## Kullanıcı Akışı

### Birleşik Ekran Yapısı (Segmented Picker)

```
DisputeCategoryView (Mevcut Ekran)
    └── Özel Hesaplamalar Bölümü
            └── Kira (Tahliye/Tespit) ─────────────────────────┐
                                                                ▼
                    ┌─────────────────────────────────────────────┐
                    │     TenancySelectionView (BİRLEŞİK EKRAN)  │
                    │     Nav Title: "Ücret Seçimi"               │
                    │                                              │
                    │  ┌────────────────────────────────────────┐ │
                    │  │         Yıl Seçici (2025/2026)         │ │
                    │  └────────────────────────────────────────┘ │
                    │                                              │
                    │  ┌──────────────┬──────────────────┐       │
                    │  │  Avukatlık   │  Arabuluculuk    │       │
                    │  └──────────────┴──────────────────┘       │
                    │       (Segmented Picker)                    │
                    │                                              │
                    │  ☑ Tahliye                                  │
                    │    [1 yıllık kira bedeli]                   │
                    │                                              │
                    │  ☐ Kira Tespiti                             │
                    │    [1 yıllık kira farkı]                    │
                    │                                              │
                    │  [Hesapla]                                  │
                    └─────────────────────────────────────────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    ▼                                       ▼
        ┌───────────────────────┐           ┌───────────────────────────┐
        │ AttorneyFeeResult     │           │ MediationFeeResult        │
        │ Sheet (SHEET)         │           │ Sheet (SHEET)             │
        │                       │           │                           │
        │ Avukatlık Ücreti      │           │ Tahliye Ücreti: X TL     │
        │ ═══════════════       │           │ Tespit Ücreti: Y TL      │
        │     ₺156.000,00      │           │ Toplam: X+Y TL            │
        │                       │           │                           │
        │ ⚠ Uyarılar:          │           │ ℹ Min. ücret uygulandı    │
        │ Sulh: 30.000 TL min  │           │ Madde 7/5, 7/7            │
        │ ℹ Min. ücret uygulandı│           │                           │
        └───────────────────────┘           └───────────────────────────┘
```

---

## Dosya Yapısı

### Mevcut Klasör Yapısı

```
Denklem/
├── Constants/
│   └── TenancyCalculationConstants.swift        ✅
│
├── Localization/
│   ├── LocalizationKeys.swift                   ✅ (güncellendi)
│   └── Localizable.xcstrings                    ✅ (güncellendi)
│
├── Models/
│   ├── Calculation/
│   │   └── TenancyCalculator.swift              ✅
│   └── Domain/
│       └── TenancyCalculationResult.swift       ✅
│
└── Views/
    └── Screens/
        ├── DisputeCategory/
        │   ├── DisputeCategoryView.swift         ✅ (güncellendi)
        │   └── DisputeCategoryViewModel.swift    ✅ (güncellendi)
        │
        └── TenancySpecial/
            ├── TenancySelectionView.swift         ✅ (birleşik ekran)
            ├── TenancySelectionViewModel.swift    ✅ (birleşik VM)
            ├── TenancyAttorneyFeeResultSheet.swift ✅
            └── TenancyMediationFeeResultSheet.swift ✅
```

> **Not:** TenancyAttorneyFeeView/VM ve TenancyMediationFeeView/VM dosyaları birleşik ekran yapısına geçilmesiyle SİLİNDİ. Tüm mantık TenancySelectionView/VM'de birleştirildi.

---

## Uygulama Durumu

Tüm aşamalar tamamlandı. ✅

### Tamamlanan Özellikler:
- [x] Constants, Result modeli, Calculator
- [x] Lokalizasyon (TR/EN)
- [x] DisputeCategoryView/VM entegrasyonu
- [x] Birleşik TenancySelectionView (segmented picker)
- [x] TenancyAttorneyFeeResultSheet
- [x] TenancyMediationFeeResultSheet
- [x] Avukatlık ücreti Sulh Hukuk minimum uygulaması (Madde 9)
- [x] Arabuluculuk ücreti minimum uygulaması (Madde 7/7)

---

**Doküman Oluşturma Tarihi:** 6 Şubat 2026
**Son Güncelleme:** 7 Şubat 2026
**Versiyon:** 2.0 (Birleşik ekran yapısı)
