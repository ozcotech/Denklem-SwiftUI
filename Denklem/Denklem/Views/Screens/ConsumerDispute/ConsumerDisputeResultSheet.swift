//
//  ConsumerDisputeResultSheet.swift
//  Denklem
//
//  Created by ozkan on 13.05.2026.
//
//  Result sheet for the Consumer Dispute mediation fee calculation.
//  Mirrors MediationFeeResultSheet's pattern (toolbar with share+done, main fee card,
//  expand/collapse, staggered reveal, glass cards), and adds two interpretation
//  cards (1.Sonuç = narrow/mediator-favourable, 2.Sonuç = broad/consumer-favourable)
//  plus a disclaimer linking to the official Ministry advisory opinion PDF.
//

import SwiftUI

@available(iOS 26.0, *)
struct ConsumerDisputeResultSheet: View {

    let result: ConsumerDisputeResult

    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isAnimatedBackground) private var isAnimatedBackground
    @ObservedObject private var localeManager = LocaleManager.shared

    @State private var isExpanded = false
    @State private var revealContent = false
    @State private var showShareSheet = false
    @State private var showOpinionSheet = false

    // MARK: - Body

    var body: some View {
        let _ = localeManager.refreshID

        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: theme.spacingL) {

                        mainFeeCard

                        if isExpanded {
                            calculationInfoCard
                                .transition(.opacity)

                            // When the consumer is on the hook, both interpretations are
                            // meaningful and the legal ambiguity matters → show both cards
                            // plus the advisory-opinion disclaimer. For the other two
                            // scenarios the result is unambiguous, so a single card suffices.
                            switch result.paymentResponsibility {
                            case .consumer:
                                interpretationCard(
                                    title: LocalizationKeys.ConsumerDispute.resultFirst.localized,
                                    interpretation: result.interpretationB,
                                    mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorFull.localized,
                                    baseOrder: 5
                                )
                                .transition(.opacity)

                                interpretationCard(
                                    title: LocalizationKeys.ConsumerDispute.resultSecond.localized,
                                    interpretation: result.interpretationA,
                                    mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorPartial.localized,
                                    baseOrder: 10
                                )
                                .transition(.opacity)

                                disclaimerCard
                                    .transition(.opacity)

                            case .equal:
                                // Equal split → mediator receives a partial fee under either reading.
                                // Use Interpretation A's numbers (broad reading) with the "(Kısmi)" label.
                                interpretationCard(
                                    title: LocalizationKeys.ConsumerDispute.resultSingle.localized,
                                    interpretation: result.interpretationA,
                                    mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorPartial.localized,
                                    baseOrder: 5
                                )
                                .transition(.opacity)

                            case .seller:
                                // Seller pays everything → consumer obligation = 0 → 73/A-3 doesn't
                                // trigger → both interpretations produce identical numbers (mediator
                                // gets the full fee). Show one card labelled "(Tam)".
                                interpretationCard(
                                    title: LocalizationKeys.ConsumerDispute.resultSingle.localized,
                                    interpretation: result.interpretationB,
                                    mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorFull.localized,
                                    baseOrder: 5
                                )
                                .transition(.opacity)
                            }

                            if !result.bracketSteps.isEmpty {
                                calculationMethodCard
                                    .transition(.opacity)
                            }
                        }
                    }
                    .padding(.horizontal, theme.spacingM)
                    .padding(.bottom, theme.spacingXXL)
                    .frame(minHeight: geometry.size.height, alignment: .top)
                    .contentShape(Rectangle())
                    .onTapGesture { toggleExpansion() }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .animatedBackground()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .accessibilityLabel(LocalizationKeys.Accessibility.share.localized)
                    .accessibilityHint(LocalizationKeys.Accessibility.shareHint.localized)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .accessibilityLabel(LocalizationKeys.Accessibility.done.localized)
                    .accessibilityHint(LocalizationKeys.Accessibility.dismissHint.localized)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareFileURL])
        }
        .sheet(isPresented: $showOpinionSheet) {
            ConsumerDisputeOpinionSheet()
        }
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear {
            // Auto-expand on entry so the result is visible without an extra tap.
            // No animation here — animating glass layout expansion looks janky.
            isExpanded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                revealContent = true
            }
            // Announce the main result for VoiceOver users.
            // Delayed past the sheet's slide-in so it doesn't get clipped by the system's
            // own "sheet opened" announcement.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                let msg = "\(LocalizationKeys.Result.mediationFee.localized): \(LocalizationHelper.formatCurrency(result.totalFee))"
                AccessibilityNotification.Announcement(msg).post()
            }
        }
        .onChange(of: isExpanded) { _, expanded in
            let msg = expanded
                ? LocalizationKeys.Accessibility.detailsExpanded.localized
                : LocalizationKeys.Accessibility.detailsCollapsed.localized
            AccessibilityNotification.Announcement(msg).post()
        }
    }

    private func toggleExpansion() {
        if isExpanded {
            revealContent = false
            withAnimation(.smooth(duration: 0.3)) {
                isExpanded = false
            }
        } else {
            withAnimation(.smooth(duration: 0.3)) {
                isExpanded = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                revealContent = true
            }
        }
    }

    // MARK: - Main Fee Card

    private var mainFeeCard: some View {
        FeeResultCard(
            title: LocalizationKeys.Result.mediationFee.localized,
            formattedAmount: LocalizationHelper.formatCurrency(result.totalFee),
            showShadow: true
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(LocalizationKeys.Accessibility.expandCollapseHint.localized)
        .accessibilityValue(isExpanded
            ? LocalizationKeys.Accessibility.expanded.localized
            : LocalizationKeys.Accessibility.collapsed.localized)
    }

    // MARK: - Calculation Info Card

    private var calculationInfoCard: some View {
        VStack(spacing: theme.spacingS) {
            revealRow(order: 0) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(LocalizationKeys.Result.calculationInfo.localized)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    Divider().background(theme.border)
                }
            }

            revealRow(order: 1) {
                DetailRow(
                    label: LocalizationKeys.Result.tariffYear.localized,
                    value: result.tariffYear.displayName
                )
            }

            revealRow(order: 2) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.Input.agreementAmount.localized,
                        value: LocalizationHelper.formatCurrency(result.agreementAmount)
                    )
                }
            }

            revealRow(order: 3) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.ConsumerDispute.payerLabel.localized,
                        value: result.paymentResponsibility.displayName
                    )
                }
            }

            revealRow(order: 4) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.ConsumerDispute.rowGovernmentPayment.localized,
                        value: LocalizationHelper.formatCurrency(result.governmentPayment)
                    )
                }
            }
        }
        .padding(theme.spacingL)
        .glassEffect(isAnimatedBackground ? .clear : .regular,
                     in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }

    // MARK: - Interpretation Card

    private func interpretationCard(
        title: String,
        interpretation: InterpretationResult,
        mediatorLabel: String,
        baseOrder: Int
    ) -> some View {
        VStack(spacing: theme.spacingS) {
            revealRow(order: baseOrder) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(title)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    Divider().background(theme.border)
                }
            }

            revealRow(order: baseOrder + 1) {
                DetailRow(
                    label: LocalizationKeys.ConsumerDispute.payerConsumer.localized,
                    value: LocalizationHelper.formatCurrency(interpretation.consumerPays)
                )
            }

            revealRow(order: baseOrder + 2) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.ConsumerDispute.payerSeller.localized,
                        value: LocalizationHelper.formatCurrency(interpretation.sellerPays)
                    )
                }
            }

            revealRow(order: baseOrder + 3) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.ConsumerDispute.rowMinistry.localized,
                        value: LocalizationHelper.formatCurrency(interpretation.governmentPays)
                    )
                }
            }

            revealRow(order: baseOrder + 4) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.border)
                    DetailRow(
                        label: mediatorLabel,
                        value: LocalizationHelper.formatCurrency(interpretation.mediatorReceives),
                        isHighlighted: true
                    )
                }
            }
        }
        .padding(theme.spacingL)
        .glassEffect(isAnimatedBackground ? .clear : .regular,
                     in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }

    // MARK: - Disclaimer + PDF Link

    private var disclaimerCard: some View {
        revealRow(order: 15) {
            VStack(spacing: theme.spacingS) {
                HStack(alignment: .top, spacing: theme.spacingXS) {
                    Image(systemName: "info.circle.fill")
                        .font(theme.footnote)
                        .foregroundStyle(theme.primary)
                        .accessibilityHidden(true)

                    Text(LocalizationKeys.ConsumerDispute.resultDisclaimer.localized)
                        .font(theme.footnote)
                        .foregroundStyle(theme.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Button {
                    showOpinionSheet = true
                } label: {
                    HStack(spacing: theme.spacingXS) {
                        Text(LocalizationKeys.ConsumerDispute.resultDetailsLink.localized)
                            .font(theme.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(theme.primary)
                        Image(systemName: "arrow.up.right.square")
                            .font(theme.caption)
                            .foregroundStyle(theme.primary)
                            .accessibilityHidden(true)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(LocalizationKeys.ConsumerDispute.resultDetailsLink.localized)
                .accessibilityAddTraits(.isLink)
            }
            .frame(maxWidth: .infinity)
            .padding(theme.spacingL)
            .glassEffect(isAnimatedBackground ? .clear : .regular,
                         in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
        }
    }

    // MARK: - Calculation Method Card (Bracket Breakdown)

    private var calculationMethodCard: some View {
        VStack(spacing: theme.spacingS) {
            revealRow(order: 17) {
                VStack(spacing: theme.spacingS) {
                    HStack {
                        Text(LocalizationKeys.Result.calculationMethod.localized)
                            .font(theme.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(theme.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    Divider().background(theme.border)
                }
            }

            ForEach(Array(result.bracketSteps.enumerated()), id: \.offset) { index, step in
                revealRow(order: 18 + index) {
                    VStack(spacing: theme.spacingS) {
                        if index > 0 {
                            Divider().background(theme.outline.opacity(0.2))
                        }
                        bracketStepRow(step: step, index: index, isLast: step.bracketLimit == Double.infinity)
                    }
                }
            }

            revealRow(order: 18 + result.bracketSteps.count) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.border)
                    DetailRow(
                        label: LocalizationKeys.Result.bracketTotal.localized,
                        value: LocalizationHelper.formatCurrency(result.bracketTotal)
                    )
                    Divider().background(theme.outline.opacity(0.2))
                    DetailRow(
                        label: LocalizationKeys.Result.minimumFee.localized,
                        value: LocalizationHelper.formatCurrency(result.minimumFee)
                    )
                }
            }

            revealRow(order: 19 + result.bracketSteps.count) {
                VStack(spacing: theme.spacingS) {
                    Divider().background(theme.border)
                    HStack(spacing: theme.spacingXS) {
                        Image(systemName: "info.circle.fill")
                            .font(theme.footnote)
                            .foregroundStyle(theme.primary)
                            .accessibilityHidden(true)
                        Text(result.usedMinimumFee
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
        .glassEffect(isAnimatedBackground ? .clear : .regular,
                     in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
    }

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
        .accessibilityElement(children: .combine)
    }

    // MARK: - Reveal Row Helper

    @ViewBuilder
    private func revealRow<Content: View>(order: Int, @ViewBuilder content: () -> Content) -> some View {
        content()
            .opacity(revealContent ? 1 : 0)
            .animation(.easeOut(duration: 0.35).delay(Double(order) * 0.05), value: revealContent)
    }

    // MARK: - Share Text

    private var shareText: String {
        var lines: [String] = []
        let payer = result.paymentResponsibility.displayName

        lines.append("\(LocalizationKeys.Result.mediationFee.localized):")
        lines.append(LocalizationHelper.formatCurrency(result.totalFee))
        lines.append("")

        lines.append("\(LocalizationKeys.Result.calculationInfo.localized):")
        lines.append("\(LocalizationKeys.Result.tariffYear.localized): \(result.tariffYear.displayName)")
        lines.append("\(LocalizationKeys.Input.agreementAmount.localized): \(LocalizationHelper.formatCurrency(result.agreementAmount))")
        lines.append("\(LocalizationKeys.ConsumerDispute.payerLabel.localized) \(payer)")
        lines.append("\(LocalizationKeys.ConsumerDispute.rowGovernmentPayment.localized): \(LocalizationHelper.formatCurrency(result.governmentPayment))")
        lines.append("")

        // Mirror the on-screen layout: two cards + disclaimer for the consumer-pays
        // scenario, one card for the unambiguous equal-split and seller-pays scenarios.
        switch result.paymentResponsibility {
        case .consumer:
            lines.append("\(LocalizationKeys.ConsumerDispute.resultFirst.localized):")
            appendInterpretation(result.interpretationB,
                                 mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorFull.localized,
                                 to: &lines)
            lines.append("")

            lines.append("\(LocalizationKeys.ConsumerDispute.resultSecond.localized):")
            appendInterpretation(result.interpretationA,
                                 mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorPartial.localized,
                                 to: &lines)
            lines.append("")

            lines.append(LocalizationKeys.ConsumerDispute.resultDisclaimer.localized)
            lines.append("")

        case .equal:
            lines.append("\(LocalizationKeys.ConsumerDispute.resultSingle.localized):")
            appendInterpretation(result.interpretationA,
                                 mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorPartial.localized,
                                 to: &lines)
            lines.append("")

        case .seller:
            lines.append("\(LocalizationKeys.ConsumerDispute.resultSingle.localized):")
            appendInterpretation(result.interpretationB,
                                 mediatorLabel: LocalizationKeys.ConsumerDispute.rowMediatorFull.localized,
                                 to: &lines)
            lines.append("")
        }

        lines.append(LocalizationKeys.General.calculatedWithDenklem.localized)

        return lines.joined(separator: "\n")
    }

    private func appendInterpretation(_ i: InterpretationResult,
                                      mediatorLabel: String,
                                      to lines: inout [String]) {
        lines.append("\(LocalizationKeys.ConsumerDispute.payerConsumer.localized): \(LocalizationHelper.formatCurrency(i.consumerPays))")
        lines.append("\(LocalizationKeys.ConsumerDispute.payerSeller.localized): \(LocalizationHelper.formatCurrency(i.sellerPays))")
        lines.append("\(LocalizationKeys.ConsumerDispute.rowMinistry.localized): \(LocalizationHelper.formatCurrency(i.governmentPays))")
        lines.append("\(mediatorLabel): \(LocalizationHelper.formatCurrency(i.mediatorReceives))")
    }

    private var shareFileURL: URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let fileName = "Denklem_ConsumerDispute_\(formatter.string(from: Date()))"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).txt")
        try? shareText.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 26.0, *)
#Preview {
    let sample = ConsumerDisputeResult(
        agreementAmount: 14000,
        tariffYear: .year2026,
        paymentResponsibility: .consumer,
        totalFee: 9000,
        governmentPayment: 2000,
        consumerShareNormal: 4500,
        sellerShareNormal: 4500,
        interpretationA: InterpretationResult(
            consumerPays: 4500,
            sellerPays: 0,
            governmentPays: 2000,
            mediatorReceives: 6500
        ),
        interpretationB: InterpretationResult(
            consumerPays: 7000,
            sellerPays: 0,
            governmentPays: 2000,
            mediatorReceives: 9000
        ),
        bracketSteps: [],
        bracketTotal: 840,
        minimumFee: 9000,
        usedMinimumFee: true
    )
    return ConsumerDisputeResultSheet(result: sample)
        .injectTheme(LightTheme())
}
#endif
