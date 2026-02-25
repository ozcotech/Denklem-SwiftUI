//
//  MediationFeeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 12.02.2026.
//

import SwiftUI

// MARK: - Mediation Fee Result Sheet
/// Full screen sheet displaying mediation fee calculation result
@available(iOS 26.0, *)
struct MediationFeeResultSheet: View {

    let result: CalculationResult
    let theme: ThemeProtocol
    let isMonetary: Bool

    @Environment(\.dismiss) private var dismiss
    @AppStorage("mediationResultSheetSeen") private var hasSeenBefore = false
    @State private var isExpanded = false
    @State private var revealContent = false
    @State private var showShareSheet = false
    @State private var hintScale: CGFloat = 1.0
    @State private var hintShadowRadius: CGFloat = 0

    private var smmLegalPersonResultForFee: SMMPersonResult {
        let input = SMMCalculationInput(amount: result.amount, calculationType: .vatIncludedWithholdingIncluded)
        return SMMCalculator.calculateSMM(input: input).legalPersonResult
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.spacingL) {

                    // Main Fee Card
                    mainFeeCard
                        .onTapGesture {
                            if isExpanded {
                                revealContent = false
                                withAnimation(.smooth(duration: 0.3)) {
                                    isExpanded = false
                                }
                            } else {
                                // card container opening speed is 0.3s, content fade-in starts after 0.1s to create a slight overlap effect
                                withAnimation(.smooth(duration: 0.3)) {
                                    isExpanded = true
                                }
                                // reveal trigger delay speed is 0.1s to allow the card expansion animation to start before content begins fading in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    revealContent = true
                                }
                            }
                        }

                    if isExpanded {
                        // Calculation Info Card
                        calculationInfoCard
                            .transition(.opacity)

                        // Calculation Method Card (only for agreement cases)
                        if result.input.agreementStatus == .agreed,
                           !result.mediationFee.calculationBreakdown.bracketSteps.isEmpty {
                            calculationMethodCard
                                .transition(.opacity)
                        }

                        // SMM Result Card (only for non-agreement cases)
                        if result.input.agreementStatus == .notAgreed {
                            smmResultCard
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.bottom, theme.spacingXXL)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareFileURL])
        }
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        // Discoverability: on first use, auto-expand detail cards so the user learns the tap-to-expand mechanic.
        // On subsequent uses, play a one-shot shadow + scale pulse to hint the card is tappable.
        .onAppear {
            if !hasSeenBefore {
                // First time: auto-expand so user discovers the mechanic
                withAnimation(.smooth(duration: 0.3)) {
                    isExpanded = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    revealContent = true
                }
                hasSeenBefore = true
            } else {
                // Subsequent uses: shadow + scale pulse hint
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        hintScale = 1.02
                        hintShadowRadius = 16
                    }
                    withAnimation(.easeInOut(duration: 0.8).delay(0.8)) {
                        hintScale = 1.0
                        hintShadowRadius = 0
                    }
                }
            }
        }
    }

    // MARK: - Share Text

    private var shareText: String {
        var lines: [String] = []

        // Mediation Fee
        lines.append("\(LocalizationKeys.Result.mediationFee.localized):")
        lines.append(LocalizationHelper.formatCurrency(result.amount))
        lines.append("")

        // Calculation Info
        lines.append("\(LocalizationKeys.Result.calculationInfo.localized):")

        if !isMonetary {
            lines.append("\(LocalizationKeys.Result.disputeSubject.localized): \(LocalizationKeys.Result.disputeSubjectNonMonetary.localized)")
        } else {
            let statusText = result.input.agreementStatus == .agreed
                ? LocalizationKeys.AgreementStatus.agreed.localized
                : LocalizationKeys.AgreementStatus.notAgreed.localized
            lines.append("\(LocalizationKeys.Result.agreementStatus.localized): \(statusText)")
        }

        lines.append("\(LocalizationKeys.Result.disputeType.localized): \(result.disputeType.displayName)")
        lines.append("\(LocalizationKeys.Result.tariffYear.localized): \(result.input.tariffYear.displayName)")

        if result.input.agreementStatus == .notAgreed {
            lines.append("\(LocalizationKeys.Result.partyCount.localized): \(result.input.partyCount)")
        }

        if let amount = result.input.disputeAmount {
            lines.append("\(LocalizationKeys.Input.agreementAmount.localized): \(LocalizationHelper.formatCurrency(amount))")
        }

        // Calculation Method (agreement cases)
        if result.input.agreementStatus == .agreed,
           !result.mediationFee.calculationBreakdown.bracketSteps.isEmpty {
            let breakdown = result.mediationFee.calculationBreakdown
            lines.append("")
            lines.append("\(LocalizationKeys.Result.calculationMethod.localized):")

            for (index, step) in breakdown.bracketSteps.enumerated() {
                let tierLabel: String
                if index == 0 {
                    tierLabel = "\(LocalizationKeys.Result.firstTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
                } else if step.bracketLimit == Double.infinity {
                    tierLabel = "\(LocalizationHelper.formatCurrency(step.bracketLowerBound)) \(LocalizationKeys.Result.aboveTier.localized)"
                } else {
                    tierLabel = "\(LocalizationKeys.Result.nextTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
                }
                lines.append("\(tierLabel) × %\(LocalizationHelper.formatRate(step.rate)) = \(LocalizationHelper.formatCurrency(step.calculatedFee))")
            }

            if let bracketTotal = breakdown.bracketTotal {
                lines.append("\(LocalizationKeys.Result.bracketTotal.localized): \(LocalizationHelper.formatCurrency(bracketTotal))")
            }

            if let minimumFee = breakdown.minimumFeeThreshold {
                lines.append("\(LocalizationKeys.Result.minimumFee.localized): \(LocalizationHelper.formatCurrency(minimumFee))")
            }

            lines.append(breakdown.usedMinimumFee
                         ? LocalizationKeys.Result.minimumFeeApplied.localized
                         : LocalizationKeys.Result.bracketTotalApplied.localized)
        }

        // SMM (non-agreement cases)
        if result.input.agreementStatus == .notAgreed {
            lines.append("")
            lines.append("\(LocalizationKeys.Result.calculationResult.localized):")
            lines.append("\(LocalizationKeys.SMMResult.grossFee.localized): \(smmLegalPersonResultForFee.formattedBrutFee)")
            lines.append("\(LocalizationKeys.SMMResult.withholding.localized): \(smmLegalPersonResultForFee.formattedStopaj)")
            lines.append("\(LocalizationKeys.SMMResult.netFee.localized): \(smmLegalPersonResultForFee.formattedNetFee)")
            lines.append("\(LocalizationKeys.SMMResult.vat.localized): \(smmLegalPersonResultForFee.formattedKdv)")
            lines.append("\(LocalizationKeys.SMMResult.totalCollected.localized): \(smmLegalPersonResultForFee.formattedTahsilEdilecekTutar)")
        }

        lines.append("")
        lines.append(LocalizationKeys.General.calculatedWithDenklem.localized)

        return lines.joined(separator: "\n")
    }

    private var shareFileURL: URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let fileName = "Denklem_\(formatter.string(from: Date()))"

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).txt")
        try? shareText.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    // MARK: - Main Fee Card

    private var mainFeeCard: some View {
        VStack(spacing: theme.spacingS) {
            VStack(spacing: theme.spacingM) {
                Text(LocalizationKeys.Result.mediationFee.localized)
                    .font(theme.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.textSecondary)

                Text(LocalizationHelper.formatCurrency(result.amount))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(theme.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(theme.spacingL)
            .background {
                RoundedRectangle(cornerRadius: theme.cornerRadiusXL)
                    .fill(theme.surfaceElevated)
            }
            .overlay {
                RoundedRectangle(cornerRadius: theme.cornerRadiusXL)
                    .stroke(theme.primary.opacity(0.3), lineWidth: 1.5)
            }
            .shadow(color: theme.primary.opacity(0.3), radius: hintShadowRadius)
            .scaleEffect(hintScale)

            // Pill indicator — mimics iOS sheet drag indicator, hints "tap for more"
            if !isExpanded {
                Capsule()
                    .fill(theme.textSecondary.opacity(0.3))
                    .frame(width: 36, height: 4)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }

    // MARK: - Calculation Info Card

    private var calculationInfoCard: some View {
        VStack(spacing: theme.spacingS) {
            // Card Header
            revealRow(order: 0) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(LocalizationKeys.Result.calculationInfo.localized)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)

                        Spacer()
                    }

                    Divider()
                        .background(theme.border)
                }
            }

            // Agreement Status - special text for non-monetary disputes
            revealRow(order: 1) {
                if !isMonetary {
                    detailRow(
                        label: LocalizationKeys.Result.disputeSubject.localized,
                        value: LocalizationKeys.Result.disputeSubjectNonMonetary.localized
                    )
                } else {
                    detailRow(
                        label: LocalizationKeys.Result.agreementStatus.localized,
                        value: result.input.agreementStatus == .agreed ? LocalizationKeys.AgreementStatus.agreed.localized : LocalizationKeys.AgreementStatus.notAgreed.localized
                    )
                }
            }

            revealRow(order: 2) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    // Dispute Type
                    detailRow(
                        label: LocalizationKeys.Result.disputeType.localized,
                        value: result.disputeType.displayName
                    )
                }
            }

            revealRow(order: 3) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    // Tariff Year
                    detailRow(
                        label: LocalizationKeys.Result.tariffYear.localized,
                        value: result.input.tariffYear.displayName
                    )
                }
            }

            // Party Count (only for non-agreement cases)
            if result.input.agreementStatus == .notAgreed {
                revealRow(order: 4) {
                    VStack(spacing: theme.spacingS) {
                        Divider()
                            .background(theme.outline.opacity(0.2))

                        detailRow(
                            label: LocalizationKeys.Result.partyCount.localized,
                            value: "\(result.input.partyCount)"
                        )
                    }
                }
            }

            // Amount (only for agreement cases with amount)
            if let amount = result.input.disputeAmount {
                revealRow(order: 4) {
                    VStack(spacing: theme.spacingS) {
                        Divider()
                            .background(theme.outline.opacity(0.2))

                        detailRow(
                            label: LocalizationKeys.Input.agreementAmount.localized,
                            value: LocalizationHelper.formatCurrency(amount)
                        )
                    }
                }
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Calculation Method Card

    private var calculationMethodCard: some View {
        let breakdown = result.mediationFee.calculationBreakdown

        return VStack(spacing: theme.spacingS) {
            // Card Header
            revealRow(order: 5) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(LocalizationKeys.Result.calculationMethod.localized)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)

                        Spacer()
                    }

                    Divider()
                        .background(theme.border)
                }
            }

            // Bracket Steps
            ForEach(Array(breakdown.bracketSteps.enumerated()), id: \.offset) { index, step in
                revealRow(order: 6 + index) {
                    VStack(spacing: theme.spacingS) {
                        if index > 0 {
                            Divider()
                                .background(theme.outline.opacity(0.2))
                        }

                        bracketStepRow(step: step, index: index, isLast: step.bracketLimit == Double.infinity)
                    }
                }
            }

            revealRow(order: 6 + breakdown.bracketSteps.count) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.border)

                    // Bracket Total
                    if let bracketTotal = breakdown.bracketTotal {
                        detailRow(
                            label: LocalizationKeys.Result.bracketTotal.localized,
                            value: LocalizationHelper.formatCurrency(bracketTotal)
                        )
                    }

                    // Minimum Fee
                    if let minimumFeeThreshold = breakdown.minimumFeeThreshold {
                        Divider()
                            .background(theme.outline.opacity(0.2))

                        detailRow(
                            label: LocalizationKeys.Result.minimumFee.localized,
                            value: LocalizationHelper.formatCurrency(minimumFeeThreshold)
                        )
                    }
                }
            }

            revealRow(order: 7 + breakdown.bracketSteps.count) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.border)

                    // Result explanation
                    HStack(spacing: theme.spacingXS) {
                        Image(systemName: "info.circle.fill")
                            .font(theme.footnote)
                            .foregroundStyle(theme.primary)

                        Text(breakdown.usedMinimumFee
                             ? LocalizationKeys.Result.minimumFeeApplied.localized
                             : LocalizationKeys.Result.bracketTotalApplied.localized)
                            .font(theme.footnote)
                            .foregroundStyle(theme.textSecondary)

                        Spacer()
                    }
                }
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Bracket Step Row

    private func bracketStepRow(step: BracketBreakdownStep, index: Int, isLast: Bool) -> some View {
        let tierLabel: String = {
            if index == 0 {
                return "\(LocalizationKeys.Result.firstTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
            } else if isLast {
                return "\(LocalizationHelper.formatCurrency(step.bracketLowerBound)) \(LocalizationKeys.Result.aboveTier.localized)"
            } else {
                return "\(LocalizationKeys.Result.nextTier.localized) \(LocalizationHelper.formatCurrency(step.tierAmount))"
            }
        }()

        return HStack {
            Text(tierLabel)
                .font(theme.footnote)
                .foregroundStyle(theme.textSecondary)

            Spacer()

            Text("× %\(LocalizationHelper.formatRate(step.rate)) = \(LocalizationHelper.formatCurrency(step.calculatedFee))")
                .font(theme.footnote)
                .fontWeight(.medium)
                .foregroundStyle(theme.textPrimary)
        }
    }

    // MARK: - SMM Result Card

    private var smmResultCard: some View {
        VStack(spacing: theme.spacingS) {
            // Card Header
            revealRow(order: 5) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(LocalizationKeys.Result.calculationResult.localized)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)

                        Spacer()
                    }

                    Divider()
                        .background(theme.border)
                }
            }

            // SMM breakdown rows
            revealRow(order: 6) {
                detailRow(
                    label: LocalizationKeys.SMMResult.grossFee.localized,
                    value: smmLegalPersonResultForFee.formattedBrutFee
                )
            }

            revealRow(order: 7) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    detailRow(
                        label: LocalizationKeys.SMMResult.withholding.localized,
                        value: smmLegalPersonResultForFee.formattedStopaj
                    )
                }
            }

            revealRow(order: 8) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    detailRow(
                        label: LocalizationKeys.SMMResult.netFee.localized,
                        value: smmLegalPersonResultForFee.formattedNetFee
                    )
                }
            }

            revealRow(order: 9) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.outline.opacity(0.2))

                    detailRow(
                        label: LocalizationKeys.SMMResult.vat.localized,
                        value: smmLegalPersonResultForFee.formattedKdv
                    )
                }
            }

            revealRow(order: 10) {
                VStack(spacing: theme.spacingS) {
                    Divider()
                        .background(theme.border)

                    detailRow(
                        label: LocalizationKeys.SMMResult.totalCollected.localized,
                        value: smmLegalPersonResultForFee.formattedTahsilEdilecekTutar
                    )
                }
            }
        }
        .padding(theme.spacingL)
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .fill(theme.surface)
        }
        .overlay {
            RoundedRectangle(cornerRadius: theme.cornerRadiusL)
                .stroke(theme.border, lineWidth: theme.borderWidth)
        }
    }

    // MARK: - Detail Row

    private func detailRow(label: String, value: String) -> some View {
        DetailRow(label: label, value: value)
    }

    // MARK: - Reveal Row Helper

    @ViewBuilder
    private func revealRow<Content: View>(order: Int, @ViewBuilder content: () -> Content) -> some View {
        content()
            .opacity(revealContent ? 1 : 0)
            .animation(.easeOut(duration: 0.35).delay(Double(order) * 0.07), value: revealContent) // Staggered animation for each row (inter-line delay of 0.07s, fade-in duration of 0.35s)
    }
}
