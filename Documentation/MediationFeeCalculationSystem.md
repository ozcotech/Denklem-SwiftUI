# 🧮 Mediation Fee Calculation System

> Visual guide to the mediation fee calculation flow in DENKLEM app.

---

## 📐 Calculation Screen Layout

The mediation fee screen presents a unified, top-to-bottom flow connected by visual **cable connectors**. Here is the layout of the screen:

```mermaid
graph TD
    A["📅 Year Picker<br/>2025 / 2026"]
    A -->|cable| B

    B["💰 Monetary<br/>📋 NonMonetary"]
    B -->|Monetary| C
    B -->|NonMonetary| D

    C["✅ Agreement<br/>❌ NoAgreement"]
    C -->|cable| D

    D["📂 Dispute Type<br/>Dropdown - 10 types"]
    D -->|cable| E

    E["✏️ Input Field<br/>Amount or Party Count"]
    E -->|cable| F

    F["🔘 Calculate"]
    F -->|cable| G

    G["💵 Result Card<br/>Mediation Fee"]
    G -->|tap| H

    H["📊 Result Sheet<br/>Detailed Breakdown"]

    style A fill:#1a73e8,color:#fff,stroke:#1557b0
    style B fill:#2d2d2d,color:#fff,stroke:#555
    style C fill:#2d2d2d,color:#fff,stroke:#555
    style D fill:#2d2d2d,color:#fff,stroke:#555
    style E fill:#2d2d2d,color:#fff,stroke:#555
    style F fill:#34a853,color:#fff,stroke:#2d8f47
    style G fill:#e8710a,color:#fff,stroke:#c45f08
    style H fill:#7b1fa2,color:#fff,stroke:#6a1b9a
```

---

## 🎯 Example Scenario: Monetary → Agreement → Worker-Employer

The following diagram shows a complete calculation flow with an example:

```mermaid
flowchart TD
    subgraph SCREEN["MediationFeeView"]
        direction TB

        YEAR["📅 Year: 2026"]
        YEAR ---|cable| MONETARY

        MONETARY["💰 Monetary ✓"]
        MONETARY ---|cable| AGREEMENT

        AGREEMENT["✅ Agreement ✓"]
        AGREEMENT ---|cable| DISPUTE

        DISPUTE["📂 Worker-Employer"]
        DISPUTE ---|cable| INPUT

        INPUT["✏️ Amount: ₺500.000"]
        INPUT ---|cable| CALC

        CALC["🔘 Calculate"]
        CALC ---|cable| RESULT

        RESULT["💵 Mediation Fee: ₺XX.XXX"]
    end

    RESULT -->|tap| SHEET

    subgraph SHEET["Result Sheet"]
        direction TB
        FEE["💰 Mediation Fee: ₺XX.XXX"]
        INFO["📋 Calculation Info<br/>Status: Agreement<br/>Type: Worker-Employer<br/>Year: 2026<br/>Amount: ₺500.000"]
        METHOD["📊 Calculation Method<br/>Bracket calculation<br/>vs minimum fee"]
    end

    style SCREEN fill:#0d1117,color:#c9d1d9,stroke:#30363d
    style SHEET fill:#0d1117,color:#c9d1d9,stroke:#30363d
    style YEAR fill:#1a73e8,color:#fff,stroke:#1557b0
    style MONETARY fill:#1b5e20,color:#fff,stroke:#145218
    style AGREEMENT fill:#2e7d32,color:#fff,stroke:#256b29
    style DISPUTE fill:#37474f,color:#fff,stroke:#263238
    style INPUT fill:#37474f,color:#fff,stroke:#263238
    style CALC fill:#34a853,color:#fff,stroke:#2d8f47
    style RESULT fill:#e8710a,color:#fff,stroke:#c45f08
    style FEE fill:#e8710a,color:#fff,stroke:#c45f08
    style INFO fill:#37474f,color:#fff,stroke:#263238
    style METHOD fill:#7b1fa2,color:#fff,stroke:#6a1b9a
```

---

## 🔀 All Calculation Paths

There are **3 main calculation paths** depending on user selections:

```mermaid
flowchart LR
    START["Select Year"] --> M{"Monetary?"}

    M -->|Yes| AGR{"Agreement?"}
    M -->|No| NM["NonMonetary"]

    AGR -->|Yes| PATH_A["Agreement"]
    AGR -->|No| PATH_B["NoAgreement"]

    PATH_A --> DT_A["Dispute Type"]
    DT_A --> AMT["Enter Amount"]
    AMT --> CALC_A["Bracket Calc<br/>vs MinFee"]
    CALC_A --> RES_A["Result +<br/>Breakdown"]

    PATH_B --> DT_B["Dispute Type"]
    DT_B --> PC_B["Party Count"]
    PC_B --> CALC_B["FixedFee × Hours"]
    CALC_B --> RES_B["Result +<br/>SMM"]

    NM --> DT_C["Dispute Type"]
    DT_C --> PC_C["Party Count"]
    PC_C --> CALC_C["FixedFee × Hours"]
    CALC_C --> RES_C["Result"]

    style START fill:#1a73e8,color:#fff
    style M fill:#ff6d00,color:#fff
    style AGR fill:#ff6d00,color:#fff
    style PATH_A fill:#2e7d32,color:#fff
    style PATH_B fill:#c62828,color:#fff
    style NM fill:#1565c0,color:#fff
    style CALC_A fill:#7b1fa2,color:#fff
    style CALC_B fill:#7b1fa2,color:#fff
    style CALC_C fill:#7b1fa2,color:#fff
    style RES_A fill:#e8710a,color:#fff
    style RES_B fill:#e8710a,color:#fff
    style RES_C fill:#e8710a,color:#fff
```

---

## 📊 Calculation Methods Summary

| Path | Input | Calculation | Result Details |
|------|-------|-------------|----------------|
| **Monetary + Agreement** | Dispute Type + Amount (₺) | Progressive bracket rates vs. minimum fee (higher wins) | Fee + Bracket breakdown |
| **Monetary + No Agreement** | Dispute Type + Party Count | Fixed fee × minimum hours multiplier | Fee + SMM (withholding tax) breakdown |
| **Non-Monetary** | Dispute Type + Party Count | Fixed fee × minimum hours multiplier | Fee amount |

---

## 🏗️ Available Dispute Types

| # | Dispute Type | Key |
|---|-------------|-----|
| 1 | Worker-Employer | `worker_employer` |
| 2 | Commercial | `commercial` |
| 3 | Consumer | `consumer` |
| 4 | Rent | `rent` |
| 5 | Partnership Dissolution | `partnership_dissolution` |
| 6 | Condominium | `condominium` |
| 7 | Neighbor | `neighbor` |
| 8 | Agricultural Production | `agricultural_production` |
| 9 | Family | `family` |
| 10 | Other | `other` |
