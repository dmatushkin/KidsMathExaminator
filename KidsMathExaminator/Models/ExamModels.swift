//
//  ExamModels.swift
//  KidsMathExaminator
//

import Foundation
import Observation

struct ExamConfiguration: Hashable {
    let operandMaximum: Int
    let tasksCount: Int
    let operations: [MathSign]

    var canStart: Bool {
        operandMaximum > 0 && tasksCount > 0 && !operations.isEmpty
    }
}

struct MathTask: Hashable {
    let firstNumber: Int
    let secondNumber: Int
    let sign: MathSign

    var correctResult: Int {
        sign.result(firstNumber, secondNumber)
    }
}

struct WrongAnswer: Hashable, Identifiable {
    let id = UUID()
    let task: MathTask
    let answer: Int
}

struct ExamResult: Hashable {
    let tasksCount: Int
    let wrongAnswers: [WrongAnswer]
}

@Observable
final class ExamSession {
    let configuration: ExamConfiguration
    private(set) var currentTaskNumber = 1
    private(set) var currentTask: MathTask
    private(set) var wrongAnswers: [WrongAnswer] = []

    var errorsCount: Int {
        wrongAnswers.count
    }

    init(configuration: ExamConfiguration) {
        self.configuration = configuration
        self.currentTask = ExamSession.makeTask(configuration: configuration)
    }

    func submit(answer: Int) -> ExamSubmissionResult {
        if answer == currentTask.correctResult {
            currentTaskNumber += 1

            if currentTaskNumber > configuration.tasksCount {
                return .finished(ExamResult(tasksCount: configuration.tasksCount, wrongAnswers: wrongAnswers))
            }

            currentTask = ExamSession.makeTask(configuration: configuration)
            return .correct
        }

        wrongAnswers.append(WrongAnswer(task: currentTask, answer: answer))
        return .wrong(isOtherOperationResult: isResultOfAnotherOperation(answer))
    }

    private func isResultOfAnotherOperation(_ answer: Int) -> Bool {
        MathSign.allCases.contains { sign in
            sign.result(currentTask.firstNumber, currentTask.secondNumber) == answer
        }
    }

    private static func makeTask(configuration: ExamConfiguration) -> MathTask {
        let sign = configuration.operations.randomElement() ?? .plus
        let operandMaximum = max(configuration.operandMaximum, 1)
        let multiplicationMinimum = 2
        let multiplicationMaximum = max(operandMaximum, multiplicationMinimum)

        var firstNumber: Int
        var secondNumber: Int

        switch sign {
        case .multiplication, .division:
            firstNumber = Int.random(in: multiplicationMinimum...multiplicationMaximum)
            secondNumber = Int.random(in: multiplicationMinimum...multiplicationMaximum)
        case .plus, .minus:
            firstNumber = Int.random(in: 1...operandMaximum)
            secondNumber = Int.random(in: 1...operandMaximum)
        }

        if sign == .minus && firstNumber < secondNumber {
            swap(&firstNumber, &secondNumber)
        }

        if sign == .division {
            firstNumber *= secondNumber
        }

        return MathTask(firstNumber: firstNumber, secondNumber: secondNumber, sign: sign)
    }
}

enum ExamSubmissionResult: Hashable {
    case correct
    case wrong(isOtherOperationResult: Bool)
    case finished(ExamResult)
}
