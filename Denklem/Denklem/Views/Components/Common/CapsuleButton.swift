//
//  CapsuleButton.swift
//  Denklem
//
//  Created by Copilot on 20.01.2026.
//

import SwiftUI

/// A reusable capsule-shaped button with icon and text, no internal padding, icon and text flush to edges.
@available(iOS 26.0, *)
struct CapsuleButton: View {
    let systemImage: String
    let iconColor: Color
    let text: String
    let textColor: Color
    let font: Font
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Group {
                if systemImage.isEmpty {
                    // Centered text only (for DisputeTypeView)
                    Text(text)
                        .font(font)
                        .fontWeight(.semibold)
                        .foregroundStyle(textColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .center)
                } else {
                    // Icon + text, left aligned (for DisputeCategoryView)
                    HStack(spacing: 8) {
                        Image(systemName: systemImage)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(iconColor)
                        Text(text)
                            .font(font)
                            .fontWeight(.semibold)
                            .foregroundStyle(textColor)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .truncationMode(.tail)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                }
            }
        }
        .buttonStyle(.glass)
        //.buttonBorderShape(.capsule)
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview {
    CapsuleButton(
        systemImage: "clock.fill",
        iconColor: .blue,
        text: "Non-Monetary Dispute",
        textColor: .white,
        font: .subheadline,
        action: {}
    )
    .padding()
    .background(Color.black)
}
