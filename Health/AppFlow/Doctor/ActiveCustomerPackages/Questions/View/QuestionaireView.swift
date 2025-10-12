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
    var CustomerPackageId: Int

    // MARK: - Mock Data
    @State private var questions: [CustomerPackageQuestM] = [
        .init(id: 101, question: "سؤال 1", typeID: 2, answer: nil),
        .init(id: 102, question: "سؤال 2", typeID: 3, answer: nil),
        .init(id: 103, question: "سؤال 3", typeID: 1, answer: nil)
    ]
    private let mcqOptions: [MCQOptions] = [
        .init(questionId: 101, options: ["اختيار 1","اختيار 2","اختيار 3","اختيار 4","اختيار 5","اختيار 6","اختيار 7"])
    ]

    // MARK: - Answers State
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
                    ForEach(questions.indices, id: \.self) { idx in
                        let q = questions[idx]
                        QuestionBlock(
                            index: idx + 1,
                            question: q,
                            mcqOptions: mcqOptions.first(where: { $0.questionId == (q.id ?? -1) })?.options ?? [],
                            textAnswer: Binding(
                                get: { textAnswers[q.id ?? -1] ?? "" },
                                set: { textAnswers[q.id ?? -1] = $0 }
                            ),
                            mcqAnswers: Binding(
                                get: { mcqAnswersMulti[q.id ?? -1] ?? [] },
                                set: { mcqAnswersMulti[q.id ?? -1] = $0 }
                            ),
                            tfAnswer: Binding(
                                get: { tfAnswers[q.id ?? -1] ?? false },
                                set: { tfAnswers[q.id ?? -1] = $0 }
                            )
                        )
                        .padding(.horizontal, 20)
                    }

                    
                    Spacer()
                    
                    CustomButton(title: "save_",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                        submit()
                    }
                    .disabled(isSubmitting)

                }
                .padding(.top, 12)
            }
        }
        .localizeView()
        .showHud(isShowing: .constant(isSubmitting))
        .errorAlert(isPresented: .constant(errorMessage != nil), message: errorMessage)
        .onAppear {
            seedInitialAnswers()
        }
    }

    private func seedInitialAnswers() {
        for q in questions {
            guard let id = q.id else { continue }
            switch QuestionType(rawValue: q.typeID ?? 0) {
            case .text:
                textAnswers[id] = q.answer?.first?.answer ?? ""
            case .mcq:
                // إن وُجدت إجابات سابقة متعددة مفصولة بفواصل (كمثال)
                if let prev = q.answer?.first?.answer, !prev.isEmpty {
                    let set = Set(prev.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
                    mcqAnswersMulti[id] = set
                } else {
                    mcqAnswersMulti[id] = []
                }
            case .trueFalse:
                if let prev = q.answer?.first?.answer?.lowercased() {
                    tfAnswers[id] = (prev == "true" || prev == "yes" || prev == "نعم")
                } else { tfAnswers[id] = false }
            default: break
            }
        }
    }

    private func submit() {
        isSubmitting = true
        errorMessage = nil

        var missing: [Int] = []
        for q in questions {
            guard let id = q.id else { continue }
            switch QuestionType(rawValue: q.typeID ?? 0) {
            case .text:
                if (textAnswers[id]?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                    missing.append(id)
                }
            case .mcq:
                if (mcqAnswersMulti[id]?.isEmpty ?? true) {
                    missing.append(id)
                }
            case .trueFalse:
                // اعتبرناها ليست إجبارية
                break
            default: break
            }
        }

        if !missing.isEmpty {
            errorMessage = "من فضلك أجب على كل الأسئلة المطلوبة".localized
            isSubmitting = false
            return
        }

        var payload: [[String: Any]] = []
        for q in questions {
            guard let id = q.id else { continue }
            switch QuestionType(rawValue: q.typeID ?? 0) {
            case .text:
                payload.append([
                    "questionId": id,
                    "typeId": q.typeID ?? 0,
                    "answer": textAnswers[id] ?? ""
                ])
            case .mcq:
                let selected = Array(mcqAnswersMulti[id] ?? [])
                payload.append([
                    "questionId": id,
                    "typeId": q.typeID ?? 0,
                    // ممكن ترسلها Array أو String مفصول بفواصل حسب الـ API
                    "answer": selected.joined(separator: ",")
                ])
            case .trueFalse:
                payload.append([
                    "questionId": id,
                    "typeId": q.typeID ?? 0,
                    "answer": (tfAnswers[id] ?? false) ? "نعم" : "لا"
                ])
            default: break
            }
        }

        print("Submitting questionnaire for CustomerPackageId: \(CustomerPackageId)")
        print("Payload: \(payload)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isSubmitting = false
        }
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
                        set: { newVal in tfAnswer = true }
                    ))
                    RadioRow(title: "no_".localized, isOn: Binding(
                        get: { !tfAnswer },
                        set: { newVal in tfAnswer = false }
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
            if let previous = question.answer, !previous.isEmpty {
                Divider().padding(.vertical, 6)
                VStack(alignment: .trailing, spacing: 4) {
                    ForEach(previous.indices, id: \.self) { idx in
                        let a = previous[idx]
                        Text(a.answer ?? "-")
                            .font(.regular(size: 14))
                            .foregroundStyle(Color(.secondary))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
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

//                Circle()
//                    .stroke(Color.mainBlue, lineWidth: 3)
//                    .frame(width: 18, height: 18)

//                if isOn {
//                    Circle()
//                        .fill(Color(.secondary)) // وردي
//                        .frame(width: 10, height: 10)
//                }
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
