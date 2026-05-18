//
//  ContentView.swift
//  KidsMathExaminator
//

import SwiftUI

struct ContentView: View {
    @State private var path: [AppRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            SettingsView(path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .exam(let configuration):
                        ExamView(configuration: configuration, path: $path)
                    case .finish(let result):
                        ExamFinishedView(result: result, path: $path)
                    case .mistakes(let wrongAnswers):
                        MistakesView(wrongAnswers: wrongAnswers)
                    }
                }
        }
    }
}

enum AppRoute: Hashable {
    case exam(ExamConfiguration)
    case finish(ExamResult)
    case mistakes([WrongAnswer])
}

#Preview {
    ContentView()
}
