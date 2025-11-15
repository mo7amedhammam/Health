//
//  CustomerPackageQuestM.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//

// MARK: - CustomerPackageQuestM
struct CustomerPackageQuestM: Codable, Equatable {
    static func == (lhs: CustomerPackageQuestM, rhs: CustomerPackageQuestM) -> Bool {
        return lhs.id == rhs.id
    }

    // Top-level id
    var id: Int?

    // Nested question object from backend
    var questionPayload: QuestionPayload?

    // Answers (kept as-is, UI depends on doctorName/doctorId/creationDate)
    var answer: [Answer]?

    enum CodingKeys: String, CodingKey {
        case id
        case questionPayload = "question"
        case answer
    }

    // Backward-compat convenience: expose question text and typeId like before
    var question: String? { questionPayload?.question }
    var typeID: Int? { questionPayload?.typeId }

    // Optional: expose mcq options list
    var mcqList: [MCQItem] { questionPayload?.mcqList ?? [] }
}

// MARK: - QuestionPayload (nested question object)
struct QuestionPayload: Codable, Equatable {
    var id: Int?
    var question: String?
    var typeId: Int?
    var mcqList: [MCQItem]?

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case typeId
        case mcqList
    }
}

// MARK: - MCQItem (items inside question.mcqList)
struct MCQItem: Codable, Equatable {
    var id: Int?
    var answer: String?

    enum CodingKeys: String, CodingKey {
        case id
        case answer
    }
}

// MARK: - Answer
struct Answer: Codable {
    var answer, doctorName: String?
    var doctorID: Int?
    var creationDate: String?

    enum CodingKeys: String, CodingKey {
        case answer, doctorName
        case doctorID = "doctorId"
        case creationDate
    }
}

extension Answer {
    var formattedCreationDate: String? {
//        2025-11-15T11:50:09.47
        guard let date = self.creationDate else { return "" }
        let formatedDate = convertDateToString(
            inputDateString: date,
            inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SS",
            outputDateFormat: "yyyy MMM dd HH:mm a"
        )
        return formatedDate
    }
}

// Updated mock data to reflect the new nested question structure
let mockQuestions: [CustomerPackageQuestM] = [
    // Text question
    CustomerPackageQuestM(
        id: 1,
        questionPayload: QuestionPayload(
            id: 1,
            question: "Describe your current diet.",
            typeId: 1,
            mcqList: []
        ),
        answer: [
            Answer(
                answer: "I usually eat 3 balanced meals per day with fruits and vegetables.",
                doctorName: "Dr. Laila Fathy",
                doctorID: 10,
                creationDate: "2025-10-30T09:10:00"
            ),
            Answer(
                answer: "I usually eat 3 balanced meals per day with fruits and vegetables.",
                doctorName: "Dr. Laila Fathy",
                doctorID: 10,
                creationDate: "2025-10-30T09:10:00"
            )
        ]
    ),

    // MCQ question
    CustomerPackageQuestM(
        id: 2,
        questionPayload: QuestionPayload(
            id: 2,
            question: "How often do you exercise?",
            typeId: 2,
            mcqList: [
                MCQItem(id: 21, answer: "1–2 times per week"),
                MCQItem(id: 22, answer: "3–5 times per week"),
                MCQItem(id: 23, answer: "Daily")
            ]
        ),
        answer: [
            Answer(
                answer: "3–5 times per week",
                doctorName: "Dr. Omar Ali",
                doctorID: 4,
                creationDate: "2025-10-29T18:20:00"
            )
        ]
    ),

    // True/False question
    CustomerPackageQuestM(
        id: 3,
        questionPayload: QuestionPayload(
            id: 3,
            question: "Do you smoke?",
            typeId: 3,
            mcqList: []
        ),
        answer: [
            Answer(
                answer: "false",
                doctorName: "Dr. Ahmed Mansour",
                doctorID: 7,
                creationDate: "2025-10-28T14:35:00"
            )
        ]
    ),

    // Text question
    CustomerPackageQuestM(
        id: 4,
        questionPayload: QuestionPayload(
            id: 4,
            question: "Please list any medications you are currently taking.",
            typeId: 1,
            mcqList: []
        ),
        answer: [
            Answer(
                answer: "Vitamin D supplements, occasional paracetamol.",
                doctorName: "Dr. Hanan Khaled",
                doctorID: 2,
                creationDate: "2025-10-30T08:45:00"
            )
        ]
    ),

    // MCQ question
    CustomerPackageQuestM(
        id: 5,
        questionPayload: QuestionPayload(
            id: 5,
            question: "What is your daily caffeine intake?",
            typeId: 2,
            mcqList: [
                MCQItem(id: 31, answer: "None"),
                MCQItem(id: 32, answer: "1 cup of coffee per day"),
                MCQItem(id: 33, answer: "2 cups of coffee per day")
            ]
        ),
        answer: [
            Answer(
                answer: "1 cup of coffee per day",
                doctorName: "Dr. Rania Adel",
                doctorID: 8,
                creationDate: "2025-10-31T11:00:00"
            ),
            Answer(
                answer: "2 cups of coffee per day",
                doctorName: "Dr. Rania Adel",
                doctorID: 8,
                creationDate: "2025-10-31T11:11:00"
            )
        ]
    ),

    // True/False question
    CustomerPackageQuestM(
        id: 6,
        questionPayload: QuestionPayload(
            id: 6,
            question: "Do you have any known allergies?",
            typeId: 3,
            mcqList: []
        ),
        answer: [
            Answer(
                answer: "true",
                doctorName: "Dr. Laila Fathy",
                doctorID: 10,
                creationDate: "2025-10-31T09:50:00"
            )
        ]
    )
]
