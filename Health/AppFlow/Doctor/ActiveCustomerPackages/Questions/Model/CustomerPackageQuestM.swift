//
//  CustomerPackageQuestM.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/10/2025.
//


// MARK: - CustomerPackageQuestM
struct CustomerPackageQuestM: Codable,Equatable {
    static func == (lhs: CustomerPackageQuestM, rhs: CustomerPackageQuestM) -> Bool {
       return lhs.id == rhs.id
    }
    
    var id: Int?
    var question: String?
    var typeID: Int?
    var answer: [Answer]?

    enum CodingKeys: String, CodingKey {
        case id, question
        case typeID = "typeId"
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
extension Answer{
    var formattedCreationDate: String? {
        guard let date = self.creationDate else { return "" }

        let formatedDate = convertDateToString(inputDateString: date , inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss", outputDateFormat: "yyyy MMM dd HH:mm a")
        return formatedDate // fallback to original string if parsing fails
    }
}

let mockQuestions: [CustomerPackageQuestM] = [
    // Text question
    CustomerPackageQuestM(
        id: 1,
        question: "Describe your current diet.",
        typeID: 1,
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
        question: "How often do you exercise?",
        typeID: 2,
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
        question: "Do you smoke?",
        typeID: 3,
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
        question: "Please list any medications you are currently taking.",
        typeID: 1,
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
        question: "What is your daily caffeine intake?",
        typeID: 2,
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
        question: "Do you have any known allergies?",
        typeID: 3,
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
