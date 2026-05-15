//
//  ConsumerDisputeOpinionSheet.swift
//  Denklem
//
//  Created by ozkan on 14.05.2026.
//
//  Sheet that displays the official Ministry of Justice (T.C. Adalet Bakanlığı
//  Arabuluculuk Daire Başkanlığı) advisory opinion PDF. The mediator opens this
//  from the result sheet to read the original source and form their own interpretation.
//

import SwiftUI
import PDFKit

@available(iOS 26.0, *)
struct ConsumerDisputeOpinionSheet: View {

    /// Filename (without extension) of the bundled PDF. The matching `.pdf` is expected at
    /// `Denklem/Resources/Legal/<filename>.pdf` — see that folder's README.md for details.
    static let pdfResourceName = "consumer_dispute_opinion"

    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localeManager = LocaleManager.shared

    var body: some View {
        let _ = localeManager.refreshID

        NavigationStack {
            Group {
                if let url = Bundle.main.url(forResource: Self.pdfResourceName, withExtension: "pdf") {
                    PDFKitView(url: url)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    missingPDFMessage
                }
            }
            .navigationTitle(LocalizationKeys.ConsumerDispute.opinionSheetTitle.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(theme.body)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .accessibilityLabel(LocalizationKeys.General.done.localized)
                    .accessibilityHint(LocalizationKeys.Accessibility.dismissHint.localized)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    // MARK: - Fallback

    private var missingPDFMessage: some View {
        VStack(spacing: theme.spacingM) {
            Image(systemName: "doc.questionmark")
                .font(.system(size: 60, weight: .light))
                .foregroundStyle(theme.textSecondary)
                .accessibilityHidden(true)

            Text(LocalizationKeys.ConsumerDispute.opinionPdfMissing.localized)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, theme.spacingL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - PDFKit Bridge

@available(iOS 26.0, *)
private struct PDFKitView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument(url: url)
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.backgroundColor = .systemBackground
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.documentURL != url {
            uiView.document = PDFDocument(url: url)
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview {
    ConsumerDisputeOpinionSheet()
        .injectTheme(LightTheme())
}
