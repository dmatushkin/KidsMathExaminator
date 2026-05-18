//
//  MistakesView.swift
//  KidsMathExaminator
//

import SwiftUI

struct MistakesView: View {
    let wrongAnswers: [WrongAnswer]

    var body: some View {
        List(wrongAnswers) { wrongAnswer in
            HStack(spacing: 10) {
                Text("\(wrongAnswer.task.firstNumber)")
                Text(wrongAnswer.task.sign.symbol)
                Text("\(wrongAnswer.task.secondNumber)")
                Text("=")
                Text("\(wrongAnswer.answer)")
                    .foregroundStyle(.red)

                Spacer()

                Text("\(wrongAnswer.task.correctResult)")
                    .font(.subheadline.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(LocalizedStringKey("Correct answer"))
            }
            .font(.title3.monospacedDigit())
            .padding(.vertical, 4)
        }
        .navigationTitle(LocalizedStringKey("Mistakes"))
    }
}
