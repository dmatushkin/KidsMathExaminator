//
//  ExamFinishedView.swift
//  KidsMathExaminator
//

import SwiftUI

struct ExamFinishedView: View {
    let result: ExamResult
    @Binding var path: [AppRoute]

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 18) {
                ResultMetricView(titleKey: "Tasks passed", value: result.tasksCount)
                ResultMetricView(titleKey: "Errors", value: result.wrongAnswers.count, isWarning: !result.wrongAnswers.isEmpty)
            }

            Spacer()

            VStack(spacing: 12) {
                if !result.wrongAnswers.isEmpty {
                    Button {
                        path.append(.mistakes(result.wrongAnswers))
                    } label: {
                        Label(LocalizedStringKey("View mistakes"), systemImage: "list.bullet.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Button {
                    path.removeAll()
                } label: {
                    Label(LocalizedStringKey("Back to settings"), systemImage: "gearshape")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .navigationTitle(LocalizedStringKey("You've done"))
        .navigationBarBackButtonHidden(true)
    }
}

private struct ResultMetricView: View {
    let titleKey: LocalizedStringKey
    let value: Int
    var isWarning = false

    var body: some View {
        VStack(spacing: 6) {
            Text(titleKey)
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isWarning ? .red : .primary)
        }
        .frame(maxWidth: .infinity)
    }
}
