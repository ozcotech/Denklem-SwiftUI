//
//  SurveyViewModel.swift
//  Denklem
//
//  Created by ozkan on 8.02.2026.
//

import SwiftUI

// MARK: - Survey Question Model

struct SurveyQuestion {
    let title: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Survey ViewModel

@available(iOS 26.0, *)
@MainActor
final class SurveyViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: Int? = nil
    @Published var isAnswered: Bool = false
    @Published var isCompleted: Bool = false

    // MARK: - Persistent State

    @AppStorage(AppConstants.UserDefaultsKeys.surveyCompleted)
    var isSurveyCompleted: Bool = false

    // MARK: - Questions

    let questions: [SurveyQuestion] = [
        SurveyQuestion(
            title: LocalizationKeys.Survey.question1Title,
            options: [
                LocalizationKeys.Survey.question1OptionA,
                LocalizationKeys.Survey.question1OptionB
            ],
            correctIndex: 1,
            explanation: LocalizationKeys.Survey.question1Explanation
        ),
        SurveyQuestion(
            title: LocalizationKeys.Survey.question2Title,
            options: [
                LocalizationKeys.Survey.question2OptionA,
                LocalizationKeys.Survey.question2OptionB
            ],
            correctIndex: 0,
            explanation: LocalizationKeys.Survey.question2Explanation
        )
    ]

    // MARK: - Computed Properties

    var currentQuestion: SurveyQuestion {
        questions[currentQuestionIndex]
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var isCorrectAnswer: Bool {
        selectedAnswer == currentQuestion.correctIndex
    }

    // MARK: - Public Methods

    func selectAnswer(_ index: Int) {
        guard !isAnswered else { return }
        selectedAnswer = index
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnswered = true
        }
    }

    func nextQuestion() {
        if isLastQuestion {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCompleted = true
            }
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
                selectedAnswer = nil
                isAnswered = false
            }
        }
    }

    func completeSurvey() {
        isSurveyCompleted = true
    }
}
