//
//  SettingsView.swift
//  KidsMathExaminator
//

import SwiftUI

struct SettingsView: View {
    @Binding var path: [AppRoute]

    @AppStorage("operandMaximum") private var operandMaximum = 20
    @AppStorage("tasksCount") private var tasksCount = 60
    @AppStorage("allowAddition") private var allowAddition = true
    @AppStorage("allowSubstraction") private var allowSubtraction = true
    @AppStorage("allowMultiplication") private var allowMultiplication = false
    @AppStorage("allowDivision") private var allowDivision = false

    private var configuration: ExamConfiguration {
        ExamConfiguration(
            operandMaximum: operandMaximum,
            tasksCount: tasksCount,
            operations: selectedOperations
        )
    }

    private var selectedOperations: [MathSign] {
        var operations: [MathSign] = []

        if allowAddition {
            operations.append(.plus)
        }
        if allowSubtraction {
            operations.append(.minus)
        }
        if allowMultiplication {
            operations.append(.multiplication)
        }
        if allowDivision {
            operations.append(.division)
        }

        return operations
    }

    var body: some View {
        Form {
            Section(LocalizedStringKey("Limits")) {
                NumberSettingRow(
                    titleKey: "Operand maximum",
                    value: $operandMaximum
                )
                NumberSettingRow(
                    titleKey: "Number of tasks",
                    value: $tasksCount
                )
            }

            Section(LocalizedStringKey("Allowed operators")) {
                Toggle(LocalizedStringKey("Allow addition"), isOn: $allowAddition)
                Toggle(LocalizedStringKey("Allow substraction"), isOn: $allowSubtraction)
                Toggle(LocalizedStringKey("Allow multiplication"), isOn: $allowMultiplication)
                Toggle(LocalizedStringKey("Allow division"), isOn: $allowDivision)
            }
        }
        .navigationTitle(LocalizedStringKey("Settings"))
        .safeAreaInset(edge: .bottom) {
            Button {
                path = [.exam(configuration)]
            } label: {
                Label(LocalizedStringKey("Start"), systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!configuration.canStart)
            .padding([.horizontal, .top])
            .padding(.bottom, 8)
            .background(.bar)
        }
    }
}

private struct NumberSettingRow: View {
    let titleKey: LocalizedStringKey
    @Binding var value: Int

    @State private var textValue = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(titleKey)

            Spacer(minLength: 12)

            Button {
                updateValue(value - 10)
            } label: {
                Label(LocalizedStringKey("Decrease"), systemImage: "minus.circle")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderless)

            TextField("0", text: $textValue)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .frame(width: 64)
                .textFieldStyle(.roundedBorder)
                .onChange(of: textValue) { _, newValue in
                    guard isFocused else { return }
                    updateValue(Int(newValue) ?? 0, updateText: false)
                }
                .onSubmit {
                    updateValue(value)
                }

            Button {
                updateValue(value + 10)
            } label: {
                Label(LocalizedStringKey("Increase"), systemImage: "plus.circle")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderless)
        }
        .onAppear {
            textValue = "\(value)"
        }
        .onChange(of: isFocused) { _, focused in
            if !focused {
                updateValue(value)
            }
        }
        .onChange(of: value) { _, newValue in
            if !isFocused {
                textValue = "\(newValue)"
            }
        }
    }

    private func updateValue(_ newValue: Int, updateText: Bool = true) {
        value = min(max(newValue, 0), 200)

        if updateText || textValue.isEmpty {
            textValue = "\(value)"
        }
    }
}
