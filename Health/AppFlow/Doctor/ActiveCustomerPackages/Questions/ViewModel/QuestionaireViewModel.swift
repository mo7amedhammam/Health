//
//  QuestionaireViewModel.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/10/2025.
//

import Foundation

class QuestionaireViewModel : ObservableObject {
    static let shared = QuestionaireViewModel()
    private let networkService: AsyncAwaitNetworkServiceProtocol
        
    var CustomerPackageId : Int?
    @Published var questions : [CustomerPackageQuestM]? = mockQuestions
    @Published var userAnswers: [Int: String] = [:]

    @Published var isLoading:Bool? = false
    @Published var errorMessage: String? = nil
    
    init(networkService: AsyncAwaitNetworkServiceProtocol = AsyncAwaitNetworkService.shared) {
        self.networkService = networkService
    }
}

extension QuestionaireViewModel{
    @MainActor
    func addCustomerQuestionAnswer() async {
        guard let customerPackageId = CustomerPackageId else { return }

        let answersArray: [[String: Any]] = userAnswers.map { (id, value) in
            let typeid = questions?.first(where: { $0.id == id })?.typeID ?? 0
            var answerDict: [String: Any] = [
                "customerPackageId": customerPackageId,
                "packageQuestionId": id,
                "typeId": typeid,
                "answer": value
            ]
            if typeid == 2 {
                answerDict["mcqId"] = 0
            }
            return answerDict
        }
        print("answersArray", answersArray)

        isLoading = true
        defer { isLoading = false }

        // Current endpoint signature is single-object; send first if present
        if let first = answersArray.first {
            let target = DocActivePackagesServices.CreatePackageQuestionnaireAnswer(parameters: first)
            do {
                self.errorMessage = nil
                struct EmptyResponse: Codable {}
                _ = try await networkService.request(target, responseType: EmptyResponse.self)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // New: send multiple answers by iterating single-object endpoint
    @MainActor
    func addAnswers(_ items: [(qid: Int, typeId: Int, answer: String, mcqId: Int?)]) async {
        guard let customerPackageId = CustomerPackageId else { return }
        isLoading = true
        defer { isLoading = false }
        self.errorMessage = nil

        for item in items {
            var dict: [String: Any] = [
                "customerPackageId": customerPackageId,
                "packageQuestionId": item.qid,
                "typeId": item.typeId,
                "answer": item.answer
            ]
            if item.typeId == 2 {
                dict["mcqId"] = item.mcqId ?? 0
            }
            let target = DocActivePackagesServices.CreatePackageQuestionnaireAnswer(parameters: dict)
            do {
                struct EmptyResponse: Codable {}
                _ = try await networkService.request(target, responseType: EmptyResponse.self)
            } catch {
                // Stop on first error and surface message
                self.errorMessage = error.localizedDescription
                break
            }
        }
    }
        
    func updateAnswer(for questionId: Int, answer: String) {
        userAnswers[questionId] = answer
    }
      
    @MainActor
    func getCustomerQuestions() async {
        isLoading = true
        defer { isLoading = false }
        guard let customerPackageId = CustomerPackageId else { return }
        let parametersarr : [String : Any] =  ["CustomerPackageId": customerPackageId]
        let target = DocActivePackagesServices.GetCustomerPackageQuest(parameters: parametersarr)
        do {
            self.errorMessage = nil
            let response = try await networkService.request(
                target,
                responseType: [CustomerPackageQuestM].self
            )
            self.questions = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
