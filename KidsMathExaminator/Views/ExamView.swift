//
//  ExamView.swift
//  KidsMathExaminator
//

import SwiftUI

struct ExamView: View {
    let configuration: ExamConfiguration
    @Binding var path: [AppRoute]

    @State private var session: ExamSession
    @State private var answer = ""
    @State private var answerBackground = Color(.systemBackground)
    @State private var shouldFlashSign = false
    @FocusState private var answerFocused: Bool

    init(configuration: ExamConfiguration, path: Binding<[AppRoute]>) {
        self.configuration = configuration
        self._path = path
        self._session = State(initialValue: ExamSession(configuration: configuration))
    }

    var body: some View {
        VStack(spacing: 28) {
            HStack {
                ProgressView(value: Double(session.currentTaskNumber - 1), total: Double(configuration.tasksCount))
                    .accessibilityLabel(LocalizedStringKey("Progress"))

                Text("\(session.currentTaskNumber) / \(configuration.tasksCount)")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            HStack(alignment: .firstTextBaseline, spacing: 14) {
                Text("\(session.currentTask.firstNumber)")
                Text(session.currentTask.sign.symbol)
                    .opacity(shouldFlashSign ? 0.15 : 1)
                Text("\(session.currentTask.secondNumber)")
                Text("=")
                TextField("?", text: $answer)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .focused($answerFocused)
                    .frame(width: 110)
                    .padding(.vertical, 8)
                    .background(answerBackground, in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary.opacity(0.35), lineWidth: 1)
                    }
            }
            .font(.system(size: 44, weight: .semibold, design: .rounded))
            .minimumScaleFactor(0.45)
            .lineLimit(1)

            HStack(spacing: 16) {
                StatView(titleKey: "Errors", value: session.errorsCount, isWarning: session.errorsCount > 0)
                StatView(titleKey: "Tasks", value: configuration.tasksCount)
            }

            Spacer(minLength: 12)

            Button {
                submitAnswer()
            } label: {
                Label(LocalizedStringKey("Next"), systemImage: "arrow.right.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(answer.isEmpty)
        }
        .padding()
        .navigationTitle(LocalizedStringKey("Tasks"))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            answerFocused = true
        }
    }

    private func submitAnswer() {
        guard let submittedAnswer = Int(answer) else { return }

        switch session.submit(answer: submittedAnswer) {
        case .correct:
            flashAnswer(.green.opacity(0.3), clearAnswer: true)
        case .wrong(let isOtherOperationResult):
            flashAnswer(.red.opacity(0.3), clearAnswer: false)
            if isOtherOperationResult {
                flashSign()
            }
        case .finished(let result):
            path.append(.finish(result))
        }
    }

    private func flashAnswer(_ color: Color, clearAnswer: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            answerBackground = color
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            withAnimation(.easeInOut(duration: 0.2)) {
                answerBackground = Color(.systemBackground)
            }

            if clearAnswer {
                answer = ""
            }
        }
    }

    private func flashSign() {
        withAnimation(.easeInOut(duration: 0.25).repeatCount(2, autoreverses: true)) {
            shouldFlashSign.toggle()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            shouldFlashSign = false
        }
    }
}

private struct StatView: View {
    let titleKey: LocalizedStringKey
    let value: Int
    var isWarning = false

    var body: some View {
        VStack(spacing: 4) {
            Text(titleKey)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.title2.monospacedDigit().weight(.semibold))
                .foregroundStyle(isWarning ? .red : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}
