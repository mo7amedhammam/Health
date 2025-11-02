//
//  QuestionaireView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//

import SwiftUI

private enum QuestionType: Int, CaseIterable, Identifiable {
    case text = 1
    case mcq = 2
    case trueFalse = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .text: return "text_questions_".localized
        case .mcq: return "mcq_questions_".localized
        case .trueFalse: return "true_false_questions_".localized
        }
    }
}

struct QuestionaireView: View {
    @StateObject private var viewModel = QuestionaireViewModel.shared

    var CustomerPackageId: Int

    // MARK: - Answers State (UI state to render controls)
    @State private var textAnswers: [Int: String] = [:]
    @State private var mcqAnswersMulti: [Int: Set<String>] = [:]
    @State private var tfAnswers: [Int: Bool] = [:]

    @State private var isSubmitting: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            TitleBar(title: "laquestions_", hasbackBtn: true)

            ScrollView {
                VStack(spacing: 28) {
                    // Text section
                    if let textQuestions = questions(of: .text), !textQuestions.isEmpty {
//                        SectionHeaderView(title: QuestionType.text.title)
                        ForEach(textQuestions.indices, id: \.self) { idx in
                            let q = textQuestions[idx]
                            let qid = q.id ?? -1
                            QuestionTypeBlock(
                                question: q,
                                previousAnswers: q.answer ?? [],
                                mcqOptions: [],
                                textAnswer: Binding(
                                    get: { textAnswers[qid] ?? "" },
                                    set: { textAnswers[qid] = $0 }
                                ),
                                mcqAnswers: .constant([]),
                                tfAnswer: .constant(false),
                                selectedType: .text
                            )
                            .padding(.horizontal, 20)
                        }
                    }

                    // MCQ section
                    if let mcqQuestions = questions(of: .mcq), !mcqQuestions.isEmpty {
//                        SectionHeaderView(title: QuestionType.mcq.title)
                        ForEach(mcqQuestions.indices, id: \.self) { idx in
                            let q = mcqQuestions[idx]
                            let qid = q.id ?? -1
                            let options = deriveMcqOptions(for: q)
                            QuestionTypeBlock(
                                question: q,
                                previousAnswers: q.answer ?? [],
                                mcqOptions: options,
                                textAnswer: .constant(""),
                                mcqAnswers: Binding(
                                    get: { mcqAnswersMulti[qid] ?? [] },
                                    set: { mcqAnswersMulti[qid] = $0 }
                                ),
                                tfAnswer: .constant(false),
                                selectedType: .mcq
                            )
                            .padding(.horizontal, 20)
                        }
                    }

                    // True/False section
                    if let tfQuestions = questions(of: .trueFalse), !tfQuestions.isEmpty {
//                        SectionHeaderView(title: QuestionType.trueFalse.title)
                        ForEach(tfQuestions.indices, id: \.self) { idx in
                            let q = tfQuestions[idx]
                            let qid = q.id ?? -1
                            QuestionTypeBlock(
                                question: q,
                                previousAnswers: q.answer ?? [],
                                mcqOptions: [],
                                textAnswer: .constant(""),
                                mcqAnswers: .constant([]),
                                tfAnswer: Binding(
                                    get: { tfAnswers[qid] ?? false },
                                    set: { tfAnswers[qid] = $0 }
                                ),
                                selectedType: .trueFalse
                            )
                            .padding(.horizontal, 20)
                        }
                    }

                    // Submit all types together
                    if (viewModel.questions?.isEmpty == false) {
                        CustomButton(
                            title: "save_",
                            isdisabled: isSubmitting || (viewModel.isLoading ?? false),
                            backgroundView: AnyView(Color.clear.horizontalGradientBackground())
                        ) {
                            Task { await submitAllTypes() }
                        }
                        .disabled(isSubmitting || (viewModel.isLoading ?? false))
                    }

                    Spacer(minLength: 8)
                }
                .padding(.vertical, 25)
            }
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading )
        .errorAlert(isPresented:Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .task(id: CustomerPackageId) {
            viewModel.CustomerPackageId = CustomerPackageId
//            await viewModel.getCustomerQuestions()
            seedInitialAnswers()
        }
        .onChange(of: viewModel.questions) { _ in
            seedInitialAnswers()
        }
    }

    private func questions(of type: QuestionType) -> [CustomerPackageQuestM]? {
        viewModel.questions?.filter { QuestionType(rawValue: $0.typeID ?? 0) == type }
    }

    private func deriveMcqOptions(for q: CustomerPackageQuestM) -> [String] {
        guard let type = QuestionType(rawValue: q.typeID ?? 0), type == .mcq else { return [] }
        if let prev = q.answer, !prev.isEmpty {
            let values = prev.compactMap { $0.answer?.trimmingCharacters(in: .whitespacesAndNewlines) }
            let unique = Array(Set(values)).filter { !$0.isEmpty }
            return unique
        }
        return []
    }

    private func seedInitialAnswers() {
        textAnswers.removeAll()
        mcqAnswersMulti.removeAll()
        tfAnswers.removeAll()

        guard let questions = viewModel.questions else { return }

        for q in questions {
            guard let id = q.id else { continue }
            switch QuestionType(rawValue: q.typeID ?? 0) {
            case .text:
                textAnswers[id] = ""
            case .mcq:
                mcqAnswersMulti[id] = []
            case .trueFalse:
                tfAnswers[id] = false
            default:
                break
            }
        }
    }

    @MainActor
    private func submitAllTypes() async {
        guard let questions = viewModel.questions else { return }
        isSubmitting = true
        defer { isSubmitting = false }

        var itemsToSend: [(qid: Int, typeId: Int, answer: String, mcqId: Int?)] = []

        for q in questions {
            guard let qid = q.id, let typeId = q.typeID, let qType = QuestionType(rawValue: typeId) else { continue }
            switch qType {
            case .text:
                let value = (textAnswers[qid] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if value.isEmpty { continue }
                itemsToSend.append((qid, typeId, value, nil))

            case .mcq:
                let set = mcqAnswersMulti[qid] ?? []
                if set.isEmpty { continue }
                let value = set.sorted().joined(separator: ",")
                itemsToSend.append((qid, typeId, value, 0)) // mcqId = 0 by requirement

            case .trueFalse:
                let boolVal = tfAnswers[qid] ?? false
                let value = boolVal ? "true" : "false"
                itemsToSend.append((qid, typeId, value, nil))
            }
        }

        if itemsToSend.isEmpty {
            viewModel.errorMessage = "لا توجد إجابات لإرسالها".localized
            return
        }

        await viewModel.addAnswers(itemsToSend)
        await viewModel.getCustomerQuestions()

        // Clear inputs after submit
        for q in questions {
            guard let qid = q.id, let typeId = q.typeID, let qType = QuestionType(rawValue: typeId) else { continue }
            switch qType {
            case .text: textAnswers[qid] = ""
            case .mcq: mcqAnswersMulti[qid] = []
            case .trueFalse: tfAnswers[qid] = false
            }
        }
    }
}

// MARK: - Section Header
private struct SectionHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.bold(size: 18))
                .foregroundColor(.mainBlue)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - QuestionTypeBlock
private struct QuestionTypeBlock: View {
    let question: CustomerPackageQuestM
    let previousAnswers: [Answer]
    let mcqOptions: [String]

    @Binding var textAnswer: String
    @Binding var mcqAnswers: Set<String>
    @Binding var tfAnswer: Bool

    let selectedType: QuestionType

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(question.question ?? "")
                .font(.bold(size: 22))
                .foregroundColor(.mainBlue)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !previousAnswers.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("previous_answers_".localized)
                        .font(.medium(size: 14))
                        .foregroundColor(Color(.secondary))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(previousAnswers.indices, id: \.self) { idx in
                        let a = previousAnswers[idx]
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(a.answer ?? "-")
                                .font(.regular(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical)

                            HStack(spacing: 8) {
                                if let dr = a.doctorName, !dr.isEmpty {
                                    (Text("By._".localized)+Text(dr))
                                        .font(.regular(size: 12))
                                        .foregroundColor(Color(.secondary))
                                }
                                
                                Spacer()
                                
                                if let date = a.formattedCreationDate, !date.isEmpty {
                                    Text(date)
                                        .font(.regular(size: 12))
                                        .foregroundColor(Color(.secondary))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color(.messageSenderBg))
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical, 6)
            }

            // New answer input matching type
            VStack(alignment: .leading, spacing: 10) {
                Text("new_answer_".localized)
                    .font(.medium(size: 14))
                    .foregroundColor(Color(.secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)

                switch selectedType {
                case .mcq:
                    if mcqOptions.isEmpty {
                        Text("no_options_available_".localized)
                            .font(.regular(size: 14))
                            .foregroundColor(Color(.secondary))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        MCQGrid(options: mcqOptions, selected: $mcqAnswers)
                    }

                case .trueFalse:
                    VStack(alignment: .leading, spacing: 12) {
                        RadioRow(title: "yes_".localized, isOn: Binding(
                            get: { tfAnswer },
                            set: { _ in tfAnswer = true }
                        ))
                        RadioRow(title: "no_".localized, isOn: Binding(
                            get: { !tfAnswer },
                            set: { _ in tfAnswer = false }
                        ))
                    }
                    .padding(.top, 4)

                case .text:
                    VStack(spacing: 8) {
                        
                        CustomInputFieldUI(
                            title: "",
                            placeholder: "Type_Answer_here_",
                            text: $textAnswer,
                            isValid: true,
                            isMultilineText: true,
                            isIconOnTop: true,
                            trailingView: nil
                        )

                    }
                }
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - MCQ Grid
private struct MCQGrid: View {
    let options: [String]
    @Binding var selected: Set<String>

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(options, id: \.self) { opt in
                HStack(spacing: 8) {
                    Text(opt)
                        .font(.regular(size: 16))
                        .foregroundColor(.mainBlue)
                    Checkbox(isChecked: selected.contains(opt)) {
                        if selected.contains(opt) {
                            selected.remove(opt)
                        } else {
                            selected.insert(opt)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if selected.contains(opt) { selected.remove(opt) }
                    else { selected.insert(opt) }
                }
            }
        }
    }
}

private struct RadioRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.regular(size: 18))
                .foregroundColor(.mainBlue)

            ZStack {
                Image(isOn ? .radiofill : .radio)
                    .resizable()
                    .frame(width: 17, height: 17)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture { isOn.toggle() }
    }
}

#Preview {
    QuestionaireView(CustomerPackageId: 0)
}
