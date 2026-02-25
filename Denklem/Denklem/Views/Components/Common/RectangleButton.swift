//
//  RectangleButton.swift
//  Denklem
//
//  Created by ozkan on 30.01.2026.
//

import SwiftUI

/// A reusable rectangle-shaped button with icon and text, designed for card layouts.
/// Similar to CapsuleButton but with rounded rectangle shape for better text fitting.
@available(iOS 26.0, *)
struct RectangleButton: View {
    @Environment(\.theme) var theme

    let systemImage: String
    let iconColor: Color
    let text: String
    let textColor: Color
    let font: Font
    let cornerRadius: CGFloat
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(iconColor)
                Text(text)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .minimumScaleFactor(0.85) // Allow text to shrink slightly to fit within the button without truncation
            }
            .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.roundedRectangle(radius: cornerRadius))
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview {
    VStack(spacing: 16) {
        RectangleButton(
            systemImage: "turkishlirasign.circle.fill",
            iconColor: .green,
            text: "Parasal Olan Uyuşmazlık",
            textColor: .primary,
            font: .footnote,
            cornerRadius: 12,
            action: {}
        )

        RectangleButton(
            systemImage: "doc.text.fill",
            iconColor: .blue,
            text: "Parasal Olmayan Uyuşmazlık",
            textColor: .primary,
            font: .footnote,
            cornerRadius: 12,
            action: {}
        )
    }
    .padding()
}
