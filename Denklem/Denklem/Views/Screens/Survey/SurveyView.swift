//
//  SurveyView.swift
//  Denklem
//
//  Created by ozkan on 8.02.2026.
//

import SwiftUI

// MARK: - Option Height Preference Key

struct OptionHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Survey View

@available(iOS 26.0, *)
struct SurveyView: View {

    // MARK: - Properties

    @StateObject private var viewModel = SurveyViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared
    @Environment(\.theme) var theme
    @Environment(\.dismiss) private var dismiss

    @State private var optionHeight: CGFloat = 0

    // MARK: - Body

    var body: some View {
        let _ = localeManager.refreshID

        ZStack {
            theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: theme.spacingXL) {
                    if viewModel.isCompleted {
                        thankYouCard
                    } else {
                        questionCard
                    }
                }
                .padding(.horizontal, theme.spacingM)
                .padding(.top, theme.spacingS)
                .padding(.bottom, theme.spacingXL)
            }
        }
        .onChange(of: viewModel.currentQuestionIndex) {
            optionHeight = 0
        }
        .navigationTitle(LocalizationKeys.Survey.screenTitle.localized)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Question Card

    private var questionCard: some View {
        VStack(spacing: theme.spacingL) {
            // Question Counter
            Text(LocalizationKeys.Survey.questionCounter.localized(
                viewModel.currentQuestionIndex + 1,
                viewModel.questions.count
            ))
            .font(theme.subheadline)
            .foregroundStyle(theme.textSecondary)

            // Question Title
            Text(viewModel.currentQuestion.title.localized)
                .font(theme.headline)
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            // Options
            VStack(spacing: theme.spacingM) {
                ForEach(Array(viewModel.currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    optionButton(index: index, title: option.localized, equalHeight: optionHeight)
                }
            }
            .onPreferenceChange(OptionHeightPreference.self) { value in
                optionHeight = value
            }

            // Feedback Section
            if viewModel.isAnswered {
                feedbackSection
                    .padding(.top, -theme.spacingS)
            }

            // Next Button
            if viewModel.isAnswered {
                Button {
                    viewModel.nextQuestion()
                } label: {
                    Text(viewModel.isLastQuestion
                         ? LocalizationKeys.Survey.closeButton.localized
                         : LocalizationKeys.Survey.nextQuestion.localized)
                        .font(theme.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: theme.buttonHeight)
                }
                .buttonStyle(.glass)
                .padding(.top, -theme.spacingS)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(theme.spacingL)
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
        .id(viewModel.currentQuestionIndex)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: - Option Button

    private func optionButton(index: Int, title: String, equalHeight: CGFloat) -> some View {
        Button {
            viewModel.selectAnswer(index)
        } label: {
            HStack(spacing: theme.spacingM) {
                // Option letter
                Text(index == 0 ? "a)" : "b)")
                    .font(theme.headline)
                    .foregroundStyle(optionLetterColor(for: index))
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(optionCircleColor(for: index))
                    }

                // Option text
                Text(title)
                    .font(theme.body)
                    .foregroundStyle(theme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Feedback icon
                if viewModel.isAnswered {
                    if index == viewModel.currentQuestion.correctIndex {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(theme.title3)
                    } else if index == viewModel.selectedAnswer {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(theme.title3)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacingM)
            .frame(minHeight: equalHeight > 0 ? equalHeight : nil)
            .background {
                GeometryReader { geo in
                    Color.clear.preference(
                        key: OptionHeightPreference.self,
                        value: geo.size.height
                    )
                }
            }
            .contentShape(Rectangle())
            .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusM))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isAnswered)
    }

    // MARK: - Feedback Section

    private var feedbackSection: some View {
        VStack(spacing: theme.spacingS) {
            // Correct / Wrong label
            HStack(spacing: theme.spacingS) {
                Image(systemName: viewModel.isCorrectAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(viewModel.isCorrectAnswer ? .green : .red)
                    .font(theme.title3)

                Text(viewModel.isCorrectAnswer
                     ? LocalizationKeys.Survey.correctAnswer.localized
                     : LocalizationKeys.Survey.wrongAnswer.localized)
                    .font(theme.headline)
                    .foregroundStyle(viewModel.isCorrectAnswer ? .green : .red)
            }

            // Explanation
            Text(viewModel.currentQuestion.explanation.localized)
                .font(theme.subheadline)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(theme.spacingM)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    // MARK: - Thank You Card

    private var thankYouCard: some View {
        VStack(spacing: theme.spacingL) {
            // Icon
            Image(systemName: "party.popper.fill")
                .font(.system(size: 48))
                .foregroundStyle(theme.textSecondary)
                //.symbolRenderingMode(.multicolor)
                //.foregroundStyle(.orange, .yellow, .cyan)

            // Title
            Text(LocalizationKeys.Survey.thankYouTitle.localized)
                .font(theme.title2)
                .foregroundStyle(theme.textPrimary)

            // Message
            Text(LocalizationKeys.Survey.thankYouMessage.localized)
                .font(theme.body)
                .foregroundStyle(theme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            // Email Button
            Button {
                if let url = URL(string: "mailto:\(AppConstants.developerEmail)") {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack(spacing: theme.spacingS) {
                    Image(systemName: "envelope.fill")
                    Text(AppConstants.developerEmail)
                }
                .font(theme.callout)
                .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button {
                    UIPasteboard.general.string = AppConstants.developerEmail
                } label: {
                    Label(String(localized: "Copy"), systemImage: "doc.on.doc")
                }
                Button {
                    if let url = URL(string: "mailto:\(AppConstants.developerEmail)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label(LocalizationKeys.Survey.emailLabel.localized, systemImage: "envelope")
                }
            }

            // Close Button
            Button {
                viewModel.completeSurvey()
                dismiss()
            } label: {
                Text(LocalizationKeys.Survey.closeButton.localized)
                    .font(theme.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: theme.buttonHeight)
            }
            .buttonStyle(.glass)
        }
        .padding(theme.spacingL)
        .glassEffect(in: RoundedRectangle(cornerRadius: theme.cornerRadiusL))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    // MARK: - Helper Methods

    private func optionLetterColor(for index: Int) -> Color {
        guard viewModel.isAnswered else { return theme.textPrimary }
        if index == viewModel.currentQuestion.correctIndex {
            return .white
        } else if index == viewModel.selectedAnswer {
            return .white
        }
        return theme.textSecondary
    }

    private func optionCircleColor(for index: Int) -> Color {
        guard viewModel.isAnswered else { return .clear }
        if index == viewModel.currentQuestion.correctIndex {
            return .green.opacity(0.8)
        } else if index == viewModel.selectedAnswer {
            return .red.opacity(0.8)
        }
        return .clear
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurveyView()
                .injectTheme(LightTheme())
        }
    }
}
