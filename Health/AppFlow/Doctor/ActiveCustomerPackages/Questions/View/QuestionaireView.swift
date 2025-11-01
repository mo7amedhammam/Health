//
//  QuestionaireView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//

import SwiftUI

private enum QuestionType: Int {
    case text = 1
    case mcq = 2
    case trueFalse = 3
}

// Mock محلي لخيارات MCQ لأن CustomerPackageQuestM لا يحتوي options
private struct MCQOptions {
    let questionId: Int
    let options: [String]
}

struct QuestionaireView: View {
    @StateObject private var viewModel = QuestionaireViewModel.shared

    var CustomerPackageId: Int

    // MARK: - Answers State (UI state to render controls)
    @State private var textAnswers: [Int: String] = [:]
    // لدعم تعدد الاختيارات حسب التصميم
    @State private var mcqAnswersMulti: [Int: Set<String>] = [:]
    @State private var tfAnswers: [Int: Bool] = [:]

    @State private var isSubmitting: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            TitleBar(title: "laquestions_", hasbackBtn: true)

            ScrollView {
                VStack(spacing: 24) {
                    if let questions = viewModel.questions, !questions.isEmpty {
                        ForEach(questions.indices, id: \.self) { idx in
                            let q = questions[idx]
                            let qid = q.id ?? -1

                            // Try to derive MCQ options if your API later provides them.
                            // For now, we have no options in the model, so we’ll render selected chips only if present.
                            let options = deriveMcqOptions(for: q)

                            QuestionBlock(
                                index: idx + 1,
                                question: q,
                                mcqOptions: options,
                                textAnswer: Binding(
                                    get: { textAnswers[qid] ?? "" },
                                    set: { newVal in
                                        textAnswers[qid] = newVal
                                        viewModel.updateAnswer(for: qid, answer: newVal)
                                    }
                                ),
                                mcqAnswers: Binding(
                                    get: { mcqAnswersMulti[qid] ?? [] },
                                    set: { newVal in
                                        mcqAnswersMulti[qid] = newVal
                                        // Persist as comma-separated for backend (matches seedInitialAnswers parsing)
                                        let value = newVal.sorted().joined(separator: ",")
                                        viewModel.updateAnswer(for: qid, answer: value)
                                    }
                                ),
                                tfAnswer: Binding(
                                    get: { tfAnswers[qid] ?? false },
                                    set: { newVal in
                                        tfAnswers[qid] = newVal
                                        viewModel.updateAnswer(for: qid, answer: newVal ? "true" : "false")
                                    }
                                )
                            )
                            .padding(.horizontal, 20)
                        }
                    } else {
                        // Empty or loading state
                        if viewModel.isLoading == true {
                            ProgressView().padding(.top, 20)
                        } else {
                            Text("no_data_found_".localized)
                                .font(.regular(size: 16))
                                .foregroundStyle(Color(.secondary))
                                .padding(.top, 20)
                        }
                    }

                    Spacer()

                    CustomButton(title: "save_",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                        Task { await submit() }
                    }
                    .disabled(isSubmitting || viewModel.isLoading == true)

                }
                .padding(.top, 12)
            }
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading )
        .errorAlert(isPresented:Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        .task(id: CustomerPackageId) {
            // Configure view model and fetch
            viewModel.CustomerPackageId = CustomerPackageId
            await viewModel.getCustomerQuestions()
            seedInitialAnswers()
        }
        .onChange(of: viewModel.questions) { _ in
            // When questions change (e.g. refresh), reseed UI state
            seedInitialAnswers()
        }
    }

    // Attempt to derive MCQ options. Currently model has no explicit options; we can:
    // - Use distinct previous answers if present as a best-effort.
    // - Else, return empty; grid will still allow selection, but with no visible options nothing to tap.
    private func deriveMcqOptions(for q: CustomerPackageQuestM) -> [String] {
        guard let type = QuestionType(rawValue: q.typeID ?? 0), type == .mcq else { return [] }
        // If backend later adds options, replace this with q.options (or via viewModel)
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
                let value = q.answer?.first?.answer ?? ""
                textAnswers[id] = value
                viewModel.updateAnswer(for: id, answer: value ?? "")
            case .mcq:
                if let prev = q.answer?.first?.answer, !prev.isEmpty {
                    let set = Set(prev.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
                    mcqAnswersMulti[id] = set
                    viewModel.updateAnswer(for: id, answer: set.sorted().joined(separator: ","))
                } else {
                    mcqAnswersMulti[id] = []
                }
            case .trueFalse:
                if let prev = q.answer?.first?.answer?.lowercased() {
                    let boolVal = (prev == "true" || prev == "yes" || prev == "نعم")
                    tfAnswers[id] = boolVal
                    viewModel.updateAnswer(for: id, answer: boolVal ? "true" : "false")
                } else {
                    tfAnswers[id] = false
                }
            default:
                break
            }
        }
    }

    @MainActor
    private func submit() async {
        isSubmitting = true
        viewModel.errorMessage = nil
        defer {
            isSubmitting = false
        }

        // Validate required answers for text/mcq if needed
        if let questions = viewModel.questions {
            var missing = [Int]()
            for q in questions {
                guard let id = q.id else { continue }
                switch QuestionType(rawValue: q.typeID ?? 0) {
                case .text, .mcq:
                    let value = viewModel.userAnswers[id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    if value.isEmpty { missing.append(id) }
                case .trueFalse:
                    break
                default:
                    break
                }
            }
            if !missing.isEmpty {
                viewModel.errorMessage = "من فضلك أجب على كل الأسئلة المطلوبة".localized
                return
            }
        }

        await viewModel.addCustomerQuestionAnswer()
    }
}

// MARK: - Question Block
private struct QuestionBlock: View {
    let index: Int
    let question: CustomerPackageQuestM
    let mcqOptions: [String]

    @Binding var textAnswer: String
    @Binding var mcqAnswers: Set<String>
    @Binding var tfAnswer: Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // العنوان "سؤال X"
            Text(question.question ?? "سؤال")
                .font(.bold(size: 22))
                .foregroundColor(.mainBlue)
                .frame(maxWidth: .infinity, alignment: .trailing)

            switch QuestionType(rawValue: question.typeID ?? 0) {
            case .mcq:
                MCQGrid(options: mcqOptions, selected: $mcqAnswers)

            case .trueFalse:
                VStack(alignment: .trailing, spacing: 12) {
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
                // حقل نصي بلا إطار + خط سفلي رفيع
                VStack(spacing: 8) {
                    if #available(iOS 16.0, *) {
                        TextField("Type_Answer_here_".localized, text: $textAnswer, axis: .vertical)
                            .font(.regular(size: 16))
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color(.main))
                            .tint(.mainBlue)
                            .frame(minHeight: 60)

                    } else {
                        // Fallback on earlier versions
                        MultilineTextField("Type_Answer_here_".localized, text: $textAnswer, onCommit: {})
                            .font(.regular(size: 16))
                            .frame(minHeight: 60)
                            .background(Color(.messageSenderBg).cornerRadius(7))
                    }
                    Spacer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                }
                .padding(.top, 12)

            default:
                EmptyView()
            }

            // (اختياري) عرض إجابات سابقة
//            if let previous = question.answer, !previous.isEmpty {
//                Divider().padding(.vertical, 6)
//                VStack(alignment: .trailing, spacing: 4) {
//                    ForEach(previous.indices, id: \.self) { idx in
//                        let a = previous[idx]
//                        Text(a.answer ?? "-")
//                            .font(.regular(size: 14))
//                            .foregroundStyle(Color(.secondary))
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                }
//            }
        }
    }
}

// MARK: - MCQ Grid (3 أعمدة Checkboxes)
private struct MCQGrid: View {
    let options: [String]
    @Binding var selected: Set<String>

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .trailing, spacing: 14) {
            ForEach(options, id: \.self) { opt in
                HStack(spacing: 8) {
                    Text(opt)
                        .font(.regular(size: 16))
                        .foregroundColor(.mainBlue)
                    Checkbox(isChecked: selected.contains(opt), action: {
                    }).disabled(true)

                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    if selected.contains(opt) {
                        selected.remove(opt)
                    } else {
                        selected.insert(opt)
                    }
                }
            }
        }
    }
}

// MARK: - RadioRow (نقطة وردية داخل دائرة زرقاء عندما يكون مفعّل)
private struct RadioRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.regular(size: 18))
                .foregroundColor(.mainBlue)

            ZStack {
                Image( isOn ? .radiofill : .radio)
                    .resizable()
                    .frame(width: 17, height: 17)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .contentShape(Rectangle())
        .onTapGesture { isOn.toggle() }
    }
}

#Preview {
    QuestionaireView(CustomerPackageId: 0)
}
