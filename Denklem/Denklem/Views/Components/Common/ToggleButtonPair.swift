import SwiftUI

// MARK: - ToggleButtonPair

/// A reusable pair of toggle buttons with built-in VoiceOver support.
/// Used for binary selections like Monetary/Non-Monetary, Agreement/Non-Agreement.
@available(iOS 26.0, *)
struct ToggleButtonPair: View {

    let leftTitle: String
    let rightTitle: String
    let isLeftSelected: Bool
    var leftColor: Color?
    var rightColor: Color?
    let onLeftTap: () -> Void
    let onRightTap: () -> Void

    @Environment(\.theme) private var theme
    @AppStorage("isAnimatedBackground") private var isAnimatedBackground = false

    var body: some View {
        HStack(spacing: theme.spacingS) {
            toggleButton(
                title: leftTitle,
                isSelected: isLeftSelected,
                selectedColor: leftColor,
                action: onLeftTap
            )

            toggleButton(
                title: rightTitle,
                isSelected: !isLeftSelected,
                selectedColor: rightColor,
                action: onRightTap
            )
        }
    }

    // MARK: - Private

    private func toggleButton(
        title: String,
        isSelected: Bool,
        selectedColor: Color?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacingXS) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(theme.body)
                    .foregroundStyle(isSelected ? (selectedColor ?? theme.primary) : theme.textSecondary)
                    .accessibilityHidden(true)

                Text(title)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? theme.textPrimary : theme.textSecondary)

                Spacer()
            }
            .padding(.horizontal, theme.spacingS)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .contentShape(Rectangle())
            .glassEffect(isAnimatedBackground ? .clear : .regular)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? LocalizationKeys.Accessibility.selected.localized : LocalizationKeys.Accessibility.notSelected.localized)
        .accessibilityHint(LocalizationKeys.Accessibility.checkboxHint.localized)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityRemoveTraits(isSelected ? [] : [.isSelected])
    }
}
